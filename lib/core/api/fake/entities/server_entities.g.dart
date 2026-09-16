// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_entities.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetServerAccountCollection on Isar {
  IsarCollection<ServerAccount> get serverAccounts => this.collection();
}

const ServerAccountSchema = CollectionSchema(
  name: r'ServerAccount',
  id: 7901806653659601286,
  properties: {
    r'accountNumber': PropertySchema(id: 0, name: r'accountNumber', type: IsarType.string),
    r'balanceKobo': PropertySchema(id: 1, name: r'balanceKobo', type: IsarType.long),
    r'bvnVerified': PropertySchema(id: 2, name: r'bvnVerified', type: IsarType.bool),
    r'email': PropertySchema(id: 3, name: r'email', type: IsarType.string),
    r'fullName': PropertySchema(id: 4, name: r'fullName', type: IsarType.string),
    r'passwordHash': PropertySchema(id: 5, name: r'passwordHash', type: IsarType.string),
    r'passwordSalt': PropertySchema(id: 6, name: r'passwordSalt', type: IsarType.string),
    r'phone': PropertySchema(id: 7, name: r'phone', type: IsarType.string),
    r'pinHash': PropertySchema(id: 8, name: r'pinHash', type: IsarType.string),
    r'pinSalt': PropertySchema(id: 9, name: r'pinSalt', type: IsarType.string),
    r'tier': PropertySchema(id: 10, name: r'tier', type: IsarType.long),
  },

  estimateSize: _serverAccountEstimateSize,
  serialize: _serverAccountSerialize,
  deserialize: _serverAccountDeserialize,
  deserializeProp: _serverAccountDeserializeProp,
  idName: r'id',
  indexes: {
    r'phone': IndexSchema(
      id: -6308098324157559207,
      name: r'phone',
      unique: true,
      replace: false,
      properties: [IndexPropertySchema(name: r'phone', type: IndexType.hash, caseSensitive: true)],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _serverAccountGetId,
  getLinks: _serverAccountGetLinks,
  attach: _serverAccountAttach,
  version: '3.3.2',
);

int _serverAccountEstimateSize(ServerAccount object, List<int> offsets, Map<Type, List<int>> allOffsets) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountNumber.length * 3;
  bytesCount += 3 + object.email.length * 3;
  bytesCount += 3 + object.fullName.length * 3;
  bytesCount += 3 + object.passwordHash.length * 3;
  bytesCount += 3 + object.passwordSalt.length * 3;
  bytesCount += 3 + object.phone.length * 3;
  {
    final value = object.pinHash;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pinSalt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _serverAccountSerialize(
  ServerAccount object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountNumber);
  writer.writeLong(offsets[1], object.balanceKobo);
  writer.writeBool(offsets[2], object.bvnVerified);
  writer.writeString(offsets[3], object.email);
  writer.writeString(offsets[4], object.fullName);
  writer.writeString(offsets[5], object.passwordHash);
  writer.writeString(offsets[6], object.passwordSalt);
  writer.writeString(offsets[7], object.phone);
  writer.writeString(offsets[8], object.pinHash);
  writer.writeString(offsets[9], object.pinSalt);
  writer.writeLong(offsets[10], object.tier);
}

ServerAccount _serverAccountDeserialize(Id id, IsarReader reader, List<int> offsets, Map<Type, List<int>> allOffsets) {
  final object = ServerAccount();
  object.accountNumber = reader.readString(offsets[0]);
  object.balanceKobo = reader.readLong(offsets[1]);
  object.bvnVerified = reader.readBool(offsets[2]);
  object.email = reader.readString(offsets[3]);
  object.fullName = reader.readString(offsets[4]);
  object.id = id;
  object.passwordHash = reader.readString(offsets[5]);
  object.passwordSalt = reader.readString(offsets[6]);
  object.phone = reader.readString(offsets[7]);
  object.pinHash = reader.readStringOrNull(offsets[8]);
  object.pinSalt = reader.readStringOrNull(offsets[9]);
  object.tier = reader.readLong(offsets[10]);
  return object;
}

P _serverAccountDeserializeProp<P>(IsarReader reader, int propertyId, int offset, Map<Type, List<int>> allOffsets) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _serverAccountGetId(ServerAccount object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _serverAccountGetLinks(ServerAccount object) {
  return [];
}

void _serverAccountAttach(IsarCollection<dynamic> col, Id id, ServerAccount object) {
  object.id = id;
}

extension ServerAccountByIndex on IsarCollection<ServerAccount> {
  Future<ServerAccount?> getByPhone(String phone) {
    return getByIndex(r'phone', [phone]);
  }

  ServerAccount? getByPhoneSync(String phone) {
    return getByIndexSync(r'phone', [phone]);
  }

  Future<bool> deleteByPhone(String phone) {
    return deleteByIndex(r'phone', [phone]);
  }

  bool deleteByPhoneSync(String phone) {
    return deleteByIndexSync(r'phone', [phone]);
  }

  Future<List<ServerAccount?>> getAllByPhone(List<String> phoneValues) {
    final values = phoneValues.map((e) => [e]).toList();
    return getAllByIndex(r'phone', values);
  }

  List<ServerAccount?> getAllByPhoneSync(List<String> phoneValues) {
    final values = phoneValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'phone', values);
  }

  Future<int> deleteAllByPhone(List<String> phoneValues) {
    final values = phoneValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'phone', values);
  }

  int deleteAllByPhoneSync(List<String> phoneValues) {
    final values = phoneValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'phone', values);
  }

  Future<Id> putByPhone(ServerAccount object) {
    return putByIndex(r'phone', object);
  }

  Id putByPhoneSync(ServerAccount object, {bool saveLinks = true}) {
    return putByIndexSync(r'phone', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPhone(List<ServerAccount> objects) {
    return putAllByIndex(r'phone', objects);
  }

  List<Id> putAllByPhoneSync(List<ServerAccount> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'phone', objects, saveLinks: saveLinks);
  }
}

extension ServerAccountQueryWhereSort on QueryBuilder<ServerAccount, ServerAccount, QWhere> {
  QueryBuilder<ServerAccount, ServerAccount, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ServerAccountQueryWhere on QueryBuilder<ServerAccount, ServerAccount, QWhereClause> {
  QueryBuilder<ServerAccount, ServerAccount, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ServerAccount, ServerAccount, QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: include));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: include));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterWhereClause> idBetween(
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

  QueryBuilder<ServerAccount, ServerAccount, QAfterWhereClause> phoneEqualTo(String phone) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(indexName: r'phone', value: [phone]));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterWhereClause> phoneNotEqualTo(String phone) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(indexName: r'phone', lower: [], upper: [phone], includeUpper: false),
            )
            .addWhereClause(
              IndexWhereClause.between(indexName: r'phone', lower: [phone], includeLower: false, upper: []),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(indexName: r'phone', lower: [phone], includeLower: false, upper: []),
            )
            .addWhereClause(
              IndexWhereClause.between(indexName: r'phone', lower: [], upper: [phone], includeUpper: false),
            );
      }
    });
  }
}

