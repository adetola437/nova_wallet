// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_snapshot_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWalletSnapshotEntityCollection on Isar {
  IsarCollection<WalletSnapshotEntity> get walletSnapshotEntitys => this.collection();
}

const WalletSnapshotEntitySchema = CollectionSchema(
  name: r'WalletSnapshotEntity',
  id: 8244460399759598635,
  properties: {
    r'lastSyncedAt': PropertySchema(id: 0, name: r'lastSyncedAt', type: IsarType.dateTime),
    r'ledgerBalanceKobo': PropertySchema(id: 1, name: r'ledgerBalanceKobo', type: IsarType.long),
  },

  estimateSize: _walletSnapshotEntityEstimateSize,
  serialize: _walletSnapshotEntitySerialize,
  deserialize: _walletSnapshotEntityDeserialize,
  deserializeProp: _walletSnapshotEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _walletSnapshotEntityGetId,
  getLinks: _walletSnapshotEntityGetLinks,
  attach: _walletSnapshotEntityAttach,
  version: '3.3.2',
);

int _walletSnapshotEntityEstimateSize(WalletSnapshotEntity object, List<int> offsets, Map<Type, List<int>> allOffsets) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _walletSnapshotEntitySerialize(
  WalletSnapshotEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.lastSyncedAt);
  writer.writeLong(offsets[1], object.ledgerBalanceKobo);
}

WalletSnapshotEntity _walletSnapshotEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WalletSnapshotEntity();
  object.id = id;
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[0]);
  object.ledgerBalanceKobo = reader.readLong(offsets[1]);
  return object;
}

P _walletSnapshotEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _walletSnapshotEntityGetId(WalletSnapshotEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _walletSnapshotEntityGetLinks(WalletSnapshotEntity object) {
  return [];
}

void _walletSnapshotEntityAttach(IsarCollection<dynamic> col, Id id, WalletSnapshotEntity object) {
  object.id = id;
}

extension WalletSnapshotEntityQueryWhereSort on QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QWhere> {
  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WalletSnapshotEntityQueryWhere on QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QWhereClause> {
  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: include));
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: include));
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterWhereClause> idBetween(
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
}

extension WalletSnapshotEntityQueryFilter
    on QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QFilterCondition> {
  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'id', value: value));
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterFilterCondition> lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'lastSyncedAt'));
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterFilterCondition> lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'lastSyncedAt'));
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterFilterCondition> lastSyncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'lastSyncedAt', value: value));
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterFilterCondition> lastSyncedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'lastSyncedAt', value: value),
      );
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterFilterCondition> lastSyncedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'lastSyncedAt', value: value),
      );
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterFilterCondition> lastSyncedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastSyncedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterFilterCondition> ledgerBalanceKoboEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'ledgerBalanceKobo', value: value));
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterFilterCondition> ledgerBalanceKoboGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'ledgerBalanceKobo', value: value),
      );
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterFilterCondition> ledgerBalanceKoboLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'ledgerBalanceKobo', value: value),
      );
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterFilterCondition> ledgerBalanceKoboBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ledgerBalanceKobo',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension WalletSnapshotEntityQueryObject
    on QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QFilterCondition> {}

extension WalletSnapshotEntityQueryLinks
    on QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QFilterCondition> {}

extension WalletSnapshotEntityQuerySortBy on QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QSortBy> {
  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterSortBy> sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterSortBy> sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterSortBy> sortByLedgerBalanceKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ledgerBalanceKobo', Sort.asc);
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterSortBy> sortByLedgerBalanceKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ledgerBalanceKobo', Sort.desc);
    });
  }
}

extension WalletSnapshotEntityQuerySortThenBy on QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QSortThenBy> {
  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterSortBy> thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterSortBy> thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterSortBy> thenByLedgerBalanceKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ledgerBalanceKobo', Sort.asc);
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QAfterSortBy> thenByLedgerBalanceKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ledgerBalanceKobo', Sort.desc);
    });
  }
}

extension WalletSnapshotEntityQueryWhereDistinct
    on QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QDistinct> {
  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QDistinct> distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QDistinct> distinctByLedgerBalanceKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ledgerBalanceKobo');
    });
  }
}

extension WalletSnapshotEntityQueryProperty
    on QueryBuilder<WalletSnapshotEntity, WalletSnapshotEntity, QQueryProperty> {
  QueryBuilder<WalletSnapshotEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WalletSnapshotEntity, DateTime?, QQueryOperations> lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<WalletSnapshotEntity, int, QQueryOperations> ledgerBalanceKoboProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ledgerBalanceKobo');
    });
  }
}
