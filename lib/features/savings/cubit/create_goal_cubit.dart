import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/api/exception/failure.dart';
import '../../../core/money/kobo_parser.dart';
import '../../../core/money/progress.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../sync/cubit/sync_cubit.dart';
import '../../sync/repository/outbox_repository.dart';
import 'create_goal_state.dart';

class CreateGoalCubit extends Cubit<CreateGoalState> {
  CreateGoalCubit({
    required this.outbox,
    required this.sync,
    required this.connectivity,
    Uuid? uuid,
    DateTime Function()? clock,
  }) : _uuid = uuid ?? const Uuid(),
       _clock = clock ?? DateTime.now,
       super(const CreateGoalState());

  final IOutboxRepository outbox;
  final SyncCubit sync;
  final ConnectivityCubit connectivity;
  final Uuid _uuid;
  final DateTime Function() _clock;

  void nameChanged(String value) => emit(state.copyWith(name: value, clearFailure: true));

  void targetChanged(String value) {
    emit(state.copyWith(targetText: value, clearFailure: true));
    _recomputeSuggestion();
  }

  void dateChanged(DateTime value) {
    emit(state.copyWith(targetDate: value, clearFailure: true));
    _recomputeSuggestion();
  }

  void _recomputeSuggestion() {
    final target = KoboParser.parse(state.targetText).fold((_) => null, (kobo) => kobo);
    final date = state.targetDate;
    if (target == null || date == null) return;
    emit(
      state.copyWith(
        suggestedWeeklyKobo: Progress.suggestedWeeklyKobo(remainingKobo: target, from: _clock(), targetDate: date),
      ),
    );
  }

  Future<void> submit() async {
    if (state.isSubmitting) return;

    final name = state.name.trim();
    if (name.isEmpty || name.length > 40) {
      emit(
        state.copyWith(failure: const ValidationFailure(ValidationCode.invalidInput, 'Give your goal a short name.')),
      );
      return;
    }
    final target = KoboParser.parse(state.targetText).fold((_) => null, (kobo) => kobo);
    if (target == null) {
      emit(
        state.copyWith(failure: const ValidationFailure(ValidationCode.invalidInput, 'Enter a valid target amount.')),
      );
      return;
    }
    if (target < AppConstants.minGoalTargetKobo) {
      emit(
        state.copyWith(
          failure: const ValidationFailure(ValidationCode.amountTooSmall, 'The smallest goal is ₦1,000.00.'),
        ),
      );
      return;
    }
    final date = state.targetDate;
    final today = _clock();
    if (date == null || !date.isAfter(DateTime(today.year, today.month, today.day))) {
      emit(state.copyWith(failure: const ValidationFailure(ValidationCode.invalidInput, 'Pick a date in the future.')));
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearFailure: true));
    // Queued like any other action, so creating a goal works offline too.
    final result = await outbox.enqueueCreateGoal(
      draft: CreateGoalDraft(clientId: _uuid.v4(), name: name, targetKobo: target, targetDate: date),
      online: connectivity.isOnline,
    );
    if (isClosed) return;
    result.fold((failure) => emit(state.copyWith(isSubmitting: false, failure: failure)), (item) {
      emit(state.copyWith(isSubmitting: false, created: item, clearFailure: true));
      unawaited(sync.drain());
    });
  }
}