extension ServerAccountQueryFilter on QueryBuilder<ServerAccount, ServerAccount, QFilterCondition> {
  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> accountNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountNumber', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> accountNumberGreaterThan(
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

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> accountNumberLessThan(
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

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> accountNumberBetween(
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

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> accountNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'accountNumber', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> accountNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'accountNumber', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> accountNumberContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'accountNumber', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> accountNumberMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'accountNumber', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> accountNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'accountNumber', value: ''));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> accountNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'accountNumber', value: ''));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> balanceKoboEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'balanceKobo', value: value));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> balanceKoboGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'balanceKobo', value: value),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> balanceKoboLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'balanceKobo', value: value),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> balanceKoboBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'balanceKobo',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> bvnVerifiedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'bvnVerified', value: value));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> emailEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'email', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> emailGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'email', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> emailLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'email', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> emailBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'email',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'email', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'email', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> emailContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'email', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> emailMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'email', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'email', value: ''));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'email', value: ''));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> fullNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fullName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> fullNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> fullNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'fullName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> fullNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fullName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> fullNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'fullName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> fullNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'fullName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> fullNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'fullName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> fullNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'fullName', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> fullNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'fullName', value: ''));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> fullNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'fullName', value: ''));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'id', value: value));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'passwordHash', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'passwordHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'passwordHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'passwordHash',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'passwordHash', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'passwordHash', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordHashContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'passwordHash', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordHashMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'passwordHash', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'passwordHash', value: ''));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'passwordHash', value: ''));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordSaltEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'passwordSalt', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordSaltGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'passwordSalt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordSaltLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'passwordSalt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordSaltBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'passwordSalt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordSaltStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'passwordSalt', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordSaltEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'passwordSalt', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordSaltContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'passwordSalt', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordSaltMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'passwordSalt', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordSaltIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'passwordSalt', value: ''));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> passwordSaltIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'passwordSalt', value: ''));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> phoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> phoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> phoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> phoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'phone',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> phoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> phoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> phoneContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> phoneMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'phone', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'phone', value: ''));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'phone', value: ''));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinHashIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'pinHash'));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinHashIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'pinHash'));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinHashEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pinHash', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinHashGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'pinHash', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinHashLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'pinHash', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinHashBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pinHash',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'pinHash', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'pinHash', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinHashContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'pinHash', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinHashMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'pinHash', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'pinHash', value: ''));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'pinHash', value: ''));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinSaltIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'pinSalt'));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinSaltIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'pinSalt'));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinSaltEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pinSalt', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinSaltGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'pinSalt', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinSaltLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'pinSalt', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinSaltBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pinSalt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinSaltStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'pinSalt', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinSaltEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'pinSalt', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinSaltContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'pinSalt', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinSaltMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'pinSalt', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinSaltIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'pinSalt', value: ''));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> pinSaltIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'pinSalt', value: ''));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> tierEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'tier', value: value));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> tierGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'tier', value: value));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> tierLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'tier', value: value));
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterFilterCondition> tierBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tier',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ServerAccountQueryObject on QueryBuilder<ServerAccount, ServerAccount, QFilterCondition> {}

extension ServerAccountQueryLinks on QueryBuilder<ServerAccount, ServerAccount, QFilterCondition> {}

extension ServerAccountQuerySortBy on QueryBuilder<ServerAccount, ServerAccount, QSortBy> {
  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByAccountNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByAccountNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByBalanceKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceKobo', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByBalanceKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceKobo', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByBvnVerified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bvnVerified', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByBvnVerifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bvnVerified', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByPasswordHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordHash', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByPasswordHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordHash', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByPasswordSalt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordSalt', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByPasswordSaltDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordSalt', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByPinHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinHash', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByPinHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinHash', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByPinSalt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinSalt', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByPinSaltDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinSalt', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByTier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tier', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> sortByTierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tier', Sort.desc);
    });
  }
}

extension ServerAccountQuerySortThenBy on QueryBuilder<ServerAccount, ServerAccount, QSortThenBy> {
  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByAccountNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByAccountNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByBalanceKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceKobo', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByBalanceKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceKobo', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByBvnVerified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bvnVerified', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByBvnVerifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bvnVerified', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByPasswordHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordHash', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByPasswordHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordHash', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByPasswordSalt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordSalt', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByPasswordSaltDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordSalt', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByPinHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinHash', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByPinHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinHash', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByPinSalt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinSalt', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByPinSaltDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinSalt', Sort.desc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByTier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tier', Sort.asc);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QAfterSortBy> thenByTierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tier', Sort.desc);
    });
  }
}

extension ServerAccountQueryWhereDistinct on QueryBuilder<ServerAccount, ServerAccount, QDistinct> {
  QueryBuilder<ServerAccount, ServerAccount, QDistinct> distinctByAccountNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QDistinct> distinctByBalanceKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'balanceKobo');
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QDistinct> distinctByBvnVerified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bvnVerified');
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QDistinct> distinctByEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QDistinct> distinctByFullName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QDistinct> distinctByPasswordHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'passwordHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QDistinct> distinctByPasswordSalt({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'passwordSalt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QDistinct> distinctByPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QDistinct> distinctByPinHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QDistinct> distinctByPinSalt({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinSalt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerAccount, ServerAccount, QDistinct> distinctByTier() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tier');
    });
  }
}

extension ServerAccountQueryProperty on QueryBuilder<ServerAccount, ServerAccount, QQueryProperty> {
  QueryBuilder<ServerAccount, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ServerAccount, String, QQueryOperations> accountNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountNumber');
    });
  }

  QueryBuilder<ServerAccount, int, QQueryOperations> balanceKoboProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'balanceKobo');
    });
  }

  QueryBuilder<ServerAccount, bool, QQueryOperations> bvnVerifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bvnVerified');
    });
  }

  QueryBuilder<ServerAccount, String, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<ServerAccount, String, QQueryOperations> fullNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullName');
    });
  }

  QueryBuilder<ServerAccount, String, QQueryOperations> passwordHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'passwordHash');
    });
  }

  QueryBuilder<ServerAccount, String, QQueryOperations> passwordSaltProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'passwordSalt');
    });
  }

  QueryBuilder<ServerAccount, String, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<ServerAccount, String?, QQueryOperations> pinHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinHash');
    });
  }

  QueryBuilder<ServerAccount, String?, QQueryOperations> pinSaltProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinSalt');
    });
  }

  QueryBuilder<ServerAccount, int, QQueryOperations> tierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tier');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetServerSessionCollection on Isar {
  IsarCollection<ServerSession> get serverSessions => this.collection();
}

const ServerSessionSchema = CollectionSchema(
  name: r'ServerSession',
  id: 6287051037410343408,
  properties: {
    r'issuedAt': PropertySchema(id: 0, name: r'issuedAt', type: IsarType.dateTime),
    r'phone': PropertySchema(id: 1, name: r'phone', type: IsarType.string),
    r'token': PropertySchema(id: 2, name: r'token', type: IsarType.string),
  },

  estimateSize: _serverSessionEstimateSize,
  serialize: _serverSessionSerialize,
  deserialize: _serverSessionDeserialize,
  deserializeProp: _serverSessionDeserializeProp,
  idName: r'id',
  indexes: {
    r'token': IndexSchema(
      id: -5898650166254967271,
      name: r'token',
      unique: true,
      replace: false,
      properties: [IndexPropertySchema(name: r'token', type: IndexType.hash, caseSensitive: true)],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _serverSessionGetId,
  getLinks: _serverSessionGetLinks,
  attach: _serverSessionAttach,
  version: '3.3.2',
);

int _serverSessionEstimateSize(ServerSession object, List<int> offsets, Map<Type, List<int>> allOffsets) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.phone.length * 3;
  bytesCount += 3 + object.token.length * 3;
  return bytesCount;
}

void _serverSessionSerialize(
  ServerSession object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.issuedAt);
  writer.writeString(offsets[1], object.phone);
  writer.writeString(offsets[2], object.token);
}

ServerSession _serverSessionDeserialize(Id id, IsarReader reader, List<int> offsets, Map<Type, List<int>> allOffsets) {
  final object = ServerSession();
  object.id = id;
  object.issuedAt = reader.readDateTime(offsets[0]);
  object.phone = reader.readString(offsets[1]);
  object.token = reader.readString(offsets[2]);
  return object;
}

