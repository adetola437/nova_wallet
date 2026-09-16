import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/goal_view.dart';
import '../repository/savings_repository.dart';

class SavingsCubit extends Cubit<List<GoalView>> {
  SavingsCubit({required this.repository}) : super(const []);

  final ISavingsRepository repository;
  StreamSubscription<List<GoalView>>? _sub;

  Future<void> start() async {
    if (_sub != null) return;
    _sub = repository.watchGoals().listen((goals) {
      if (!isClosed) emit(goals);
    });
    await repository.refresh();
  }

  Future<void> refresh() => repository.refresh();

  Future<void> reset() async {
    await _sub?.cancel();
    _sub = null;
    if (!isClosed) emit(const []);
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
