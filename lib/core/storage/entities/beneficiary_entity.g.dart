// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beneficiary_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBeneficiaryEntityCollection on Isar {
  IsarCollection<BeneficiaryEntity> get beneficiaryEntitys => this.collection();
}

const BeneficiaryEntitySchema = CollectionSchema(
  name: r'BeneficiaryEntity',
  id: -2462843371626855281,
  properties: {
    r'accountNumber': PropertySchema(id: 0, name: r'accountNumber', type: IsarType.string),
    r'bankCode': PropertySchema(id: 1, name: r'bankCode', type: IsarType.string),
    r'bankName': PropertySchema(id: 2, name: r'bankName', type: IsarType.string),
    r'lastUsedAt': PropertySchema(id: 3, name: r'lastUsedAt', type: IsarType.dateTime),
    r'verifiedAt': PropertySchema(id: 4, name: r'verifiedAt', type: IsarType.dateTime),
    r'verifiedName': PropertySchema(id: 5, name: r'verifiedName', type: IsarType.string),
  },

  estimateSize: _beneficiaryEntityEstimateSize,
  serialize: _beneficiaryEntitySerialize,
  deserialize: _beneficiaryEntityDeserialize,
  deserializeProp: _beneficiaryEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'accountNumber_bankCode': IndexSchema(
      id: -4088450281068600710,
      name: r'accountNumber_bankCode',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(name: r'accountNumber', type: IndexType.hash, caseSensitive: true),
        IndexPropertySchema(name: r'bankCode', type: IndexType.hash, caseSensitive: true),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _beneficiaryEntityGetId,
  getLinks: _beneficiaryEntityGetLinks,
  attach: _beneficiaryEntityAttach,
  version: '3.3.2',
);

int _beneficiaryEntityEstimateSize(BeneficiaryEntity object, List<int> offsets, Map<Type, List<int>> allOffsets) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountNumber.length * 3;
  bytesCount += 3 + object.bankCode.length * 3;
  bytesCount += 3 + object.bankName.length * 3;
  bytesCount += 3 + object.verifiedName.length * 3;
  return bytesCount;
}

void _beneficiaryEntitySerialize(
  BeneficiaryEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountNumber);
  writer.writeString(offsets[1], object.bankCode);
  writer.writeString(offsets[2], object.bankName);
  writer.writeDateTime(offsets[3], object.lastUsedAt);
  writer.writeDateTime(offsets[4], object.verifiedAt);
  writer.writeString(offsets[5], object.verifiedName);
}

BeneficiaryEntity _beneficiaryEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BeneficiaryEntity();
  object.accountNumber = reader.readString(offsets[0]);
  object.bankCode = reader.readString(offsets[1]);
  object.bankName = reader.readString(offsets[2]);
  object.id = id;
  object.lastUsedAt = reader.readDateTimeOrNull(offsets[3]);
  object.verifiedAt = reader.readDateTime(offsets[4]);
  object.verifiedName = reader.readString(offsets[5]);
  return object;
}

