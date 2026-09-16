import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/activity_item.dart';
import '../models/outbox_item.dart';
import '../money/money.dart';
import 'sync_notifier.dart';

/// Local notifications for every major money event: a transfer settling or
/// failing, a goal created, a contribution saved, and money received.
///
/// Tapping one emits its payload on [taps] (`outbox:<id>` or `txn:<ref>`); the
/// app shell turns that into navigation.
class LocalNotificationService implements SyncNotifier {
  LocalNotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  final StreamController<String> _taps = StreamController<String>.broadcast();
  bool _ready = false;
  bool _permissionAsked = false;

  static const AndroidNotificationChannel _activityChannel = AndroidNotificationChannel(
    'nova_sync',
    'Transfers and savings',
    description: 'Tells you when a transfer, goal or contribution goes through.',
    importance: Importance.high,
  );

  static const AndroidNotificationChannel _creditChannel = AndroidNotificationChannel(
    'nova_credit',
    'Money received',
    description: 'Tells you when money arrives in your wallet.',
    importance: Importance.high,
  );

  /// Credits get ids in their own range so they never replace an outbox item's
  /// notification.
  static const int _creditIdBase = 0x40000000;

  Stream<String> get taps => _taps.stream;

  Future<void> init() async {
    if (_ready) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: darwin),
      onDidReceiveNotificationResponse: (response) => _emitTap(response.payload),
    );
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(_activityChannel);
    await androidImpl?.createNotificationChannel(_creditChannel);
    _ready = true;
  }

  /// The payload of the notification that launched the app from cold, if any.
  Future<String?> launchPayload() async {
    if (!_ready) return null;
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details == null || !details.didNotificationLaunchApp) return null;
    return details.notificationResponse?.payload;
  }

  /// Asked once per run, after the user has signed in — never on the splash.
  Future<void> requestPermission() async {
    if (!_ready || _permissionAsked) return;
    _permissionAsked = true;
    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      return;
    }
    await _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  @override
  Future<void> syncSucceeded(OutboxItem item) => _show(
    id: item.id,
    channel: _activityChannel,
    payload: 'outbox:${item.id}',
    title: switch (item.type) {
      OutboxType.send => 'Transfer sent',
      OutboxType.contribute => 'Saved to your goal',
      OutboxType.createGoal => 'Goal created',
      OutboxType.moveToWallet => 'Moved to your wallet',
    },
    body: switch (item.type) {
      OutboxType.send =>
        '${Money(item.amountKobo).format()} sent to ${item.counterpartyName ?? 'your recipient'}'
            '${item.feeKobo > 0 ? ' (fee ${Money(item.feeKobo).format()})' : ''}.',
      OutboxType.contribute => '${Money(item.amountKobo).format()} added to ${item.counterpartyName ?? 'your goal'}.',
      OutboxType.createGoal => '${item.counterpartyName ?? 'Your goal'} is ready. Start saving towards it.',
      OutboxType.moveToWallet =>
        '${Money(item.amountKobo - item.feeKobo).format()} moved from ${item.counterpartyName ?? 'your goal'} '
            'to your wallet${item.feeKobo > 0 ? ' (early break fee ${Money(item.feeKobo).format()})' : ''}.',
    },
  );

  @override
  Future<void> syncFailed(OutboxItem item) => _show(
    id: item.id,
    channel: _activityChannel,
    payload: 'outbox:${item.id}',
    title: switch (item.type) {
      OutboxType.send => 'Transfer failed',
      OutboxType.contribute => "Couldn't save to your goal",
      OutboxType.createGoal => "Couldn't create your goal",
      OutboxType.moveToWallet => "Couldn't move money to your wallet",
    },
    body: item.failureMessage ?? 'Open NovaPay to see what happened.',
  );

  @override
  Future<void> paymentReceived(ActivityItem credit) => _show(
    id: _creditIdBase | ((credit.serverRef ?? credit.id).hashCode & 0x3fffffff),
    channel: _creditChannel,
    payload: 'home',
    title: 'Money received',
    body: '${Money(credit.amountKobo).format()} from ${credit.title}.',
  );

  Future<void> _show({
    required int id,
    required AndroidNotificationChannel channel,
    required String payload,
    required String title,
    required String body,
  }) async {
    if (!_ready) return;
    try {
      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            styleInformation: BigTextStyleInformation(body),
          ),
          iOS: const DarwinNotificationDetails(presentAlert: true, presentBanner: true, presentSound: true),
        ),
        payload: payload,
      );
    } catch (_) {
      // A notification is a courtesy; failing to show one must never fail a sync.
    }
  }

  void _emitTap(String? payload) {
    if (payload != null && payload.isNotEmpty && !_taps.isClosed) _taps.add(payload);
  }
}