P _serverSessionDeserializeProp<P>(IsarReader reader, int propertyId, int offset, Map<Type, List<int>> allOffsets) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _serverSessionGetId(ServerSession object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _serverSessionGetLinks(ServerSession object) {
  return [];
}

void _serverSessionAttach(IsarCollection<dynamic> col, Id id, ServerSession object) {
  object.id = id;
}

extension ServerSessionByIndex on IsarCollection<ServerSession> {
  Future<ServerSession?> getByToken(String token) {
    return getByIndex(r'token', [token]);
  }

  ServerSession? getByTokenSync(String token) {
    return getByIndexSync(r'token', [token]);
  }

  Future<bool> deleteByToken(String token) {
    return deleteByIndex(r'token', [token]);
  }

  bool deleteByTokenSync(String token) {
    return deleteByIndexSync(r'token', [token]);
  }

  Future<List<ServerSession?>> getAllByToken(List<String> tokenValues) {
    final values = tokenValues.map((e) => [e]).toList();
    return getAllByIndex(r'token', values);
  }

  List<ServerSession?> getAllByTokenSync(List<String> tokenValues) {
    final values = tokenValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'token', values);
  }

  Future<int> deleteAllByToken(List<String> tokenValues) {
    final values = tokenValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'token', values);
  }

  int deleteAllByTokenSync(List<String> tokenValues) {
    final values = tokenValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'token', values);
  }

  Future<Id> putByToken(ServerSession object) {
    return putByIndex(r'token', object);
  }

  Id putByTokenSync(ServerSession object, {bool saveLinks = true}) {
    return putByIndexSync(r'token', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByToken(List<ServerSession> objects) {
    return putAllByIndex(r'token', objects);
  }

  List<Id> putAllByTokenSync(List<ServerSession> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'token', objects, saveLinks: saveLinks);
  }
}

extension ServerSessionQueryWhereSort on QueryBuilder<ServerSession, ServerSession, QWhere> {
  QueryBuilder<ServerSession, ServerSession, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ServerSessionQueryWhere on QueryBuilder<ServerSession, ServerSession, QWhereClause> {
  QueryBuilder<ServerSession, ServerSession, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ServerSession, ServerSession, QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: include));
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: include));
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterWhereClause> idBetween(
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

  QueryBuilder<ServerSession, ServerSession, QAfterWhereClause> tokenEqualTo(String token) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(indexName: r'token', value: [token]));
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterWhereClause> tokenNotEqualTo(String token) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(indexName: r'token', lower: [], upper: [token], includeUpper: false),
            )
            .addWhereClause(
              IndexWhereClause.between(indexName: r'token', lower: [token], includeLower: false, upper: []),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(indexName: r'token', lower: [token], includeLower: false, upper: []),
            )
            .addWhereClause(
              IndexWhereClause.between(indexName: r'token', lower: [], upper: [token], includeUpper: false),
            );
      }
    });
  }
}

extension ServerSessionQueryFilter on QueryBuilder<ServerSession, ServerSession, QFilterCondition> {
  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'id', value: value));
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> issuedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'issuedAt', value: value));
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> issuedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'issuedAt', value: value),
      );
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> issuedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'issuedAt', value: value));
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> issuedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'issuedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> phoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> phoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> phoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> phoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'phone',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> phoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> phoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> phoneContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> phoneMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'phone', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'phone', value: ''));
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'phone', value: ''));
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> tokenEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'token', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> tokenGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'token', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> tokenLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'token', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> tokenBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'token',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> tokenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'token', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> tokenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'token', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> tokenContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'token', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> tokenMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'token', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> tokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'token', value: ''));
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterFilterCondition> tokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'token', value: ''));
    });
  }
}

extension ServerSessionQueryObject on QueryBuilder<ServerSession, ServerSession, QFilterCondition> {}

extension ServerSessionQueryLinks on QueryBuilder<ServerSession, ServerSession, QFilterCondition> {}

extension ServerSessionQuerySortBy on QueryBuilder<ServerSession, ServerSession, QSortBy> {
  QueryBuilder<ServerSession, ServerSession, QAfterSortBy> sortByIssuedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedAt', Sort.asc);
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterSortBy> sortByIssuedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedAt', Sort.desc);
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterSortBy> sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterSortBy> sortByToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.asc);
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterSortBy> sortByTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.desc);
    });
  }
}

extension ServerSessionQuerySortThenBy on QueryBuilder<ServerSession, ServerSession, QSortThenBy> {
  QueryBuilder<ServerSession, ServerSession, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterSortBy> thenByIssuedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedAt', Sort.asc);
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterSortBy> thenByIssuedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedAt', Sort.desc);
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterSortBy> thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterSortBy> thenByToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.asc);
    });
  }

  QueryBuilder<ServerSession, ServerSession, QAfterSortBy> thenByTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.desc);
    });
  }
}

extension ServerSessionQueryWhereDistinct on QueryBuilder<ServerSession, ServerSession, QDistinct> {
  QueryBuilder<ServerSession, ServerSession, QDistinct> distinctByIssuedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'issuedAt');
    });
  }

  QueryBuilder<ServerSession, ServerSession, QDistinct> distinctByPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerSession, ServerSession, QDistinct> distinctByToken({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'token', caseSensitive: caseSensitive);
    });
  }
}

extension ServerSessionQueryProperty on QueryBuilder<ServerSession, ServerSession, QQueryProperty> {
  QueryBuilder<ServerSession, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ServerSession, DateTime, QQueryOperations> issuedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'issuedAt');
    });
  }

  QueryBuilder<ServerSession, String, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<ServerSession, String, QQueryOperations> tokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'token');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetServerTransactionCollection on Isar {
  IsarCollection<ServerTransaction> get serverTransactions => this.collection();
}

