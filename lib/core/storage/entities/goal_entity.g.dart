// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGoalEntityCollection on Isar {
  IsarCollection<GoalEntity> get goalEntitys => this.collection();
}

const GoalEntitySchema = CollectionSchema(
  name: r'GoalEntity',
  id: -5725872661757418951,
  properties: {
    r'clientId': PropertySchema(id: 0, name: r'clientId', type: IsarType.string),
    r'createdAt': PropertySchema(id: 1, name: r'createdAt', type: IsarType.dateTime),
    r'name': PropertySchema(id: 2, name: r'name', type: IsarType.string),
    r'savedKobo': PropertySchema(id: 3, name: r'savedKobo', type: IsarType.long),
    r'syncState': PropertySchema(
      id: 4,
      name: r'syncState',
      type: IsarType.string,
      enumMap: _GoalEntitysyncStateEnumValueMap,
    ),
    r'targetDate': PropertySchema(id: 5, name: r'targetDate', type: IsarType.dateTime),
    r'targetKobo': PropertySchema(id: 6, name: r'targetKobo', type: IsarType.long),
  },

  estimateSize: _goalEntityEstimateSize,
  serialize: _goalEntitySerialize,
  deserialize: _goalEntityDeserialize,
  deserializeProp: _goalEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'clientId': IndexSchema(
      id: 2639372232964765565,
      name: r'clientId',
      unique: true,
      replace: true,
      properties: [IndexPropertySchema(name: r'clientId', type: IndexType.hash, caseSensitive: true)],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _goalEntityGetId,
  getLinks: _goalEntityGetLinks,
  attach: _goalEntityAttach,
  version: '3.3.2',
);

int _goalEntityEstimateSize(GoalEntity object, List<int> offsets, Map<Type, List<int>> allOffsets) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.clientId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.syncState.name.length * 3;
  return bytesCount;
}

void _goalEntitySerialize(GoalEntity object, IsarWriter writer, List<int> offsets, Map<Type, List<int>> allOffsets) {
  writer.writeString(offsets[0], object.clientId);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.name);
  writer.writeLong(offsets[3], object.savedKobo);
  writer.writeString(offsets[4], object.syncState.name);
  writer.writeDateTime(offsets[5], object.targetDate);
  writer.writeLong(offsets[6], object.targetKobo);
}

GoalEntity _goalEntityDeserialize(Id id, IsarReader reader, List<int> offsets, Map<Type, List<int>> allOffsets) {
  final object = GoalEntity();
  object.clientId = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.name = reader.readString(offsets[2]);
  object.savedKobo = reader.readLong(offsets[3]);
  object.syncState = _GoalEntitysyncStateValueEnumMap[reader.readStringOrNull(offsets[4])] ?? GoalSyncState.pending;
  object.targetDate = reader.readDateTime(offsets[5]);
  object.targetKobo = reader.readLong(offsets[6]);
  return object;
}

P _goalEntityDeserializeProp<P>(IsarReader reader, int propertyId, int offset, Map<Type, List<int>> allOffsets) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (_GoalEntitysyncStateValueEnumMap[reader.readStringOrNull(offset)] ?? GoalSyncState.pending) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _GoalEntitysyncStateEnumValueMap = {r'pending': r'pending', r'synced': r'synced', r'failed': r'failed'};
const _GoalEntitysyncStateValueEnumMap = {
  r'pending': GoalSyncState.pending,
  r'synced': GoalSyncState.synced,
  r'failed': GoalSyncState.failed,
};

Id _goalEntityGetId(GoalEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _goalEntityGetLinks(GoalEntity object) {
  return [];
}

void _goalEntityAttach(IsarCollection<dynamic> col, Id id, GoalEntity object) {
  object.id = id;
}

extension GoalEntityByIndex on IsarCollection<GoalEntity> {
  Future<GoalEntity?> getByClientId(String clientId) {
    return getByIndex(r'clientId', [clientId]);
  }

  GoalEntity? getByClientIdSync(String clientId) {
    return getByIndexSync(r'clientId', [clientId]);
  }

  Future<bool> deleteByClientId(String clientId) {
    return deleteByIndex(r'clientId', [clientId]);
  }

  bool deleteByClientIdSync(String clientId) {
    return deleteByIndexSync(r'clientId', [clientId]);
  }

  Future<List<GoalEntity?>> getAllByClientId(List<String> clientIdValues) {
    final values = clientIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'clientId', values);
  }

  List<GoalEntity?> getAllByClientIdSync(List<String> clientIdValues) {
    final values = clientIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'clientId', values);
  }

  Future<int> deleteAllByClientId(List<String> clientIdValues) {
    final values = clientIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'clientId', values);
  }

  int deleteAllByClientIdSync(List<String> clientIdValues) {
    final values = clientIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'clientId', values);
  }

  Future<Id> putByClientId(GoalEntity object) {
    return putByIndex(r'clientId', object);
  }

  Id putByClientIdSync(GoalEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'clientId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByClientId(List<GoalEntity> objects) {
    return putAllByIndex(r'clientId', objects);
  }

  List<Id> putAllByClientIdSync(List<GoalEntity> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'clientId', objects, saveLinks: saveLinks);
  }
}

