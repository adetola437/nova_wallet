// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outbox_item_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOutboxItemEntityCollection on Isar {
  IsarCollection<OutboxItemEntity> get outboxItemEntitys => this.collection();
}

const OutboxItemEntitySchema = CollectionSchema(
  name: r'OutboxItemEntity',
  id: -4198280705973479166,
  properties: {
    r'amountKobo': PropertySchema(id: 0, name: r'amountKobo', type: IsarType.long),
    r'attempts': PropertySchema(id: 1, name: r'attempts', type: IsarType.long),
    r'biometricSignature': PropertySchema(id: 2, name: r'biometricSignature', type: IsarType.string),
    r'completedAt': PropertySchema(id: 3, name: r'completedAt', type: IsarType.dateTime),
    r'counterpartyBank': PropertySchema(id: 4, name: r'counterpartyBank', type: IsarType.string),
    r'counterpartyName': PropertySchema(id: 5, name: r'counterpartyName', type: IsarType.string),
    r'createdAt': PropertySchema(id: 6, name: r'createdAt', type: IsarType.dateTime),
    r'failureCode': PropertySchema(id: 7, name: r'failureCode', type: IsarType.string),
    r'failureMessage': PropertySchema(id: 8, name: r'failureMessage', type: IsarType.string),
    r'feeKobo': PropertySchema(id: 9, name: r'feeKobo', type: IsarType.long),
    r'goalClientId': PropertySchema(id: 10, name: r'goalClientId', type: IsarType.string),
    r'idempotencyKey': PropertySchema(id: 11, name: r'idempotencyKey', type: IsarType.string),
    r'lastAttemptAt': PropertySchema(id: 12, name: r'lastAttemptAt', type: IsarType.dateTime),
    r'maskedAccount': PropertySchema(id: 13, name: r'maskedAccount', type: IsarType.string),
    r'narration': PropertySchema(id: 14, name: r'narration', type: IsarType.string),
    r'nextAttemptAt': PropertySchema(id: 15, name: r'nextAttemptAt', type: IsarType.dateTime),
    r'payloadJson': PropertySchema(id: 16, name: r'payloadJson', type: IsarType.string),
    r'queuedWhileOffline': PropertySchema(id: 17, name: r'queuedWhileOffline', type: IsarType.bool),
    r'serverRef': PropertySchema(id: 18, name: r'serverRef', type: IsarType.string),
    r'status': PropertySchema(
      id: 19,
      name: r'status',
      type: IsarType.string,
      enumMap: _OutboxItemEntitystatusEnumValueMap,
    ),
    r'type': PropertySchema(id: 20, name: r'type', type: IsarType.string, enumMap: _OutboxItemEntitytypeEnumValueMap),
  },

  estimateSize: _outboxItemEntityEstimateSize,
  serialize: _outboxItemEntitySerialize,
  deserialize: _outboxItemEntityDeserialize,
  deserializeProp: _outboxItemEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'idempotencyKey': IndexSchema(
      id: 6522471565226449816,
      name: r'idempotencyKey',
      unique: true,
      replace: false,
      properties: [IndexPropertySchema(name: r'idempotencyKey', type: IndexType.hash, caseSensitive: true)],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [IndexPropertySchema(name: r'status', type: IndexType.hash, caseSensitive: true)],
    ),
    r'goalClientId': IndexSchema(
      id: -2575398997715841279,
      name: r'goalClientId',
      unique: false,
      replace: false,
      properties: [IndexPropertySchema(name: r'goalClientId', type: IndexType.hash, caseSensitive: true)],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _outboxItemEntityGetId,
  getLinks: _outboxItemEntityGetLinks,
  attach: _outboxItemEntityAttach,
  version: '3.3.2',
);

int _outboxItemEntityEstimateSize(OutboxItemEntity object, List<int> offsets, Map<Type, List<int>> allOffsets) {
  var bytesCount = offsets.last;
  {
    final value = object.biometricSignature;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.counterpartyBank;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.counterpartyName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.failureCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.failureMessage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.goalClientId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.idempotencyKey.length * 3;
  {
    final value = object.maskedAccount;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.narration;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.payloadJson.length * 3;
  {
    final value = object.serverRef;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.status.name.length * 3;
  bytesCount += 3 + object.type.name.length * 3;
  return bytesCount;
}

void _outboxItemEntitySerialize(
  OutboxItemEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amountKobo);
  writer.writeLong(offsets[1], object.attempts);
  writer.writeString(offsets[2], object.biometricSignature);
  writer.writeDateTime(offsets[3], object.completedAt);
  writer.writeString(offsets[4], object.counterpartyBank);
  writer.writeString(offsets[5], object.counterpartyName);
  writer.writeDateTime(offsets[6], object.createdAt);
  writer.writeString(offsets[7], object.failureCode);
  writer.writeString(offsets[8], object.failureMessage);
  writer.writeLong(offsets[9], object.feeKobo);
  writer.writeString(offsets[10], object.goalClientId);
  writer.writeString(offsets[11], object.idempotencyKey);
  writer.writeDateTime(offsets[12], object.lastAttemptAt);
  writer.writeString(offsets[13], object.maskedAccount);
  writer.writeString(offsets[14], object.narration);
  writer.writeDateTime(offsets[15], object.nextAttemptAt);
  writer.writeString(offsets[16], object.payloadJson);
  writer.writeBool(offsets[17], object.queuedWhileOffline);
  writer.writeString(offsets[18], object.serverRef);
  writer.writeString(offsets[19], object.status.name);
  writer.writeString(offsets[20], object.type.name);
}

OutboxItemEntity _outboxItemEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OutboxItemEntity();
  object.amountKobo = reader.readLong(offsets[0]);
  object.attempts = reader.readLong(offsets[1]);
  object.biometricSignature = reader.readStringOrNull(offsets[2]);
  object.completedAt = reader.readDateTimeOrNull(offsets[3]);
  object.counterpartyBank = reader.readStringOrNull(offsets[4]);
  object.counterpartyName = reader.readStringOrNull(offsets[5]);
  object.createdAt = reader.readDateTime(offsets[6]);
  object.failureCode = reader.readStringOrNull(offsets[7]);
  object.failureMessage = reader.readStringOrNull(offsets[8]);
  object.feeKobo = reader.readLong(offsets[9]);
  object.goalClientId = reader.readStringOrNull(offsets[10]);
  object.id = id;
  object.idempotencyKey = reader.readString(offsets[11]);
  object.lastAttemptAt = reader.readDateTimeOrNull(offsets[12]);
  object.maskedAccount = reader.readStringOrNull(offsets[13]);
  object.narration = reader.readStringOrNull(offsets[14]);
  object.nextAttemptAt = reader.readDateTimeOrNull(offsets[15]);
  object.payloadJson = reader.readString(offsets[16]);
  object.queuedWhileOffline = reader.readBool(offsets[17]);
  object.serverRef = reader.readStringOrNull(offsets[18]);
  object.status = _OutboxItemEntitystatusValueEnumMap[reader.readStringOrNull(offsets[19])] ?? OutboxStatus.queued;
  object.type = _OutboxItemEntitytypeValueEnumMap[reader.readStringOrNull(offsets[20])] ?? OutboxType.send;
  return object;
}

P _outboxItemEntityDeserializeProp<P>(IsarReader reader, int propertyId, int offset, Map<Type, List<int>> allOffsets) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readBool(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (_OutboxItemEntitystatusValueEnumMap[reader.readStringOrNull(offset)] ?? OutboxStatus.queued) as P;
    case 20:
      return (_OutboxItemEntitytypeValueEnumMap[reader.readStringOrNull(offset)] ?? OutboxType.send) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _OutboxItemEntitystatusEnumValueMap = {
  r'queued': r'queued',
  r'sending': r'sending',
  r'succeeded': r'succeeded',
  r'failed': r'failed',
};
const _OutboxItemEntitystatusValueEnumMap = {
  r'queued': OutboxStatus.queued,
  r'sending': OutboxStatus.sending,
  r'succeeded': OutboxStatus.succeeded,
  r'failed': OutboxStatus.failed,
};
const _OutboxItemEntitytypeEnumValueMap = {
  r'send': r'send',
  r'createGoal': r'createGoal',
  r'contribute': r'contribute',
  r'moveToWallet': r'moveToWallet',
};
const _OutboxItemEntitytypeValueEnumMap = {
  r'send': OutboxType.send,
  r'createGoal': OutboxType.createGoal,
  r'contribute': OutboxType.contribute,
  r'moveToWallet': OutboxType.moveToWallet,
};

Id _outboxItemEntityGetId(OutboxItemEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _outboxItemEntityGetLinks(OutboxItemEntity object) {
  return [];
}

void _outboxItemEntityAttach(IsarCollection<dynamic> col, Id id, OutboxItemEntity object) {
  object.id = id;
}

extension OutboxItemEntityByIndex on IsarCollection<OutboxItemEntity> {
  Future<OutboxItemEntity?> getByIdempotencyKey(String idempotencyKey) {
    return getByIndex(r'idempotencyKey', [idempotencyKey]);
  }

  OutboxItemEntity? getByIdempotencyKeySync(String idempotencyKey) {
    return getByIndexSync(r'idempotencyKey', [idempotencyKey]);
  }

  Future<bool> deleteByIdempotencyKey(String idempotencyKey) {
    return deleteByIndex(r'idempotencyKey', [idempotencyKey]);
  }

  bool deleteByIdempotencyKeySync(String idempotencyKey) {
    return deleteByIndexSync(r'idempotencyKey', [idempotencyKey]);
  }

  Future<List<OutboxItemEntity?>> getAllByIdempotencyKey(List<String> idempotencyKeyValues) {
    final values = idempotencyKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'idempotencyKey', values);
  }

  List<OutboxItemEntity?> getAllByIdempotencyKeySync(List<String> idempotencyKeyValues) {
    final values = idempotencyKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idempotencyKey', values);
  }

  Future<int> deleteAllByIdempotencyKey(List<String> idempotencyKeyValues) {
    final values = idempotencyKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idempotencyKey', values);
  }

  int deleteAllByIdempotencyKeySync(List<String> idempotencyKeyValues) {
    final values = idempotencyKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idempotencyKey', values);
  }

  Future<Id> putByIdempotencyKey(OutboxItemEntity object) {
    return putByIndex(r'idempotencyKey', object);
  }

  Id putByIdempotencyKeySync(OutboxItemEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'idempotencyKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdempotencyKey(List<OutboxItemEntity> objects) {
    return putAllByIndex(r'idempotencyKey', objects);
  }

  List<Id> putAllByIdempotencyKeySync(List<OutboxItemEntity> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'idempotencyKey', objects, saveLinks: saveLinks);
  }
}

extension OutboxItemEntityQueryWhereSort on QueryBuilder<OutboxItemEntity, OutboxItemEntity, QWhere> {
  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OutboxItemEntityQueryWhere on QueryBuilder<OutboxItemEntity, OutboxItemEntity, QWhereClause> {
  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: include));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: include));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterWhereClause> idempotencyKeyEqualTo(String idempotencyKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(indexName: r'idempotencyKey', value: [idempotencyKey]));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterWhereClause> idempotencyKeyNotEqualTo(String idempotencyKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'idempotencyKey',
                lower: [],
                upper: [idempotencyKey],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'idempotencyKey',
                lower: [idempotencyKey],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'idempotencyKey',
                lower: [idempotencyKey],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'idempotencyKey',
                lower: [],
                upper: [idempotencyKey],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterWhereClause> statusEqualTo(OutboxStatus status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(indexName: r'status', value: [status]));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterWhereClause> statusNotEqualTo(OutboxStatus status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(indexName: r'status', lower: [], upper: [status], includeUpper: false),
            )
            .addWhereClause(
              IndexWhereClause.between(indexName: r'status', lower: [status], includeLower: false, upper: []),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(indexName: r'status', lower: [status], includeLower: false, upper: []),
            )
            .addWhereClause(
              IndexWhereClause.between(indexName: r'status', lower: [], upper: [status], includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterWhereClause> goalClientIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(indexName: r'goalClientId', value: [null]));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterWhereClause> goalClientIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(indexName: r'goalClientId', lower: [null], includeLower: false, upper: []),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterWhereClause> goalClientIdEqualTo(String? goalClientId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(indexName: r'goalClientId', value: [goalClientId]));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterWhereClause> goalClientIdNotEqualTo(String? goalClientId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'goalClientId',
                lower: [],
                upper: [goalClientId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'goalClientId',
                lower: [goalClientId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'goalClientId',
                lower: [goalClientId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'goalClientId',
                lower: [],
                upper: [goalClientId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension OutboxItemEntityQueryFilter on QueryBuilder<OutboxItemEntity, OutboxItemEntity, QFilterCondition> {
  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> amountKoboEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'amountKobo', value: value));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> amountKoboGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'amountKobo', value: value),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> amountKoboLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'amountKobo', value: value),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> amountKoboBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'amountKobo',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> attemptsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'attempts', value: value));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> attemptsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'attempts', value: value),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> attemptsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'attempts', value: value));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> attemptsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'attempts',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> biometricSignatureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'biometricSignature'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> biometricSignatureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'biometricSignature'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> biometricSignatureEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'biometricSignature', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> biometricSignatureGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'biometricSignature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> biometricSignatureLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'biometricSignature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> biometricSignatureBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'biometricSignature',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> biometricSignatureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'biometricSignature', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> biometricSignatureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'biometricSignature', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> biometricSignatureContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'biometricSignature', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> biometricSignatureMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'biometricSignature', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> biometricSignatureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'biometricSignature', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> biometricSignatureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'biometricSignature', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'completedAt'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'completedAt'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'completedAt', value: value));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'completedAt', value: value),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'completedAt', value: value),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'completedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyBankIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'counterpartyBank'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyBankIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'counterpartyBank'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyBankEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'counterpartyBank', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyBankGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'counterpartyBank',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyBankLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'counterpartyBank',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyBankBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'counterpartyBank',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyBankStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'counterpartyBank', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyBankEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'counterpartyBank', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyBankContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'counterpartyBank', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyBankMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'counterpartyBank', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyBankIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'counterpartyBank', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyBankIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'counterpartyBank', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'counterpartyName'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'counterpartyName'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'counterpartyName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'counterpartyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'counterpartyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'counterpartyName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'counterpartyName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'counterpartyName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'counterpartyName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'counterpartyName', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'counterpartyName', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> counterpartyNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'counterpartyName', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'createdAt', value: value));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'createdAt', value: value));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'failureCode'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'failureCode'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureCodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'failureCode', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'failureCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'failureCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'failureCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'failureCode', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'failureCode', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureCodeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'failureCode', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureCodeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'failureCode', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'failureCode', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'failureCode', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureMessageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'failureMessage'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureMessageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'failureMessage'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureMessageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'failureMessage', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureMessageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'failureMessage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureMessageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'failureMessage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureMessageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'failureMessage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureMessageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'failureMessage', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureMessageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'failureMessage', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureMessageContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'failureMessage', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureMessageMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'failureMessage', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureMessageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'failureMessage', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> failureMessageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'failureMessage', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> feeKoboEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'feeKobo', value: value));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> feeKoboGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'feeKobo', value: value),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> feeKoboLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'feeKobo', value: value));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> feeKoboBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'feeKobo',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> goalClientIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'goalClientId'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> goalClientIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'goalClientId'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> goalClientIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'goalClientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> goalClientIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'goalClientId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> goalClientIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'goalClientId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> goalClientIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'goalClientId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> goalClientIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'goalClientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> goalClientIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'goalClientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> goalClientIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'goalClientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> goalClientIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'goalClientId', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> goalClientIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'goalClientId', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> goalClientIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'goalClientId', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'id', value: value));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> idempotencyKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'idempotencyKey', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> idempotencyKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'idempotencyKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> idempotencyKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'idempotencyKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> idempotencyKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'idempotencyKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> idempotencyKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'idempotencyKey', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> idempotencyKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'idempotencyKey', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> idempotencyKeyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'idempotencyKey', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> idempotencyKeyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'idempotencyKey', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> idempotencyKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'idempotencyKey', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> idempotencyKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'idempotencyKey', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> lastAttemptAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'lastAttemptAt'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> lastAttemptAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'lastAttemptAt'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> lastAttemptAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'lastAttemptAt', value: value));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> lastAttemptAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'lastAttemptAt', value: value),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> lastAttemptAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'lastAttemptAt', value: value),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> lastAttemptAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastAttemptAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> maskedAccountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'maskedAccount'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> maskedAccountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'maskedAccount'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> maskedAccountEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'maskedAccount', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> maskedAccountGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'maskedAccount',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> maskedAccountLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'maskedAccount',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> maskedAccountBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'maskedAccount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> maskedAccountStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'maskedAccount', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> maskedAccountEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'maskedAccount', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> maskedAccountContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'maskedAccount', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> maskedAccountMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'maskedAccount', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> maskedAccountIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'maskedAccount', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> maskedAccountIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'maskedAccount', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> narrationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'narration'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> narrationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'narration'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> narrationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'narration', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> narrationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'narration',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> narrationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'narration', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> narrationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'narration',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> narrationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'narration', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> narrationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'narration', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> narrationContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'narration', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> narrationMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'narration', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> narrationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'narration', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> narrationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'narration', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> nextAttemptAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'nextAttemptAt'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> nextAttemptAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'nextAttemptAt'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> nextAttemptAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'nextAttemptAt', value: value));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> nextAttemptAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'nextAttemptAt', value: value),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> nextAttemptAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'nextAttemptAt', value: value),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> nextAttemptAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nextAttemptAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> payloadJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'payloadJson', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> payloadJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'payloadJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> payloadJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'payloadJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> payloadJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'payloadJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> payloadJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'payloadJson', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> payloadJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'payloadJson', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> payloadJsonContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'payloadJson', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> payloadJsonMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'payloadJson', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> payloadJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'payloadJson', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> payloadJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'payloadJson', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> queuedWhileOfflineEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'queuedWhileOffline', value: value));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> serverRefIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'serverRef'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> serverRefIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'serverRef'));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> serverRefEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'serverRef', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> serverRefGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'serverRef',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> serverRefLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'serverRef', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> serverRefBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'serverRef',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> serverRefStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'serverRef', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> serverRefEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'serverRef', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> serverRefContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'serverRef', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> serverRefMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'serverRef', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> serverRefIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'serverRef', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> serverRefIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'serverRef', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> statusEqualTo(
    OutboxStatus value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> statusGreaterThan(
    OutboxStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'status', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> statusLessThan(
    OutboxStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'status', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> statusBetween(
    OutboxStatus lower,
    OutboxStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'status', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'status', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> statusContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'status', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> statusMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'status', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'status', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'status', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> typeEqualTo(
    OutboxType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> typeGreaterThan(
    OutboxType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'type', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> typeLessThan(
    OutboxType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'type', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> typeBetween(
    OutboxType lower,
    OutboxType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'type', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'type', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> typeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'type', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> typeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'type', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'type', value: ''));
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'type', value: ''));
    });
  }
}