const ServerTransactionSchema = CollectionSchema(
  name: r'ServerTransaction',
  id: -2289498904755433009,
  properties: {
    r'amountKobo': PropertySchema(id: 0, name: r'amountKobo', type: IsarType.long),
    r'createdAt': PropertySchema(id: 1, name: r'createdAt', type: IsarType.dateTime),
    r'direction': PropertySchema(id: 2, name: r'direction', type: IsarType.string),
    r'feeKobo': PropertySchema(id: 3, name: r'feeKobo', type: IsarType.long),
    r'goalClientId': PropertySchema(id: 4, name: r'goalClientId', type: IsarType.string),
    r'idempotencyKey': PropertySchema(id: 5, name: r'idempotencyKey', type: IsarType.string),
    r'kind': PropertySchema(id: 6, name: r'kind', type: IsarType.string),
    r'narration': PropertySchema(id: 7, name: r'narration', type: IsarType.string),
    r'phone': PropertySchema(id: 8, name: r'phone', type: IsarType.string),
    r'ref': PropertySchema(id: 9, name: r'ref', type: IsarType.string),
    r'subtitle': PropertySchema(id: 10, name: r'subtitle', type: IsarType.string),
    r'title': PropertySchema(id: 11, name: r'title', type: IsarType.string),
  },

  estimateSize: _serverTransactionEstimateSize,
  serialize: _serverTransactionSerialize,
  deserialize: _serverTransactionDeserialize,
  deserializeProp: _serverTransactionDeserializeProp,
  idName: r'id',
  indexes: {
    r'phone': IndexSchema(
      id: -6308098324157559207,
      name: r'phone',
      unique: false,
      replace: false,
      properties: [IndexPropertySchema(name: r'phone', type: IndexType.hash, caseSensitive: true)],
    ),
    r'ref': IndexSchema(
      id: -6066889550123943304,
      name: r'ref',
      unique: true,
      replace: false,
      properties: [IndexPropertySchema(name: r'ref', type: IndexType.hash, caseSensitive: true)],
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

  getId: _serverTransactionGetId,
  getLinks: _serverTransactionGetLinks,
  attach: _serverTransactionAttach,
  version: '3.3.2',
);

int _serverTransactionEstimateSize(ServerTransaction object, List<int> offsets, Map<Type, List<int>> allOffsets) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.direction.length * 3;
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
  bytesCount += 3 + object.kind.length * 3;
  {
    final value = object.narration;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.phone.length * 3;
  bytesCount += 3 + object.ref.length * 3;
  {
    final value = object.subtitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _serverTransactionSerialize(
  ServerTransaction object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amountKobo);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.direction);
  writer.writeLong(offsets[3], object.feeKobo);
  writer.writeString(offsets[4], object.goalClientId);
  writer.writeString(offsets[5], object.idempotencyKey);
  writer.writeString(offsets[6], object.kind);
  writer.writeString(offsets[7], object.narration);
  writer.writeString(offsets[8], object.phone);
  writer.writeString(offsets[9], object.ref);
  writer.writeString(offsets[10], object.subtitle);
  writer.writeString(offsets[11], object.title);
}

ServerTransaction _serverTransactionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ServerTransaction();
  object.amountKobo = reader.readLong(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.direction = reader.readString(offsets[2]);
  object.feeKobo = reader.readLong(offsets[3]);
  object.goalClientId = reader.readStringOrNull(offsets[4]);
  object.id = id;
  object.idempotencyKey = reader.readStringOrNull(offsets[5]);
  object.kind = reader.readString(offsets[6]);
  object.narration = reader.readStringOrNull(offsets[7]);
  object.phone = reader.readString(offsets[8]);
  object.ref = reader.readString(offsets[9]);
  object.subtitle = reader.readStringOrNull(offsets[10]);
  object.title = reader.readString(offsets[11]);
  return object;
}

P _serverTransactionDeserializeProp<P>(IsarReader reader, int propertyId, int offset, Map<Type, List<int>> allOffsets) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _serverTransactionGetId(ServerTransaction object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _serverTransactionGetLinks(ServerTransaction object) {
  return [];
}

void _serverTransactionAttach(IsarCollection<dynamic> col, Id id, ServerTransaction object) {
  object.id = id;
}

extension ServerTransactionByIndex on IsarCollection<ServerTransaction> {
  Future<ServerTransaction?> getByRef(String ref) {
    return getByIndex(r'ref', [ref]);
  }

  ServerTransaction? getByRefSync(String ref) {
    return getByIndexSync(r'ref', [ref]);
  }

  Future<bool> deleteByRef(String ref) {
    return deleteByIndex(r'ref', [ref]);
  }

  bool deleteByRefSync(String ref) {
    return deleteByIndexSync(r'ref', [ref]);
  }

  Future<List<ServerTransaction?>> getAllByRef(List<String> refValues) {
    final values = refValues.map((e) => [e]).toList();
    return getAllByIndex(r'ref', values);
  }

  List<ServerTransaction?> getAllByRefSync(List<String> refValues) {
    final values = refValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'ref', values);
  }

  Future<int> deleteAllByRef(List<String> refValues) {
    final values = refValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'ref', values);
  }

  int deleteAllByRefSync(List<String> refValues) {
    final values = refValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'ref', values);
  }

  Future<Id> putByRef(ServerTransaction object) {
    return putByIndex(r'ref', object);
  }

  Id putByRefSync(ServerTransaction object, {bool saveLinks = true}) {
    return putByIndexSync(r'ref', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRef(List<ServerTransaction> objects) {
    return putAllByIndex(r'ref', objects);
  }

  List<Id> putAllByRefSync(List<ServerTransaction> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'ref', objects, saveLinks: saveLinks);
  }
}

extension ServerTransactionQueryWhereSort on QueryBuilder<ServerTransaction, ServerTransaction, QWhere> {
  QueryBuilder<ServerTransaction, ServerTransaction, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IndexWhereClause.any(indexName: r'createdAt'));
    });
  }
}

extension ServerTransactionQueryWhere on QueryBuilder<ServerTransaction, ServerTransaction, QWhereClause> {
  QueryBuilder<ServerTransaction, ServerTransaction, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: include));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: include));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterWhereClause> idBetween(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterWhereClause> phoneEqualTo(String phone) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(indexName: r'phone', value: [phone]));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterWhereClause> phoneNotEqualTo(String phone) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(indexName: r'phone', lower: [], upper: [phone], includeUpper: false),
            )
            .addWhereClause(
              IndexWhereClause.between(indexName: r'phone', lower: [phone], includeLower: false, upper: []),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(indexName: r'phone', lower: [phone], includeLower: false, upper: []),
            )
            .addWhereClause(
              IndexWhereClause.between(indexName: r'phone', lower: [], upper: [phone], includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterWhereClause> refEqualTo(String ref) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(indexName: r'ref', value: [ref]));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterWhereClause> refNotEqualTo(String ref) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(indexName: r'ref', lower: [], upper: [ref], includeUpper: false))
            .addWhereClause(IndexWhereClause.between(indexName: r'ref', lower: [ref], includeLower: false, upper: []));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(indexName: r'ref', lower: [ref], includeLower: false, upper: []))
            .addWhereClause(IndexWhereClause.between(indexName: r'ref', lower: [], upper: [ref], includeUpper: false));
      }
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterWhereClause> createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(indexName: r'createdAt', value: [createdAt]));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterWhereClause> createdAtNotEqualTo(DateTime createdAt) {
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterWhereClause> createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(indexName: r'createdAt', lower: [createdAt], includeLower: include, upper: []),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterWhereClause> createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(indexName: r'createdAt', lower: [], upper: [createdAt], includeUpper: include),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterWhereClause> createdAtBetween(
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

extension ServerTransactionQueryFilter on QueryBuilder<ServerTransaction, ServerTransaction, QFilterCondition> {
  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> amountKoboEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'amountKobo', value: value));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> amountKoboGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'amountKobo', value: value),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> amountKoboLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'amountKobo', value: value),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> amountKoboBetween(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'createdAt', value: value));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'createdAt', value: value));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> directionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'direction', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> directionGreaterThan(
    String value, {
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> directionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'direction', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> directionBetween(
    String lower,
    String upper, {
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> directionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'direction', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> directionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'direction', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> directionContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'direction', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> directionMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'direction', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> directionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'direction', value: ''));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> directionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'direction', value: ''));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> feeKoboEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'feeKobo', value: value));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> feeKoboGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'feeKobo', value: value),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> feeKoboLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'feeKobo', value: value));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> feeKoboBetween(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> goalClientIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'goalClientId'));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> goalClientIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'goalClientId'));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> goalClientIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'goalClientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> goalClientIdGreaterThan(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> goalClientIdLessThan(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> goalClientIdBetween(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> goalClientIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'goalClientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> goalClientIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'goalClientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> goalClientIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'goalClientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> goalClientIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'goalClientId', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> goalClientIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'goalClientId', value: ''));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> goalClientIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'goalClientId', value: ''));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'id', value: value));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> idempotencyKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'idempotencyKey'));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> idempotencyKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'idempotencyKey'));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> idempotencyKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'idempotencyKey', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> idempotencyKeyGreaterThan(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> idempotencyKeyLessThan(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> idempotencyKeyBetween(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> idempotencyKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'idempotencyKey', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> idempotencyKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'idempotencyKey', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> idempotencyKeyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'idempotencyKey', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> idempotencyKeyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'idempotencyKey', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> idempotencyKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'idempotencyKey', value: ''));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> idempotencyKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'idempotencyKey', value: ''));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> kindEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'kind', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> kindGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'kind', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> kindLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'kind', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> kindBetween(
    String lower,
    String upper, {
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> kindStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'kind', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> kindEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'kind', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> kindContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'kind', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> kindMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'kind', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> kindIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'kind', value: ''));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> kindIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'kind', value: ''));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> narrationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'narration'));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> narrationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'narration'));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> narrationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'narration', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> narrationGreaterThan(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> narrationLessThan(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> narrationBetween(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> narrationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'narration', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> narrationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'narration', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> narrationContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'narration', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> narrationMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'narration', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> narrationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'narration', value: ''));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> narrationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'narration', value: ''));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> phoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> phoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> phoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> phoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'phone',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> phoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> phoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> phoneContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> phoneMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'phone', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'phone', value: ''));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'phone', value: ''));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> refEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ref', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> refGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'ref', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> refLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'ref', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> refBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ref',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> refStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'ref', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> refEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'ref', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> refContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'ref', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> refMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'ref', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> refIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'ref', value: ''));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> refIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'ref', value: ''));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> subtitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'subtitle'));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> subtitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'subtitle'));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> subtitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'subtitle', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> subtitleGreaterThan(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> subtitleLessThan(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> subtitleBetween(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> subtitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'subtitle', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> subtitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'subtitle', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> subtitleContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'subtitle', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> subtitleMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'subtitle', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> subtitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'subtitle', value: ''));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> subtitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'subtitle', value: ''));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> titleGreaterThan(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> titleLessThan(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> titleBetween(
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

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'title', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'title', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> titleContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'title', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> titleMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'title', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'title', value: ''));
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'title', value: ''));
    });
  }
}