extension GoalEntityQueryWhereSort on QueryBuilder<GoalEntity, GoalEntity, QWhere> {
  QueryBuilder<GoalEntity, GoalEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GoalEntityQueryWhere on QueryBuilder<GoalEntity, GoalEntity, QWhereClause> {
  QueryBuilder<GoalEntity, GoalEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: false))
            .addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: false));
      } else {
        return query
            .addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: false))
            .addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: false));
      }
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: include));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: include));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(lower: lowerId, includeLower: includeLower, upper: upperId, includeUpper: includeUpper),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterWhereClause> clientIdEqualTo(String clientId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(indexName: r'clientId', value: [clientId]));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterWhereClause> clientIdNotEqualTo(String clientId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(indexName: r'clientId', lower: [], upper: [clientId], includeUpper: false),
            )
            .addWhereClause(
              IndexWhereClause.between(indexName: r'clientId', lower: [clientId], includeLower: false, upper: []),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(indexName: r'clientId', lower: [clientId], includeLower: false, upper: []),
            )
            .addWhereClause(
              IndexWhereClause.between(indexName: r'clientId', lower: [], upper: [clientId], includeUpper: false),
            );
      }
    });
  }
}

extension GoalEntityQueryFilter on QueryBuilder<GoalEntity, GoalEntity, QFilterCondition> {
  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> clientIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'clientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> clientIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'clientId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> clientIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'clientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> clientIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'clientId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> clientIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'clientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> clientIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'clientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> clientIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'clientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> clientIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'clientId', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> clientIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'clientId', value: ''));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> clientIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'clientId', value: ''));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'createdAt', value: value));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'createdAt', value: value));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'id', value: value));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'name', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'name', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'name', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'name', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'name', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'name', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'name', value: ''));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'name', value: ''));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> savedKoboEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'savedKobo', value: value));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> savedKoboGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'savedKobo', value: value),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> savedKoboLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'savedKobo', value: value));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> savedKoboBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'savedKobo',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> syncStateEqualTo(
    GoalSyncState value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncState', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> syncStateGreaterThan(
    GoalSyncState value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'syncState',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> syncStateLessThan(
    GoalSyncState value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'syncState', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> syncStateBetween(
    GoalSyncState lower,
    GoalSyncState upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'syncState',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> syncStateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'syncState', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> syncStateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'syncState', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> syncStateContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'syncState', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> syncStateMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'syncState', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> syncStateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'syncState', value: ''));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> syncStateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'syncState', value: ''));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> targetDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'targetDate', value: value));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> targetDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'targetDate', value: value),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> targetDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'targetDate', value: value),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> targetDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> targetKoboEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'targetKobo', value: value));
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> targetKoboGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'targetKobo', value: value),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> targetKoboLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'targetKobo', value: value),
      );
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterFilterCondition> targetKoboBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetKobo',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension GoalEntityQueryObject on QueryBuilder<GoalEntity, GoalEntity, QFilterCondition> {}

extension GoalEntityQueryLinks on QueryBuilder<GoalEntity, GoalEntity, QFilterCondition> {}

extension GoalEntityQuerySortBy on QueryBuilder<GoalEntity, GoalEntity, QSortBy> {
  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> sortByClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.asc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> sortByClientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.desc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> sortBySavedKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedKobo', Sort.asc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> sortBySavedKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedKobo', Sort.desc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> sortBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> sortBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> sortByTargetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDate', Sort.asc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> sortByTargetDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDate', Sort.desc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> sortByTargetKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetKobo', Sort.asc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> sortByTargetKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetKobo', Sort.desc);
    });
  }
}

extension GoalEntityQuerySortThenBy on QueryBuilder<GoalEntity, GoalEntity, QSortThenBy> {
  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> thenByClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.asc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> thenByClientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.desc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> thenBySavedKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedKobo', Sort.asc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> thenBySavedKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedKobo', Sort.desc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> thenBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> thenBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> thenByTargetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDate', Sort.asc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> thenByTargetDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDate', Sort.desc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> thenByTargetKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetKobo', Sort.asc);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QAfterSortBy> thenByTargetKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetKobo', Sort.desc);
    });
  }
}

extension GoalEntityQueryWhereDistinct on QueryBuilder<GoalEntity, GoalEntity, QDistinct> {
  QueryBuilder<GoalEntity, GoalEntity, QDistinct> distinctByClientId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QDistinct> distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QDistinct> distinctBySavedKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'savedKobo');
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QDistinct> distinctBySyncState({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncState', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QDistinct> distinctByTargetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetDate');
    });
  }

  QueryBuilder<GoalEntity, GoalEntity, QDistinct> distinctByTargetKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetKobo');
    });
  }
}

extension GoalEntityQueryProperty on QueryBuilder<GoalEntity, GoalEntity, QQueryProperty> {
  QueryBuilder<GoalEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GoalEntity, String, QQueryOperations> clientIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientId');
    });
  }

  QueryBuilder<GoalEntity, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<GoalEntity, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<GoalEntity, int, QQueryOperations> savedKoboProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'savedKobo');
    });
  }

  QueryBuilder<GoalEntity, GoalSyncState, QQueryOperations> syncStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncState');
    });
  }

  QueryBuilder<GoalEntity, DateTime, QQueryOperations> targetDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetDate');
    });
  }

  QueryBuilder<GoalEntity, int, QQueryOperations> targetKoboProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetKobo');
    });
  }
}
