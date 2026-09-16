// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProfileEntityCollection on Isar {
  IsarCollection<ProfileEntity> get profileEntitys => this.collection();
}

const ProfileEntitySchema = CollectionSchema(
  name: r'ProfileEntity',
  id: 2239510315175863988,
  properties: {
    r'accountNumber': PropertySchema(id: 0, name: r'accountNumber', type: IsarType.string),
    r'bvnVerified': PropertySchema(id: 1, name: r'bvnVerified', type: IsarType.bool),
    r'email': PropertySchema(id: 2, name: r'email', type: IsarType.string),
    r'fullName': PropertySchema(id: 3, name: r'fullName', type: IsarType.string),
    r'phone': PropertySchema(id: 4, name: r'phone', type: IsarType.string),
    r'tier': PropertySchema(id: 5, name: r'tier', type: IsarType.long),
  },

  estimateSize: _profileEntityEstimateSize,
  serialize: _profileEntitySerialize,
  deserialize: _profileEntityDeserialize,
  deserializeProp: _profileEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _profileEntityGetId,
  getLinks: _profileEntityGetLinks,
  attach: _profileEntityAttach,
  version: '3.3.2',
);

int _profileEntityEstimateSize(ProfileEntity object, List<int> offsets, Map<Type, List<int>> allOffsets) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountNumber.length * 3;
  bytesCount += 3 + object.email.length * 3;
  bytesCount += 3 + object.fullName.length * 3;
  bytesCount += 3 + object.phone.length * 3;
  return bytesCount;
}

void _profileEntitySerialize(
  ProfileEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountNumber);
  writer.writeBool(offsets[1], object.bvnVerified);
  writer.writeString(offsets[2], object.email);
  writer.writeString(offsets[3], object.fullName);
  writer.writeString(offsets[4], object.phone);
  writer.writeLong(offsets[5], object.tier);
}

ProfileEntity _profileEntityDeserialize(Id id, IsarReader reader, List<int> offsets, Map<Type, List<int>> allOffsets) {
  final object = ProfileEntity();
  object.accountNumber = reader.readString(offsets[0]);
  object.bvnVerified = reader.readBool(offsets[1]);
  object.email = reader.readString(offsets[2]);
  object.fullName = reader.readString(offsets[3]);
  object.id = id;
  object.phone = reader.readString(offsets[4]);
  object.tier = reader.readLong(offsets[5]);
  return object;
}

P _profileEntityDeserializeProp<P>(IsarReader reader, int propertyId, int offset, Map<Type, List<int>> allOffsets) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _profileEntityGetId(ProfileEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _profileEntityGetLinks(ProfileEntity object) {
  return [];
}

void _profileEntityAttach(IsarCollection<dynamic> col, Id id, ProfileEntity object) {
  object.id = id;
}

extension ProfileEntityQueryWhereSort on QueryBuilder<ProfileEntity, ProfileEntity, QWhere> {
  QueryBuilder<ProfileEntity, ProfileEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProfileEntityQueryWhere on QueryBuilder<ProfileEntity, ProfileEntity, QWhereClause> {
  QueryBuilder<ProfileEntity, ProfileEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: include));
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: include));
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterWhereClause> idBetween(
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

extension ProfileEntityQueryFilter on QueryBuilder<ProfileEntity, ProfileEntity, QFilterCondition> {
  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> accountNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountNumber', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> accountNumberGreaterThan(
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

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> accountNumberLessThan(
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

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> accountNumberBetween(
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

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> accountNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'accountNumber', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> accountNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'accountNumber', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> accountNumberContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'accountNumber', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> accountNumberMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'accountNumber', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> accountNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'accountNumber', value: ''));
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> accountNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'accountNumber', value: ''));
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> bvnVerifiedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'bvnVerified', value: value));
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> emailEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'email', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> emailGreaterThan(
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

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> emailLessThan(
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

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> emailBetween(
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

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'email', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'email', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> emailContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'email', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> emailMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'email', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'email', value: ''));
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'email', value: ''));
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> fullNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fullName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> fullNameGreaterThan(
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

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> fullNameLessThan(
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

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> fullNameBetween(
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

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> fullNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'fullName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> fullNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'fullName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> fullNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'fullName', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> fullNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'fullName', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> fullNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'fullName', value: ''));
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> fullNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'fullName', value: ''));
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'id', value: value));
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> phoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> phoneGreaterThan(
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

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> phoneLessThan(
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

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> phoneBetween(
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

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> phoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> phoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> phoneContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'phone', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> phoneMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(property: r'phone', wildcard: pattern, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'phone', value: ''));
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'phone', value: ''));
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> tierEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'tier', value: value));
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> tierGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'tier', value: value));
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> tierLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'tier', value: value));
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterFilterCondition> tierBetween(
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

extension ProfileEntityQueryObject on QueryBuilder<ProfileEntity, ProfileEntity, QFilterCondition> {}

extension ProfileEntityQueryLinks on QueryBuilder<ProfileEntity, ProfileEntity, QFilterCondition> {}

extension ProfileEntityQuerySortBy on QueryBuilder<ProfileEntity, ProfileEntity, QSortBy> {
  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> sortByAccountNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.asc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> sortByAccountNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.desc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> sortByBvnVerified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bvnVerified', Sort.asc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> sortByBvnVerifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bvnVerified', Sort.desc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> sortByFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.asc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> sortByFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.desc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> sortByTier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tier', Sort.asc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> sortByTierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tier', Sort.desc);
    });
  }
}

extension ProfileEntityQuerySortThenBy on QueryBuilder<ProfileEntity, ProfileEntity, QSortThenBy> {
  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> thenByAccountNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.asc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> thenByAccountNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.desc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> thenByBvnVerified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bvnVerified', Sort.asc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> thenByBvnVerifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bvnVerified', Sort.desc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> thenByFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.asc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> thenByFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.desc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> thenByTier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tier', Sort.asc);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QAfterSortBy> thenByTierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tier', Sort.desc);
    });
  }
}

extension ProfileEntityQueryWhereDistinct on QueryBuilder<ProfileEntity, ProfileEntity, QDistinct> {
  QueryBuilder<ProfileEntity, ProfileEntity, QDistinct> distinctByAccountNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QDistinct> distinctByBvnVerified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bvnVerified');
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QDistinct> distinctByEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QDistinct> distinctByFullName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QDistinct> distinctByPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProfileEntity, ProfileEntity, QDistinct> distinctByTier() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tier');
    });
  }
}

extension ProfileEntityQueryProperty on QueryBuilder<ProfileEntity, ProfileEntity, QQueryProperty> {
  QueryBuilder<ProfileEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProfileEntity, String, QQueryOperations> accountNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountNumber');
    });
  }

  QueryBuilder<ProfileEntity, bool, QQueryOperations> bvnVerifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bvnVerified');
    });
  }

  QueryBuilder<ProfileEntity, String, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<ProfileEntity, String, QQueryOperations> fullNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullName');
    });
  }

  QueryBuilder<ProfileEntity, String, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<ProfileEntity, int, QQueryOperations> tierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tier');
    });
  }
}
