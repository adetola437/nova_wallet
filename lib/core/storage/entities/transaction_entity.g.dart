// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTransactionEntityCollection on Isar {
  IsarCollection<TransactionEntity> get transactionEntitys => this.collection();
}

const TransactionEntitySchema = CollectionSchema(
  name: r'TransactionEntity',
  id: 7517214299117749517,
  properties: {
    r'amountKobo': PropertySchema(id: 0, name: r'amountKobo', type: IsarType.long),
    r'createdAt': PropertySchema(id: 1, name: r'createdAt', type: IsarType.dateTime),
    r'direction': PropertySchema(
      id: 2,
      name: r'direction',
      type: IsarType.string,
      enumMap: _TransactionEntitydirectionEnumValueMap,
    ),
    r'feeKobo': PropertySchema(id: 3, name: r'feeKobo', type: IsarType.long),
    r'goalClientId': PropertySchema(id: 4, name: r'goalClientId', type: IsarType.string),
    r'idempotencyKey': PropertySchema(id: 5, name: r'idempotencyKey', type: IsarType.string),
    r'kind': PropertySchema(id: 6, name: r'kind', type: IsarType.string, enumMap: _TransactionEntitykindEnumValueMap),
    r'narration': PropertySchema(id: 7, name: r'narration', type: IsarType.string),
    r'serverRef': PropertySchema(id: 8, name: r'serverRef', type: IsarType.string),
    r'subtitle': PropertySchema(id: 9, name: r'subtitle', type: IsarType.string),
    r'title': PropertySchema(id: 10, name: r'title', type: IsarType.string),
  },

  estimateSize: _transactionEntityEstimateSize,
  serialize: _transactionEntitySerialize,
  deserialize: _transactionEntityDeserialize,
  deserializeProp: _transactionEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'serverRef': IndexSchema(
      id: 940670041969791498,
      name: r'serverRef',
      unique: true,
      replace: true,
      properties: [IndexPropertySchema(name: r'serverRef', type: IndexType.hash, caseSensitive: true)],
    ),
    r'goalClientId': IndexSchema(
      id: -2575398997715841279,
      name: r'goalClientId',
      unique: false,
      replace: false,
      properties: [IndexPropertySchema(name: r'goalClientId', type: IndexType.hash, caseSensitive: true)],
    ),
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [IndexPropertySchema(name: r'createdAt', type: IndexType.value, caseSensitive: false)],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _transactionEntityGetId,
  getLinks: _transactionEntityGetLinks,
  attach: _transactionEntityAttach,
  version: '3.3.2',
);