extension ServerTransactionQueryObject on QueryBuilder<ServerTransaction, ServerTransaction, QFilterCondition> {}

extension ServerTransactionQueryLinks on QueryBuilder<ServerTransaction, ServerTransaction, QFilterCondition> {}

extension ServerTransactionQuerySortBy on QueryBuilder<ServerTransaction, ServerTransaction, QSortBy> {
  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByAmountKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountKobo', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByAmountKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountKobo', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByDirection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'direction', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByDirectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'direction', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByFeeKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeKobo', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByFeeKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeKobo', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByGoalClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalClientId', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByGoalClientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalClientId', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByIdempotencyKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByIdempotencyKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByNarration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narration', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByNarrationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narration', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ref', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ref', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortBySubtitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortBySubtitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension ServerTransactionQuerySortThenBy on QueryBuilder<ServerTransaction, ServerTransaction, QSortThenBy> {
  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByAmountKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountKobo', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByAmountKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountKobo', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByDirection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'direction', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByDirectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'direction', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByFeeKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeKobo', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByFeeKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeKobo', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByGoalClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalClientId', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByGoalClientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalClientId', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByIdempotencyKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByIdempotencyKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByNarration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narration', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByNarrationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narration', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ref', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ref', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenBySubtitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenBySubtitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.desc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension ServerTransactionQueryWhereDistinct on QueryBuilder<ServerTransaction, ServerTransaction, QDistinct> {
  QueryBuilder<ServerTransaction, ServerTransaction, QDistinct> distinctByAmountKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountKobo');
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QDistinct> distinctByDirection({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'direction', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QDistinct> distinctByFeeKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'feeKobo');
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QDistinct> distinctByGoalClientId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalClientId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QDistinct> distinctByIdempotencyKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idempotencyKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QDistinct> distinctByKind({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kind', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QDistinct> distinctByNarration({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'narration', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QDistinct> distinctByPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QDistinct> distinctByRef({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ref', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QDistinct> distinctBySubtitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subtitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerTransaction, ServerTransaction, QDistinct> distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension ServerTransactionQueryProperty on QueryBuilder<ServerTransaction, ServerTransaction, QQueryProperty> {
  QueryBuilder<ServerTransaction, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ServerTransaction, int, QQueryOperations> amountKoboProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountKobo');
    });
  }

  QueryBuilder<ServerTransaction, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ServerTransaction, String, QQueryOperations> directionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'direction');
    });
  }

  QueryBuilder<ServerTransaction, int, QQueryOperations> feeKoboProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'feeKobo');
    });
  }

  QueryBuilder<ServerTransaction, String?, QQueryOperations> goalClientIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalClientId');
    });
  }

  QueryBuilder<ServerTransaction, String?, QQueryOperations> idempotencyKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idempotencyKey');
    });
  }

  QueryBuilder<ServerTransaction, String, QQueryOperations> kindProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kind');
    });
  }

  QueryBuilder<ServerTransaction, String?, QQueryOperations> narrationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'narration');
    });
  }

  QueryBuilder<ServerTransaction, String, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<ServerTransaction, String, QQueryOperations> refProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ref');
    });
  }

  QueryBuilder<ServerTransaction, String?, QQueryOperations> subtitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subtitle');
    });
  }

  QueryBuilder<ServerTransaction, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetServerGoalCollection on Isar {
  IsarCollection<ServerGoal> get serverGoals => this.collection();
}

const ServerGoalSchema = CollectionSchema(
  name: r'ServerGoal',
  id: 3742497230383935669,
  properties: {
    r'clientId': PropertySchema(id: 0, name: r'clientId', type: IsarType.string),
    r'createdAt': PropertySchema(id: 1, name: r'createdAt', type: IsarType.dateTime),
    r'name': PropertySchema(id: 2, name: r'name', type: IsarType.string),
    r'phone': PropertySchema(id: 3, name: r'phone', type: IsarType.string),
    r'savedKobo': PropertySchema(id: 4, name: r'savedKobo', type: IsarType.long),
    r'targetDate': PropertySchema(id: 5, name: r'targetDate', type: IsarType.dateTime),
    r'targetKobo': PropertySchema(id: 6, name: r'targetKobo', type: IsarType.long),
  },

  estimateSize: _serverGoalEstimateSize,
  serialize: _serverGoalSerialize,
  deserialize: _serverGoalDeserialize,
  deserializeProp: _serverGoalDeserializeProp,
  idName: r'id',
  indexes: {
    r'clientId': IndexSchema(
      id: 2639372232964765565,
      name: r'clientId',
      unique: true,
      replace: false,
      properties: [IndexPropertySchema(name: r'clientId', type: IndexType.hash, caseSensitive: true)],
    ),
    r'phone': IndexSchema(
      id: -6308098324157559207,
      name: r'phone',
      unique: false,
      replace: false,
      properties: [IndexPropertySchema(name: r'phone', type: IndexType.hash, caseSensitive: true)],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _serverGoalGetId,
  getLinks: _serverGoalGetLinks,
  attach: _serverGoalAttach,
  version: '3.3.2',
);

int _serverGoalEstimateSize(ServerGoal object, List<int> offsets, Map<Type, List<int>> allOffsets) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.clientId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.phone.length * 3;
  return bytesCount;
}

void _serverGoalSerialize(ServerGoal object, IsarWriter writer, List<int> offsets, Map<Type, List<int>> allOffsets) {
  writer.writeString(offsets[0], object.clientId);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.name);
  writer.writeString(offsets[3], object.phone);
  writer.writeLong(offsets[4], object.savedKobo);
  writer.writeDateTime(offsets[5], object.targetDate);
  writer.writeLong(offsets[6], object.targetKobo);
}

ServerGoal _serverGoalDeserialize(Id id, IsarReader reader, List<int> offsets, Map<Type, List<int>> allOffsets) {
  final object = ServerGoal();
  object.clientId = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.name = reader.readString(offsets[2]);
  object.phone = reader.readString(offsets[3]);
  object.savedKobo = reader.readLong(offsets[4]);
  object.targetDate = reader.readDateTime(offsets[5]);
  object.targetKobo = reader.readLong(offsets[6]);
  return object;
}