P _beneficiaryEntityDeserializeProp<P>(IsarReader reader, int propertyId, int offset, Map<Type, List<int>> allOffsets) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _beneficiaryEntityGetId(BeneficiaryEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _beneficiaryEntityGetLinks(BeneficiaryEntity object) {
  return [];
}

void _beneficiaryEntityAttach(IsarCollection<dynamic> col, Id id, BeneficiaryEntity object) {
  object.id = id;
}

extension BeneficiaryEntityByIndex on IsarCollection<BeneficiaryEntity> {
  Future<BeneficiaryEntity?> getByAccountNumberBankCode(String accountNumber, String bankCode) {
    return getByIndex(r'accountNumber_bankCode', [accountNumber, bankCode]);
  }

  BeneficiaryEntity? getByAccountNumberBankCodeSync(String accountNumber, String bankCode) {
    return getByIndexSync(r'accountNumber_bankCode', [accountNumber, bankCode]);
  }

  Future<bool> deleteByAccountNumberBankCode(String accountNumber, String bankCode) {
    return deleteByIndex(r'accountNumber_bankCode', [accountNumber, bankCode]);
  }

  bool deleteByAccountNumberBankCodeSync(String accountNumber, String bankCode) {
    return deleteByIndexSync(r'accountNumber_bankCode', [accountNumber, bankCode]);
  }

  Future<List<BeneficiaryEntity?>> getAllByAccountNumberBankCode(
    List<String> accountNumberValues,
    List<String> bankCodeValues,
  ) {
    final len = accountNumberValues.length;
    assert(bankCodeValues.length == len, 'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([accountNumberValues[i], bankCodeValues[i]]);
    }

    return getAllByIndex(r'accountNumber_bankCode', values);
  }

  List<BeneficiaryEntity?> getAllByAccountNumberBankCodeSync(
    List<String> accountNumberValues,
    List<String> bankCodeValues,
  ) {
    final len = accountNumberValues.length;
    assert(bankCodeValues.length == len, 'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([accountNumberValues[i], bankCodeValues[i]]);
    }

    return getAllByIndexSync(r'accountNumber_bankCode', values);
  }

  Future<int> deleteAllByAccountNumberBankCode(List<String> accountNumberValues, List<String> bankCodeValues) {
    final len = accountNumberValues.length;
    assert(bankCodeValues.length == len, 'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([accountNumberValues[i], bankCodeValues[i]]);
    }

    return deleteAllByIndex(r'accountNumber_bankCode', values);
  }

  int deleteAllByAccountNumberBankCodeSync(List<String> accountNumberValues, List<String> bankCodeValues) {
    final len = accountNumberValues.length;
    assert(bankCodeValues.length == len, 'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([accountNumberValues[i], bankCodeValues[i]]);
    }

    return deleteAllByIndexSync(r'accountNumber_bankCode', values);
  }

  Future<Id> putByAccountNumberBankCode(BeneficiaryEntity object) {
    return putByIndex(r'accountNumber_bankCode', object);
  }

  Id putByAccountNumberBankCodeSync(BeneficiaryEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'accountNumber_bankCode', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAccountNumberBankCode(List<BeneficiaryEntity> objects) {
    return putAllByIndex(r'accountNumber_bankCode', objects);
  }

  List<Id> putAllByAccountNumberBankCodeSync(List<BeneficiaryEntity> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'accountNumber_bankCode', objects, saveLinks: saveLinks);
  }
}

extension BeneficiaryEntityQueryWhereSort on QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QWhere> {
  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BeneficiaryEntityQueryWhere on QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QWhereClause> {
  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: include));
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: include));
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterWhereClause> accountNumberEqualToAnyBankCode(
    String accountNumber,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'accountNumber_bankCode', value: [accountNumber]),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterWhereClause> accountNumberNotEqualToAnyBankCode(
    String accountNumber,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountNumber_bankCode',
                lower: [],
                upper: [accountNumber],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountNumber_bankCode',
                lower: [accountNumber],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountNumber_bankCode',
                lower: [accountNumber],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountNumber_bankCode',
                lower: [],
                upper: [accountNumber],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterWhereClause> accountNumberBankCodeEqualTo(
    String accountNumber,
    String bankCode,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'accountNumber_bankCode', value: [accountNumber, bankCode]),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterWhereClause> accountNumberEqualToBankCodeNotEqualTo(
    String accountNumber,
    String bankCode,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountNumber_bankCode',
                lower: [accountNumber],
                upper: [accountNumber, bankCode],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountNumber_bankCode',
                lower: [accountNumber, bankCode],
                includeLower: false,
                upper: [accountNumber],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountNumber_bankCode',
                lower: [accountNumber, bankCode],
                includeLower: false,
                upper: [accountNumber],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountNumber_bankCode',
                lower: [accountNumber],
                upper: [accountNumber, bankCode],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension BeneficiaryEntityQueryFilter on QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QFilterCondition> {
  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> accountNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountNumber', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> accountNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accountNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> accountNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accountNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> accountNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accountNumber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> accountNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'accountNumber', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> accountNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'accountNumber', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> accountNumberContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'accountNumber', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> accountNumberMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'accountNumber', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> accountNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'accountNumber', value: ''));
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> accountNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'accountNumber', value: ''));
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bankCode', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bankCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'bankCode', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bankCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'bankCode', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'bankCode', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankCodeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'bankCode', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankCodeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'bankCode', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'bankCode', value: ''));
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'bankCode', value: ''));
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bankName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bankName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'bankName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bankName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'bankName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'bankName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'bankName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'bankName', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'bankName', value: ''));
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> bankNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'bankName', value: ''));
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'id', value: value));
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> lastUsedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'lastUsedAt'));
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> lastUsedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'lastUsedAt'));
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> lastUsedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'lastUsedAt', value: value));
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> lastUsedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'lastUsedAt', value: value),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> lastUsedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'lastUsedAt', value: value),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> lastUsedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastUsedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> verifiedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'verifiedAt', value: value));
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> verifiedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'verifiedAt', value: value),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> verifiedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'verifiedAt', value: value),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> verifiedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'verifiedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> verifiedNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'verifiedName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> verifiedNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'verifiedName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> verifiedNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'verifiedName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> verifiedNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'verifiedName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> verifiedNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'verifiedName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> verifiedNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'verifiedName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> verifiedNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'verifiedName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> verifiedNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'verifiedName', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> verifiedNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'verifiedName', value: ''));
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterFilterCondition> verifiedNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'verifiedName', value: ''));
    });
  }
}