int _transactionEntityEstimateSize(TransactionEntity object, List<int> offsets, Map<Type, List<int>> allOffsets) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.direction.name.length * 3;
  {
    final value = object.goalClientId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.idempotencyKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.kind.name.length * 3;
  {
    final value = object.narration;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.serverRef.length * 3;
  {
    final value = object.subtitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _transactionEntitySerialize(
  TransactionEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amountKobo);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.direction.name);
  writer.writeLong(offsets[3], object.feeKobo);
  writer.writeString(offsets[4], object.goalClientId);
  writer.writeString(offsets[5], object.idempotencyKey);
  writer.writeString(offsets[6], object.kind.name);
  writer.writeString(offsets[7], object.narration);
  writer.writeString(offsets[8], object.serverRef);
  writer.writeString(offsets[9], object.subtitle);
  writer.writeString(offsets[10], object.title);
}

TransactionEntity _transactionEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TransactionEntity();
  object.amountKobo = reader.readLong(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.direction =
      _TransactionEntitydirectionValueEnumMap[reader.readStringOrNull(offsets[2])] ?? ActivityDirection.debit;
  object.feeKobo = reader.readLong(offsets[3]);
  object.goalClientId = reader.readStringOrNull(offsets[4]);
  object.id = id;
  object.idempotencyKey = reader.readStringOrNull(offsets[5]);
  object.kind = _TransactionEntitykindValueEnumMap[reader.readStringOrNull(offsets[6])] ?? ActivityKind.transfer;
  object.narration = reader.readStringOrNull(offsets[7]);
  object.serverRef = reader.readString(offsets[8]);
  object.subtitle = reader.readStringOrNull(offsets[9]);
  object.title = reader.readString(offsets[10]);
  return object;
}

P _transactionEntityDeserializeProp<P>(IsarReader reader, int propertyId, int offset, Map<Type, List<int>> allOffsets) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (_TransactionEntitydirectionValueEnumMap[reader.readStringOrNull(offset)] ?? ActivityDirection.debit) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (_TransactionEntitykindValueEnumMap[reader.readStringOrNull(offset)] ?? ActivityKind.transfer) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TransactionEntitydirectionEnumValueMap = {r'debit': r'debit', r'credit': r'credit'};
const _TransactionEntitydirectionValueEnumMap = {
  r'debit': ActivityDirection.debit,
  r'credit': ActivityDirection.credit,
};
const _TransactionEntitykindEnumValueMap = {
  r'transfer': r'transfer',
  r'contribution': r'contribution',
  r'credit': r'credit',
  r'goalCreated': r'goalCreated',
  r'goalWithdrawal': r'goalWithdrawal',
};
const _TransactionEntitykindValueEnumMap = {
  r'transfer': ActivityKind.transfer,
  r'contribution': ActivityKind.contribution,
  r'credit': ActivityKind.credit,
  r'goalCreated': ActivityKind.goalCreated,
  r'goalWithdrawal': ActivityKind.goalWithdrawal,
};

Id _transactionEntityGetId(TransactionEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _transactionEntityGetLinks(TransactionEntity object) {
  return [];
}

void _transactionEntityAttach(IsarCollection<dynamic> col, Id id, TransactionEntity object) {
  object.id = id;
}

extension TransactionEntityByIndex on IsarCollection<TransactionEntity> {
  Future<TransactionEntity?> getByServerRef(String serverRef) {
    return getByIndex(r'serverRef', [serverRef]);
  }

  TransactionEntity? getByServerRefSync(String serverRef) {
    return getByIndexSync(r'serverRef', [serverRef]);
  }

  Future<bool> deleteByServerRef(String serverRef) {
    return deleteByIndex(r'serverRef', [serverRef]);
  }

  bool deleteByServerRefSync(String serverRef) {
    return deleteByIndexSync(r'serverRef', [serverRef]);
  }

  Future<List<TransactionEntity?>> getAllByServerRef(List<String> serverRefValues) {
    final values = serverRefValues.map((e) => [e]).toList();
    return getAllByIndex(r'serverRef', values);
  }

  List<TransactionEntity?> getAllByServerRefSync(List<String> serverRefValues) {
    final values = serverRefValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'serverRef', values);
  }

  Future<int> deleteAllByServerRef(List<String> serverRefValues) {
    final values = serverRefValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'serverRef', values);
  }

  int deleteAllByServerRefSync(List<String> serverRefValues) {
    final values = serverRefValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'serverRef', values);
  }

  Future<Id> putByServerRef(TransactionEntity object) {
    return putByIndex(r'serverRef', object);
  }

  Id putByServerRefSync(TransactionEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'serverRef', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByServerRef(List<TransactionEntity> objects) {
    return putAllByIndex(r'serverRef', objects);
  }

  List<Id> putAllByServerRefSync(List<TransactionEntity> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'serverRef', objects, saveLinks: saveLinks);
  }
}

extension TransactionEntityQueryWhereSort on QueryBuilder<TransactionEntity, TransactionEntity, QWhere> {
  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IndexWhereClause.any(indexName: r'createdAt'));
    });
  }
}

