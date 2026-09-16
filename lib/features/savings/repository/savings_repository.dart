import 'package:dartz/dartz.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/activity_item.dart';
import '../../../core/models/goal_view.dart';

abstract class ISavingsRepository {
  /// Goals with confirmed and pending amounts kept separate, so the bar can
  /// show "saved" and "on the way" as different segments.
  Stream<List<GoalView>> watchGoals();
  Stream<GoalView?> watchGoal(String clientId);
  Stream<List<ActivityItem>> watchContributions(String clientId);
  Future<Either<Failure, Unit>> refresh();
}