extension OutboxItemEntityQueryObject on QueryBuilder<OutboxItemEntity, OutboxItemEntity, QFilterCondition> {}

extension OutboxItemEntityQueryLinks on QueryBuilder<OutboxItemEntity, OutboxItemEntity, QFilterCondition> {}

extension OutboxItemEntityQuerySortBy on QueryBuilder<OutboxItemEntity, OutboxItemEntity, QSortBy> {
  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByAmountKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountKobo', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByAmountKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountKobo', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByAttemptsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByBiometricSignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biometricSignature', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByBiometricSignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biometricSignature', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByCounterpartyBank() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyBank', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByCounterpartyBankDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyBank', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByCounterpartyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyName', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByCounterpartyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyName', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByFailureCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failureCode', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByFailureCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failureCode', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByFailureMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failureMessage', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByFailureMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failureMessage', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByFeeKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeKobo', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByFeeKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeKobo', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByGoalClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalClientId', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByGoalClientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalClientId', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByIdempotencyKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByIdempotencyKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByLastAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAt', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByLastAttemptAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAt', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByMaskedAccount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maskedAccount', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByMaskedAccountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maskedAccount', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByNarration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narration', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByNarrationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narration', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByNextAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextAttemptAt', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByNextAttemptAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextAttemptAt', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByQueuedWhileOffline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queuedWhileOffline', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByQueuedWhileOfflineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queuedWhileOffline', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByServerRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRef', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByServerRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRef', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension OutboxItemEntityQuerySortThenBy on QueryBuilder<OutboxItemEntity, OutboxItemEntity, QSortThenBy> {
  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByAmountKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountKobo', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByAmountKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountKobo', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByAttemptsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByBiometricSignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biometricSignature', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByBiometricSignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biometricSignature', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByCounterpartyBank() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyBank', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByCounterpartyBankDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyBank', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByCounterpartyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyName', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByCounterpartyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyName', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByFailureCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failureCode', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByFailureCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failureCode', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByFailureMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failureMessage', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByFailureMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failureMessage', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByFeeKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeKobo', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByFeeKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeKobo', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByGoalClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalClientId', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByGoalClientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalClientId', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByIdempotencyKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByIdempotencyKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByLastAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAt', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByLastAttemptAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAt', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByMaskedAccount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maskedAccount', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByMaskedAccountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maskedAccount', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByNarration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narration', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByNarrationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narration', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByNextAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextAttemptAt', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByNextAttemptAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextAttemptAt', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByQueuedWhileOffline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queuedWhileOffline', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByQueuedWhileOfflineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queuedWhileOffline', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByServerRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRef', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByServerRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRef', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension OutboxItemEntityQueryWhereDistinct on QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> {
  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByAmountKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountKobo');
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attempts');
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByBiometricSignature({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'biometricSignature', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByCounterpartyBank({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'counterpartyBank', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByCounterpartyName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'counterpartyName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByFailureCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'failureCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByFailureMessage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'failureMessage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByFeeKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'feeKobo');
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByGoalClientId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalClientId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByIdempotencyKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idempotencyKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByLastAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAttemptAt');
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByMaskedAccount({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maskedAccount', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByNarration({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'narration', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByNextAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextAttemptAt');
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByPayloadJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payloadJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByQueuedWhileOffline() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'queuedWhileOffline');
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByServerRef({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverRef', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxItemEntity, QDistinct> distinctByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension OutboxItemEntityQueryProperty on QueryBuilder<OutboxItemEntity, OutboxItemEntity, QQueryProperty> {
  QueryBuilder<OutboxItemEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OutboxItemEntity, int, QQueryOperations> amountKoboProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountKobo');
    });
  }

  QueryBuilder<OutboxItemEntity, int, QQueryOperations> attemptsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attempts');
    });
  }

  QueryBuilder<OutboxItemEntity, String?, QQueryOperations> biometricSignatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'biometricSignature');
    });
  }

  QueryBuilder<OutboxItemEntity, DateTime?, QQueryOperations> completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<OutboxItemEntity, String?, QQueryOperations> counterpartyBankProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'counterpartyBank');
    });
  }

  QueryBuilder<OutboxItemEntity, String?, QQueryOperations> counterpartyNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'counterpartyName');
    });
  }

  QueryBuilder<OutboxItemEntity, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<OutboxItemEntity, String?, QQueryOperations> failureCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'failureCode');
    });
  }

  QueryBuilder<OutboxItemEntity, String?, QQueryOperations> failureMessageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'failureMessage');
    });
  }

  QueryBuilder<OutboxItemEntity, int, QQueryOperations> feeKoboProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'feeKobo');
    });
  }

  QueryBuilder<OutboxItemEntity, String?, QQueryOperations> goalClientIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalClientId');
    });
  }

  QueryBuilder<OutboxItemEntity, String, QQueryOperations> idempotencyKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idempotencyKey');
    });
  }

  QueryBuilder<OutboxItemEntity, DateTime?, QQueryOperations> lastAttemptAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAttemptAt');
    });
  }

  QueryBuilder<OutboxItemEntity, String?, QQueryOperations> maskedAccountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maskedAccount');
    });
  }

  QueryBuilder<OutboxItemEntity, String?, QQueryOperations> narrationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'narration');
    });
  }

  QueryBuilder<OutboxItemEntity, DateTime?, QQueryOperations> nextAttemptAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextAttemptAt');
    });
  }

  QueryBuilder<OutboxItemEntity, String, QQueryOperations> payloadJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payloadJson');
    });
  }

  QueryBuilder<OutboxItemEntity, bool, QQueryOperations> queuedWhileOfflineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'queuedWhileOffline');
    });
  }

  QueryBuilder<OutboxItemEntity, String?, QQueryOperations> serverRefProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverRef');
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<OutboxItemEntity, OutboxType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