extension TransactionEntityQueryWhere on QueryBuilder<TransactionEntity, TransactionEntity, QWhereClause> {
  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: include));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: include));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause> serverRefEqualTo(String serverRef) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(indexName: r'serverRef', value: [serverRef]));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause> serverRefNotEqualTo(String serverRef) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(indexName: r'serverRef', lower: [], upper: [serverRef], includeUpper: false),
            )
            .addWhereClause(
              IndexWhereClause.between(indexName: r'serverRef', lower: [serverRef], includeLower: false, upper: []),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(indexName: r'serverRef', lower: [serverRef], includeLower: false, upper: []),
            )
            .addWhereClause(
              IndexWhereClause.between(indexName: r'serverRef', lower: [], upper: [serverRef], includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause> goalClientIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(indexName: r'goalClientId', value: [null]));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause> goalClientIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(indexName: r'goalClientId', lower: [null], includeLower: false, upper: []),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause> goalClientIdEqualTo(String? goalClientId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(indexName: r'goalClientId', value: [goalClientId]));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause> goalClientIdNotEqualTo(String? goalClientId) {
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause> createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(indexName: r'createdAt', value: [createdAt]));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause> createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(indexName: r'createdAt', lower: [], upper: [createdAt], includeUpper: false),
            )
            .addWhereClause(
              IndexWhereClause.between(indexName: r'createdAt', lower: [createdAt], includeLower: false, upper: []),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(indexName: r'createdAt', lower: [createdAt], includeLower: false, upper: []),
            )
            .addWhereClause(
              IndexWhereClause.between(indexName: r'createdAt', lower: [], upper: [createdAt], includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause> createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(indexName: r'createdAt', lower: [createdAt], includeLower: include, upper: []),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause> createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(indexName: r'createdAt', lower: [], upper: [createdAt], includeUpper: include),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause> createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [lowerCreatedAt],
          includeLower: includeLower,
          upper: [upperCreatedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TransactionEntityQueryFilter on QueryBuilder<TransactionEntity, TransactionEntity, QFilterCondition> {
  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> amountKoboEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'amountKobo', value: value));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> amountKoboGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'amountKobo', value: value),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> amountKoboLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'amountKobo', value: value),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> amountKoboBetween(
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'createdAt', value: value));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'createdAt', value: value));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> directionEqualTo(
    ActivityDirection value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'direction', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> directionGreaterThan(
    ActivityDirection value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'direction',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> directionLessThan(
    ActivityDirection value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'direction', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> directionBetween(
    ActivityDirection lower,
    ActivityDirection upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'direction',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> directionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'direction', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> directionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'direction', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> directionContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'direction', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> directionMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'direction', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> directionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'direction', value: ''));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> directionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'direction', value: ''));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> feeKoboEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'feeKobo', value: value));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> feeKoboGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'feeKobo', value: value),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> feeKoboLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'feeKobo', value: value));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> feeKoboBetween(
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> goalClientIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'goalClientId'));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> goalClientIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'goalClientId'));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> goalClientIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'goalClientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> goalClientIdGreaterThan(
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> goalClientIdLessThan(
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> goalClientIdBetween(
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> goalClientIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'goalClientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> goalClientIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'goalClientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> goalClientIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'goalClientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> goalClientIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'goalClientId', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> goalClientIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'goalClientId', value: ''));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> goalClientIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'goalClientId', value: ''));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'id', value: value));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> idempotencyKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'idempotencyKey'));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> idempotencyKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'idempotencyKey'));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> idempotencyKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'idempotencyKey', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> idempotencyKeyGreaterThan(
    String? value, {
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> idempotencyKeyLessThan(
    String? value, {
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> idempotencyKeyBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> idempotencyKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'idempotencyKey', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> idempotencyKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'idempotencyKey', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> idempotencyKeyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'idempotencyKey', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> idempotencyKeyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'idempotencyKey', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> idempotencyKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'idempotencyKey', value: ''));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> idempotencyKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'idempotencyKey', value: ''));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> kindEqualTo(
    ActivityKind value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'kind', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> kindGreaterThan(
    ActivityKind value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'kind', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> kindLessThan(
    ActivityKind value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'kind', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> kindBetween(
    ActivityKind lower,
    ActivityKind upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'kind',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> kindStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'kind', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> kindEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'kind', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> kindContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'kind', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> kindMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'kind', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> kindIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'kind', value: ''));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> kindIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'kind', value: ''));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> narrationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'narration'));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> narrationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'narration'));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> narrationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'narration', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> narrationGreaterThan(
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> narrationLessThan(
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> narrationBetween(
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> narrationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'narration', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> narrationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'narration', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> narrationContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'narration', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> narrationMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'narration', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> narrationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'narration', value: ''));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> narrationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'narration', value: ''));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> serverRefEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'serverRef', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> serverRefGreaterThan(
    String value, {
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> serverRefLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'serverRef', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> serverRefBetween(
    String lower,
    String upper, {
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> serverRefStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'serverRef', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> serverRefEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'serverRef', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> serverRefContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'serverRef', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> serverRefMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'serverRef', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> serverRefIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'serverRef', value: ''));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> serverRefIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'serverRef', value: ''));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> subtitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'subtitle'));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> subtitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'subtitle'));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> subtitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'subtitle', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> subtitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'subtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> subtitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'subtitle', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> subtitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'subtitle',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> subtitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'subtitle', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> subtitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'subtitle', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> subtitleContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'subtitle', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> subtitleMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'subtitle', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> subtitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'subtitle', value: ''));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> subtitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'subtitle', value: ''));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'title', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'title', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'title', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'title', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> titleContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'title', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> titleMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'title', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'title', value: ''));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'title', value: ''));
    });
  }
}