P _serverGoalDeserializeProp<P>(IsarReader reader, int propertyId, int offset, Map<Type, List<int>> allOffsets) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _serverGoalGetId(ServerGoal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _serverGoalGetLinks(ServerGoal object) {
  return [];
}

void _serverGoalAttach(IsarCollection<dynamic> col, Id id, ServerGoal object) {
  object.id = id;
}

extension ServerGoalByIndex on IsarCollection<ServerGoal> {
  Future<ServerGoal?> getByClientId(String clientId) {
    return getByIndex(r'clientId', [clientId]);
  }

  ServerGoal? getByClientIdSync(String clientId) {
    return getByIndexSync(r'clientId', [clientId]);
  }

  Future<bool> deleteByClientId(String clientId) {
    return deleteByIndex(r'clientId', [clientId]);
  }

  bool deleteByClientIdSync(String clientId) {
    return deleteByIndexSync(r'clientId', [clientId]);
  }

  Future<List<ServerGoal?>> getAllByClientId(List<String> clientIdValues) {
    final values = clientIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'clientId', values);
  }

  List<ServerGoal?> getAllByClientIdSync(List<String> clientIdValues) {
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

  Future<Id> putByClientId(ServerGoal object) {
    return putByIndex(r'clientId', object);
  }

  Id putByClientIdSync(ServerGoal object, {bool saveLinks = true}) {
    return putByIndexSync(r'clientId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByClientId(List<ServerGoal> objects) {
    return putAllByIndex(r'clientId', objects);
  }

  List<Id> putAllByClientIdSync(List<ServerGoal> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'clientId', objects, saveLinks: saveLinks);
  }
}

extension ServerGoalQueryWhereSort on QueryBuilder<ServerGoal, ServerGoal, QWhere> {
  QueryBuilder<ServerGoal, ServerGoal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ServerGoalQueryWhere on QueryBuilder<ServerGoal, ServerGoal, QWhereClause> {
  QueryBuilder<ServerGoal, ServerGoal, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ServerGoal, ServerGoal, QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: include));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: include));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterWhereClause> idBetween(
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

  QueryBuilder<ServerGoal, ServerGoal, QAfterWhereClause> clientIdEqualTo(String clientId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(indexName: r'clientId', value: [clientId]));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterWhereClause> clientIdNotEqualTo(String clientId) {
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

  QueryBuilder<ServerGoal, ServerGoal, QAfterWhereClause> phoneEqualTo(String phone) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(indexName: r'phone', value: [phone]));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterWhereClause> phoneNotEqualTo(String phone) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(indexName: r'phone', lower: [], upper: [phone], includeUpper: false),
            )
            .addWhereClause(
              IndexWhereClause.between(indexName: r'phone', lower: [phone], includeLower: false, upper: []),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(indexName: r'phone', lower: [phone], includeLower: false, upper: []),
            )
            .addWhereClause(
              IndexWhereClause.between(indexName: r'phone', lower: [], upper: [phone], includeUpper: false),
            );
      }
    });
  }
}

extension ServerGoalQueryFilter on QueryBuilder<ServerGoal, ServerGoal, QFilterCondition> {
  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> clientIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'clientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> clientIdGreaterThan(
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

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> clientIdLessThan(
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

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> clientIdBetween(
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

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> clientIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'clientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> clientIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'clientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> clientIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'clientId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> clientIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'clientId', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> clientIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'clientId', value: ''));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> clientIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'clientId', value: ''));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'createdAt', value: value));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'createdAt', value: value));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'id', value: value));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'name', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'name', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'name', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'name', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'name', value: ''));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'name', value: ''));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> phoneEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> phoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> phoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> phoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'phone',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> phoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> phoneEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> phoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> phoneMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'phone', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'phone', value: ''));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'phone', value: ''));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> savedKoboEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'savedKobo', value: value));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> savedKoboGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'savedKobo', value: value),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> savedKoboLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'savedKobo', value: value));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> savedKoboBetween(
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

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> targetDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'targetDate', value: value));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> targetDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'targetDate', value: value),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> targetDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'targetDate', value: value),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> targetDateBetween(
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

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> targetKoboEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'targetKobo', value: value));
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> targetKoboGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'targetKobo', value: value),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> targetKoboLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'targetKobo', value: value),
      );
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterFilterCondition> targetKoboBetween(
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

extension ServerGoalQueryObject on QueryBuilder<ServerGoal, ServerGoal, QFilterCondition> {}

extension ServerGoalQueryLinks on QueryBuilder<ServerGoal, ServerGoal, QFilterCondition> {}

extension ServerGoalQuerySortBy on QueryBuilder<ServerGoal, ServerGoal, QSortBy> {
  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> sortByClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.asc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> sortByClientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.desc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> sortBySavedKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedKobo', Sort.asc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> sortBySavedKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedKobo', Sort.desc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> sortByTargetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDate', Sort.asc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> sortByTargetDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDate', Sort.desc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> sortByTargetKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetKobo', Sort.asc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> sortByTargetKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetKobo', Sort.desc);
    });
  }
}

extension ServerGoalQuerySortThenBy on QueryBuilder<ServerGoal, ServerGoal, QSortThenBy> {
  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> thenByClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.asc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> thenByClientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.desc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> thenBySavedKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedKobo', Sort.asc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> thenBySavedKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedKobo', Sort.desc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> thenByTargetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDate', Sort.asc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> thenByTargetDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDate', Sort.desc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> thenByTargetKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetKobo', Sort.asc);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QAfterSortBy> thenByTargetKoboDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetKobo', Sort.desc);
    });
  }
}

extension ServerGoalQueryWhereDistinct on QueryBuilder<ServerGoal, ServerGoal, QDistinct> {
  QueryBuilder<ServerGoal, ServerGoal, QDistinct> distinctByClientId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QDistinct> distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QDistinct> distinctByPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QDistinct> distinctBySavedKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'savedKobo');
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QDistinct> distinctByTargetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetDate');
    });
  }

  QueryBuilder<ServerGoal, ServerGoal, QDistinct> distinctByTargetKobo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetKobo');
    });
  }
}

extension ServerGoalQueryProperty on QueryBuilder<ServerGoal, ServerGoal, QQueryProperty> {
  QueryBuilder<ServerGoal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ServerGoal, String, QQueryOperations> clientIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientId');
    });
  }

  QueryBuilder<ServerGoal, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ServerGoal, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<ServerGoal, String, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<ServerGoal, int, QQueryOperations> savedKoboProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'savedKobo');
    });
  }

  QueryBuilder<ServerGoal, DateTime, QQueryOperations> targetDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetDate');
    });
  }

  QueryBuilder<ServerGoal, int, QQueryOperations> targetKoboProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetKobo');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetServerBeneficiaryCollection on Isar {
  IsarCollection<ServerBeneficiary> get serverBeneficiarys => this.collection();
}

const ServerBeneficiarySchema = CollectionSchema(
  name: r'ServerBeneficiary',
  id: -5797658689944693452,
  properties: {
    r'accountName': PropertySchema(id: 0, name: r'accountName', type: IsarType.string),
    r'accountNumber': PropertySchema(id: 1, name: r'accountNumber', type: IsarType.string),
    r'bankCode': PropertySchema(id: 2, name: r'bankCode', type: IsarType.string),
    r'bankName': PropertySchema(id: 3, name: r'bankName', type: IsarType.string),
    r'phone': PropertySchema(id: 4, name: r'phone', type: IsarType.string),
  },

  estimateSize: _serverBeneficiaryEstimateSize,
  serialize: _serverBeneficiarySerialize,
  deserialize: _serverBeneficiaryDeserialize,
  deserializeProp: _serverBeneficiaryDeserializeProp,
  idName: r'id',
  indexes: {
    r'phone': IndexSchema(
      id: -6308098324157559207,
      name: r'phone',
      unique: false,
      replace: false,
      properties: [IndexPropertySchema(name: r'phone', type: IndexType.hash, caseSensitive: true)],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _serverBeneficiaryGetId,
  getLinks: _serverBeneficiaryGetLinks,
  attach: _serverBeneficiaryAttach,
  version: '3.3.2',
);

int _serverBeneficiaryEstimateSize(ServerBeneficiary object, List<int> offsets, Map<Type, List<int>> allOffsets) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountName.length * 3;
  bytesCount += 3 + object.accountNumber.length * 3;
  bytesCount += 3 + object.bankCode.length * 3;
  bytesCount += 3 + object.bankName.length * 3;
  bytesCount += 3 + object.phone.length * 3;
  return bytesCount;
}

void _serverBeneficiarySerialize(
  ServerBeneficiary object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountName);
  writer.writeString(offsets[1], object.accountNumber);
  writer.writeString(offsets[2], object.bankCode);
  writer.writeString(offsets[3], object.bankName);
  writer.writeString(offsets[4], object.phone);
}

