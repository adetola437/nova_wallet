import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/activity_item.dart';
import '../../../core/models/goal_view.dart';
import '../repository/savings_repository.dart';

class GoalDetailsState extends Equatable {
  const GoalDetailsState({this.goal, this.contributions = const [], this.loaded = false});

  final GoalView? goal;
  final List<ActivityItem> contributions;
  final bool loaded;

  @override
  List<Object?> get props => [goal, contributions, loaded];
}

/// Board `4d`: one goal and its contribution history, both live.
class GoalDetailsCubit extends Cubit<GoalDetailsState> {
  GoalDetailsCubit({required this.repository}) : super(const GoalDetailsState());

  final ISavingsRepository repository;
  StreamSubscription<GoalView?>? _goalSub;
  StreamSubscription<List<ActivityItem>>? _contribSub;

  void open(String clientId) {
    _goalSub = repository.watchGoal(clientId).listen((goal) {
      if (!isClosed) emit(GoalDetailsState(goal: goal, contributions: state.contributions, loaded: true));
    }, onError: (Object _) {});
    _contribSub = repository.watchContributions(clientId).listen((rows) {
      if (!isClosed) emit(GoalDetailsState(goal: state.goal, contributions: rows, loaded: state.loaded));
    }, onError: (Object _) {});
  }

  @override
  Future<void> close() async {
    await _goalSub?.cancel();
    await _contribSub?.cancel();
    return super.close();
  }
}