extension TransactionEntityQueryObject on QueryBuilder<TransactionEntity, TransactionEntity, QFilterCondition> {}

extension TransactionEntityQueryLinks on QueryBuilder<TransactionEntity, TransactionEntity, QFilterCondition> {}

extension TransactionEntityQuerySortBy on QueryBuilder<TransactionEntity, TransactionEntity, QSortBy> {
  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByAmountKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountKobo', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByAmountKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountKobo', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByDirection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'direction', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByDirectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'direction', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByFeeKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeKobo', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByFeeKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeKobo', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByGoalClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalClientId', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByGoalClientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalClientId', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByIdempotencyKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByIdempotencyKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByNarration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narration', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByNarrationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narration', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByServerRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRef', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByServerRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRef', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortBySubtitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortBySubtitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension TransactionEntityQuerySortThenBy on QueryBuilder<TransactionEntity, TransactionEntity, QSortThenBy> {
  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByAmountKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountKobo', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByAmountKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountKobo', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByDirection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'direction', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByDirectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'direction', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByFeeKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeKobo', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByFeeKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeKobo', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByGoalClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalClientId', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByGoalClientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalClientId', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByIdempotencyKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByIdempotencyKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByNarration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narration', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByNarrationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narration', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByServerRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRef', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByServerRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRef', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenBySubtitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenBySubtitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension TransactionEntityQueryWhereDistinct on QueryBuilder<TransactionEntity, TransactionEntity, QDistinct> {
  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct> distinctByAmountKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountKobo');
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct> distinctByDirection({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'direction', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct> distinctByFeeKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'feeKobo');
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct> distinctByGoalClientId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalClientId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct> distinctByIdempotencyKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idempotencyKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct> distinctByKind({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kind', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct> distinctByNarration({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'narration', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct> distinctByServerRef({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverRef', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct> distinctBySubtitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subtitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct> distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension TransactionEntityQueryProperty on QueryBuilder<TransactionEntity, TransactionEntity, QQueryProperty> {
  QueryBuilder<TransactionEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TransactionEntity, int, QQueryOperations> amountKoboProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountKobo');
    });
  }

  QueryBuilder<TransactionEntity, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<TransactionEntity, ActivityDirection, QQueryOperations> directionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'direction');
    });
  }

  QueryBuilder<TransactionEntity, int, QQueryOperations> feeKoboProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'feeKobo');
    });
  }

  QueryBuilder<TransactionEntity, String?, QQueryOperations> goalClientIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalClientId');
    });
  }

  QueryBuilder<TransactionEntity, String?, QQueryOperations> idempotencyKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idempotencyKey');
    });
  }

  QueryBuilder<TransactionEntity, ActivityKind, QQueryOperations> kindProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kind');
    });
  }

  QueryBuilder<TransactionEntity, String?, QQueryOperations> narrationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'narration');
    });
  }

  QueryBuilder<TransactionEntity, String, QQueryOperations> serverRefProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverRef');
    });
  }

  QueryBuilder<TransactionEntity, String?, QQueryOperations> subtitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subtitle');
    });
  }

  QueryBuilder<TransactionEntity, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