ServerBeneficiary _serverBeneficiaryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ServerBeneficiary();
  object.accountName = reader.readString(offsets[0]);
  object.accountNumber = reader.readString(offsets[1]);
  object.bankCode = reader.readString(offsets[2]);
  object.bankName = reader.readString(offsets[3]);
  object.id = id;
  object.phone = reader.readString(offsets[4]);
  return object;
}

P _serverBeneficiaryDeserializeProp<P>(IsarReader reader, int propertyId, int offset, Map<Type, List<int>> allOffsets) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _serverBeneficiaryGetId(ServerBeneficiary object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _serverBeneficiaryGetLinks(ServerBeneficiary object) {
  return [];
}

void _serverBeneficiaryAttach(IsarCollection<dynamic> col, Id id, ServerBeneficiary object) {
  object.id = id;
}

extension ServerBeneficiaryQueryWhereSort on QueryBuilder<ServerBeneficiary, ServerBeneficiary, QWhere> {
  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ServerBeneficiaryQueryWhere on QueryBuilder<ServerBeneficiary, ServerBeneficiary, QWhereClause> {
  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: include));
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: include));
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterWhereClause> idBetween(
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

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterWhereClause> phoneEqualTo(String phone) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(indexName: r'phone', value: [phone]));
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterWhereClause> phoneNotEqualTo(String phone) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(indexName: r'phone', lower: [], upper: [phone], includeUpper: false),
            )
            .addWhereClause(
              IndexWhereClause.between(indexName: r'phone', lower: [phone], includeLower: false, upper: []),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(indexName: r'phone', lower: [phone], includeLower: false, upper: []),
            )
            .addWhereClause(
              IndexWhereClause.between(indexName: r'phone', lower: [], upper: [phone], includeUpper: false),
            );
      }
    });
  }
}

extension ServerBeneficiaryQueryFilter on QueryBuilder<ServerBeneficiary, ServerBeneficiary, QFilterCondition> {
  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accountName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'accountName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'accountName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'accountName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'accountName', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'accountName', value: ''));
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'accountName', value: ''));
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountNumber', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNumberGreaterThan(
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

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNumberLessThan(
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

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNumberBetween(
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

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'accountNumber', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'accountNumber', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNumberContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'accountNumber', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNumberMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'accountNumber', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'accountNumber', value: ''));
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> accountNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'accountNumber', value: ''));
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bankCode', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankCodeGreaterThan(
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

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankCodeLessThan(
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

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankCodeBetween(
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

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'bankCode', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'bankCode', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankCodeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'bankCode', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankCodeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'bankCode', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'bankCode', value: ''));
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'bankCode', value: ''));
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bankName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankNameGreaterThan(
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

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankNameLessThan(
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

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankNameBetween(
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

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'bankName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'bankName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'bankName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'bankName', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'bankName', value: ''));
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> bankNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'bankName', value: ''));
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'id', value: value));
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> phoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> phoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> phoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> phoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'phone',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> phoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> phoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> phoneContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> phoneMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'phone', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'phone', value: ''));
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterFilterCondition> phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'phone', value: ''));
    });
  }
}

extension ServerBeneficiaryQueryObject on QueryBuilder<ServerBeneficiary, ServerBeneficiary, QFilterCondition> {}

extension ServerBeneficiaryQueryLinks on QueryBuilder<ServerBeneficiary, ServerBeneficiary, QFilterCondition> {}

extension ServerBeneficiaryQuerySortBy on QueryBuilder<ServerBeneficiary, ServerBeneficiary, QSortBy> {
  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> sortByAccountName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountName', Sort.asc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> sortByAccountNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountName', Sort.desc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> sortByAccountNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.asc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> sortByAccountNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.desc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> sortByBankCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankCode', Sort.asc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> sortByBankCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankCode', Sort.desc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> sortByBankName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankName', Sort.asc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> sortByBankNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankName', Sort.desc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }
}

extension ServerBeneficiaryQuerySortThenBy on QueryBuilder<ServerBeneficiary, ServerBeneficiary, QSortThenBy> {
  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> thenByAccountName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountName', Sort.asc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> thenByAccountNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountName', Sort.desc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> thenByAccountNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.asc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> thenByAccountNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.desc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> thenByBankCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankCode', Sort.asc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> thenByBankCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankCode', Sort.desc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> thenByBankName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankName', Sort.asc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> thenByBankNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankName', Sort.desc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QAfterSortBy> thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }
}

extension ServerBeneficiaryQueryWhereDistinct on QueryBuilder<ServerBeneficiary, ServerBeneficiary, QDistinct> {
  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QDistinct> distinctByAccountName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QDistinct> distinctByAccountNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QDistinct> distinctByBankCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bankCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QDistinct> distinctByBankName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bankName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServerBeneficiary, ServerBeneficiary, QDistinct> distinctByPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }
}

extension ServerBeneficiaryQueryProperty on QueryBuilder<ServerBeneficiary, ServerBeneficiary, QQueryProperty> {
  QueryBuilder<ServerBeneficiary, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ServerBeneficiary, String, QQueryOperations> accountNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountName');
    });
  }

  QueryBuilder<ServerBeneficiary, String, QQueryOperations> accountNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountNumber');
    });
  }

  QueryBuilder<ServerBeneficiary, String, QQueryOperations> bankCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bankCode');
    });
  }

  QueryBuilder<ServerBeneficiary, String, QQueryOperations> bankNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bankName');
    });
  }

  QueryBuilder<ServerBeneficiary, String, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProcessedRequestCollection on Isar {
  IsarCollection<ProcessedRequest> get processedRequests => this.collection();
}

const ProcessedRequestSchema = CollectionSchema(
  name: r'ProcessedRequest',
  id: -8760504309887509272,
  properties: {
    r'endpoint': PropertySchema(id: 0, name: r'endpoint', type: IsarType.string),
    r'idempotencyKey': PropertySchema(id: 1, name: r'idempotencyKey', type: IsarType.string),
    r'phone': PropertySchema(id: 2, name: r'phone', type: IsarType.string),
    r'processedAt': PropertySchema(id: 3, name: r'processedAt', type: IsarType.dateTime),
    r'responseJson': PropertySchema(id: 4, name: r'responseJson', type: IsarType.string),
  },

  estimateSize: _processedRequestEstimateSize,
  serialize: _processedRequestSerialize,
  deserialize: _processedRequestDeserialize,
  deserializeProp: _processedRequestDeserializeProp,
  idName: r'id',
  indexes: {
    r'idempotencyKey': IndexSchema(
      id: 6522471565226449816,
      name: r'idempotencyKey',
      unique: true,
      replace: false,
      properties: [IndexPropertySchema(name: r'idempotencyKey', type: IndexType.hash, caseSensitive: true)],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _processedRequestGetId,
  getLinks: _processedRequestGetLinks,
  attach: _processedRequestAttach,
  version: '3.3.2',
);

int _processedRequestEstimateSize(ProcessedRequest object, List<int> offsets, Map<Type, List<int>> allOffsets) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.endpoint.length * 3;
  bytesCount += 3 + object.idempotencyKey.length * 3;
  bytesCount += 3 + object.phone.length * 3;
  bytesCount += 3 + object.responseJson.length * 3;
  return bytesCount;
}

void _processedRequestSerialize(
  ProcessedRequest object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.endpoint);
  writer.writeString(offsets[1], object.idempotencyKey);
  writer.writeString(offsets[2], object.phone);
  writer.writeDateTime(offsets[3], object.processedAt);
  writer.writeString(offsets[4], object.responseJson);
}

