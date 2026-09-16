import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/network/reachability.dart';

enum ConnectivityStatus { unknown, online, offline }

/// App-wide online/offline signal (offline banner, sync trigger).
///
/// Offline is reported immediately so the UI never promises an instant send it
/// can't make. Online is debounced so a flapping connection triggers one
/// replay, not five.
class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  ConnectivityCubit({required this.reachability, this.onlineDebounce = AppConstants.connectivityDebounce})
    : super(ConnectivityStatus.unknown);

  final Reachability reachability;
  final Duration onlineDebounce;

  StreamSubscription<bool>? _sub;
  Timer? _debounce;

  bool get isOnline => state == ConnectivityStatus.online;

  Future<void> start() async {
    if (_sub != null) return;
    _sub = reachability.onChanged.listen(_onRaw);
    final reachable = await reachability.isReachable;
    if (!isClosed) {
      emit(reachable ? ConnectivityStatus.online : ConnectivityStatus.offline);
    }
  }

  /// Called on app resume. The OS may not have sent an event while suspended.
  Future<void> recheck() async => _onRaw(await reachability.isReachable);

  void _onRaw(bool reachable) {
    _debounce?.cancel();
    if (!reachable) {
      if (state != ConnectivityStatus.offline && !isClosed) {
        emit(ConnectivityStatus.offline);
      }
      return;
    }
    if (state == ConnectivityStatus.online) return;
    _debounce = Timer(onlineDebounce, () {
      if (!isClosed) emit(ConnectivityStatus.online);
    });
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    await _sub?.cancel();
    return super.close();
  }
}
