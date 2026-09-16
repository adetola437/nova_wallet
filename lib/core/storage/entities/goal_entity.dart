import 'package:isar_community/isar.dart';

import '../../models/goal_view.dart';

part 'goal_entity.g.dart';

@collection
class GoalEntity {
  Id id = Isar.autoIncrement;

  /// Created on the phone so contributions can reference a goal before it syncs.
  @Index(unique: true, replace: true)
  late String clientId;

  late String name;
  late int targetKobo;
  late DateTime targetDate;
  int savedKobo = 0;

  @Enumerated(EnumType.name)
  GoalSyncState syncState = GoalSyncState.pending;

  late DateTime createdAt;

  GoalView toView({required int pendingKobo, int movingKobo = 0}) => GoalView(
    clientId: clientId,
    name: name,
    targetKobo: targetKobo,
    targetDate: targetDate,
    savedKobo: savedKobo,
    pendingKobo: pendingKobo,
    movingKobo: movingKobo,
    syncState: syncState,
    createdAt: createdAt,
  );
}