extension BeneficiaryEntityQueryObject on QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QFilterCondition> {}

extension BeneficiaryEntityQueryLinks on QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QFilterCondition> {}

extension BeneficiaryEntityQuerySortBy on QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QSortBy> {
  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> sortByAccountNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.asc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> sortByAccountNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.desc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> sortByBankCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankCode', Sort.asc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> sortByBankCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankCode', Sort.desc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> sortByBankName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankName', Sort.asc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> sortByBankNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankName', Sort.desc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> sortByLastUsedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsedAt', Sort.asc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> sortByLastUsedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsedAt', Sort.desc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> sortByVerifiedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verifiedAt', Sort.asc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> sortByVerifiedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verifiedAt', Sort.desc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> sortByVerifiedName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verifiedName', Sort.asc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> sortByVerifiedNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verifiedName', Sort.desc);
    });
  }
}

extension BeneficiaryEntityQuerySortThenBy on QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QSortThenBy> {
  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> thenByAccountNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.asc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> thenByAccountNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.desc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> thenByBankCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankCode', Sort.asc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> thenByBankCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankCode', Sort.desc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> thenByBankName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankName', Sort.asc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> thenByBankNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankName', Sort.desc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> thenByLastUsedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsedAt', Sort.asc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> thenByLastUsedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsedAt', Sort.desc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> thenByVerifiedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verifiedAt', Sort.asc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> thenByVerifiedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verifiedAt', Sort.desc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> thenByVerifiedName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verifiedName', Sort.asc);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QAfterSortBy> thenByVerifiedNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verifiedName', Sort.desc);
    });
  }
}

extension BeneficiaryEntityQueryWhereDistinct on QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QDistinct> {
  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QDistinct> distinctByAccountNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QDistinct> distinctByBankCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bankCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QDistinct> distinctByBankName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bankName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QDistinct> distinctByLastUsedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUsedAt');
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QDistinct> distinctByVerifiedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verifiedAt');
    });
  }

  QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QDistinct> distinctByVerifiedName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verifiedName', caseSensitive: caseSensitive);
    });
  }
}

extension BeneficiaryEntityQueryProperty on QueryBuilder<BeneficiaryEntity, BeneficiaryEntity, QQueryProperty> {
  QueryBuilder<BeneficiaryEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BeneficiaryEntity, String, QQueryOperations> accountNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountNumber');
    });
  }

  QueryBuilder<BeneficiaryEntity, String, QQueryOperations> bankCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bankCode');
    });
  }

  QueryBuilder<BeneficiaryEntity, String, QQueryOperations> bankNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bankName');
    });
  }

  QueryBuilder<BeneficiaryEntity, DateTime?, QQueryOperations> lastUsedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUsedAt');
    });
  }

  QueryBuilder<BeneficiaryEntity, DateTime, QQueryOperations> verifiedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verifiedAt');
    });
  }

  QueryBuilder<BeneficiaryEntity, String, QQueryOperations> verifiedNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verifiedName');
    });
  }
}