ProcessedRequest _processedRequestDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProcessedRequest();
  object.endpoint = reader.readString(offsets[0]);
  object.id = id;
  object.idempotencyKey = reader.readString(offsets[1]);
  object.phone = reader.readString(offsets[2]);
  object.processedAt = reader.readDateTime(offsets[3]);
  object.responseJson = reader.readString(offsets[4]);
  return object;
}

P _processedRequestDeserializeProp<P>(IsarReader reader, int propertyId, int offset, Map<Type, List<int>> allOffsets) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _processedRequestGetId(ProcessedRequest object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _processedRequestGetLinks(ProcessedRequest object) {
  return [];
}

void _processedRequestAttach(IsarCollection<dynamic> col, Id id, ProcessedRequest object) {
  object.id = id;
}

extension ProcessedRequestByIndex on IsarCollection<ProcessedRequest> {
  Future<ProcessedRequest?> getByIdempotencyKey(String idempotencyKey) {
    return getByIndex(r'idempotencyKey', [idempotencyKey]);
  }

  ProcessedRequest? getByIdempotencyKeySync(String idempotencyKey) {
    return getByIndexSync(r'idempotencyKey', [idempotencyKey]);
  }

  Future<bool> deleteByIdempotencyKey(String idempotencyKey) {
    return deleteByIndex(r'idempotencyKey', [idempotencyKey]);
  }

  bool deleteByIdempotencyKeySync(String idempotencyKey) {
    return deleteByIndexSync(r'idempotencyKey', [idempotencyKey]);
  }

  Future<List<ProcessedRequest?>> getAllByIdempotencyKey(List<String> idempotencyKeyValues) {
    final values = idempotencyKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'idempotencyKey', values);
  }

  List<ProcessedRequest?> getAllByIdempotencyKeySync(List<String> idempotencyKeyValues) {
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

  Future<Id> putByIdempotencyKey(ProcessedRequest object) {
    return putByIndex(r'idempotencyKey', object);
  }

  Id putByIdempotencyKeySync(ProcessedRequest object, {bool saveLinks = true}) {
    return putByIndexSync(r'idempotencyKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdempotencyKey(List<ProcessedRequest> objects) {
    return putAllByIndex(r'idempotencyKey', objects);
  }

  List<Id> putAllByIdempotencyKeySync(List<ProcessedRequest> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'idempotencyKey', objects, saveLinks: saveLinks);
  }
}

extension ProcessedRequestQueryWhereSort on QueryBuilder<ProcessedRequest, ProcessedRequest, QWhere> {
  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProcessedRequestQueryWhere on QueryBuilder<ProcessedRequest, ProcessedRequest, QWhereClause> {
  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: include));
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: include));
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterWhereClause> idBetween(
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

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterWhereClause> idempotencyKeyEqualTo(String idempotencyKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(indexName: r'idempotencyKey', value: [idempotencyKey]));
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterWhereClause> idempotencyKeyNotEqualTo(String idempotencyKey) {
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
}

extension ProcessedRequestQueryFilter on QueryBuilder<ProcessedRequest, ProcessedRequest, QFilterCondition> {
  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> endpointEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'endpoint', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> endpointGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'endpoint',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> endpointLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'endpoint', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> endpointBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'endpoint',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> endpointStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'endpoint', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> endpointEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'endpoint', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> endpointContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'endpoint', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> endpointMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'endpoint', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> endpointIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'endpoint', value: ''));
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> endpointIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'endpoint', value: ''));
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'id', value: value));
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> idempotencyKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'idempotencyKey', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> idempotencyKeyGreaterThan(
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

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> idempotencyKeyLessThan(
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

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> idempotencyKeyBetween(
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

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> idempotencyKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'idempotencyKey', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> idempotencyKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'idempotencyKey', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> idempotencyKeyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'idempotencyKey', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> idempotencyKeyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'idempotencyKey', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> idempotencyKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'idempotencyKey', value: ''));
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> idempotencyKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'idempotencyKey', value: ''));
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> phoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> phoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> phoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> phoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'phone',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> phoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> phoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> phoneContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> phoneMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'phone', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'phone', value: ''));
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'phone', value: ''));
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> processedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'processedAt', value: value));
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> processedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'processedAt', value: value),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> processedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'processedAt', value: value),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> processedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'processedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> responseJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'responseJson', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> responseJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'responseJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> responseJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'responseJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> responseJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'responseJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> responseJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'responseJson', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> responseJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'responseJson', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> responseJsonContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'responseJson', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> responseJsonMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'responseJson', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> responseJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'responseJson', value: ''));
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterFilterCondition> responseJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'responseJson', value: ''));
    });
  }
}

extension ProcessedRequestQueryObject on QueryBuilder<ProcessedRequest, ProcessedRequest, QFilterCondition> {}

extension ProcessedRequestQueryLinks on QueryBuilder<ProcessedRequest, ProcessedRequest, QFilterCondition> {}

extension ProcessedRequestQuerySortBy on QueryBuilder<ProcessedRequest, ProcessedRequest, QSortBy> {
  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> sortByEndpoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endpoint', Sort.asc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> sortByEndpointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endpoint', Sort.desc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> sortByIdempotencyKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.asc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> sortByIdempotencyKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.desc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> sortByProcessedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processedAt', Sort.asc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> sortByProcessedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processedAt', Sort.desc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> sortByResponseJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responseJson', Sort.asc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> sortByResponseJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responseJson', Sort.desc);
    });
  }
}

extension ProcessedRequestQuerySortThenBy on QueryBuilder<ProcessedRequest, ProcessedRequest, QSortThenBy> {
  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> thenByEndpoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endpoint', Sort.asc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> thenByEndpointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endpoint', Sort.desc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> thenByIdempotencyKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.asc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> thenByIdempotencyKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.desc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> thenByProcessedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processedAt', Sort.asc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> thenByProcessedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processedAt', Sort.desc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> thenByResponseJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responseJson', Sort.asc);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QAfterSortBy> thenByResponseJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responseJson', Sort.desc);
    });
  }
}

extension ProcessedRequestQueryWhereDistinct on QueryBuilder<ProcessedRequest, ProcessedRequest, QDistinct> {
  QueryBuilder<ProcessedRequest, ProcessedRequest, QDistinct> distinctByEndpoint({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endpoint', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QDistinct> distinctByIdempotencyKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idempotencyKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QDistinct> distinctByPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QDistinct> distinctByProcessedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'processedAt');
    });
  }

  QueryBuilder<ProcessedRequest, ProcessedRequest, QDistinct> distinctByResponseJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'responseJson', caseSensitive: caseSensitive);
    });
  }
}

extension ProcessedRequestQueryProperty on QueryBuilder<ProcessedRequest, ProcessedRequest, QQueryProperty> {
  QueryBuilder<ProcessedRequest, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProcessedRequest, String, QQueryOperations> endpointProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endpoint');
    });
  }

  QueryBuilder<ProcessedRequest, String, QQueryOperations> idempotencyKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idempotencyKey');
    });
  }

  QueryBuilder<ProcessedRequest, String, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<ProcessedRequest, DateTime, QQueryOperations> processedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'processedAt');
    });
  }

  QueryBuilder<ProcessedRequest, String, QQueryOperations> responseJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'responseJson');
    });
  }
}
