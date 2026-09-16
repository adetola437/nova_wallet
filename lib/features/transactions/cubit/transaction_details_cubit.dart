import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/activity_item.dart';
import '../../../core/models/outbox_item.dart';
import '../../sync/repository/outbox_repository.dart';

class TransactionDetailsState extends Equatable {
  const TransactionDetailsState({this.activity, this.outbox});

  /// The row the user tapped (settled transactions have only this).
  final ActivityItem? activity;

  /// The live outbox item behind it, when there is one: drives the timeline.
  final OutboxItem? outbox;

  @override
  List<Object?> get props => [activity, outbox];
}

/// Board `2n`. Watches the outbox item so the Queued → Sending → Completed
/// timeline moves while the screen is open.
class TransactionDetailsCubit extends Cubit<TransactionDetailsState> {
  TransactionDetailsCubit({required this.outbox}) : super(const TransactionDetailsState());

  final IOutboxRepository outbox;
  StreamSubscription<OutboxItem?>? _sub;

  void open({ActivityItem? activity, int? outboxId}) {
    emit(TransactionDetailsState(activity: activity));
    final id = outboxId ?? activity?.outboxId;
    if (id == null) return;
    _sub = outbox.watchItem(id).listen(
      (item) {
        if (!isClosed) emit(TransactionDetailsState(activity: state.activity, outbox: item));
      },
      // Keep showing what we have; the row itself is still accurate.
      onError: (Object _) {},
    );
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
