// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_cache_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetExchangeRateCacheModelCollection on Isar {
  IsarCollection<ExchangeRateCacheModel> get exchangeRateCacheModels =>
      this.collection();
}

const ExchangeRateCacheModelSchema = CollectionSchema(
  name: r'ExchangeRateCacheModel',
  id: -8077714231695487422,
  properties: {
    r'baseCurrency': PropertySchema(
      id: 0,
      name: r'baseCurrency',
      type: IsarType.string,
    ),
    r'lastUpdated': PropertySchema(
      id: 1,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'ratesJson': PropertySchema(
      id: 2,
      name: r'ratesJson',
      type: IsarType.string,
    ),
  },

  estimateSize: _exchangeRateCacheModelEstimateSize,
  serialize: _exchangeRateCacheModelSerialize,
  deserialize: _exchangeRateCacheModelDeserialize,
  deserializeProp: _exchangeRateCacheModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'baseCurrency': IndexSchema(
      id: -862513801833578591,
      name: r'baseCurrency',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'baseCurrency',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _exchangeRateCacheModelGetId,
  getLinks: _exchangeRateCacheModelGetLinks,
  attach: _exchangeRateCacheModelAttach,
  version: '3.3.2',
);

int _exchangeRateCacheModelEstimateSize(
  ExchangeRateCacheModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.baseCurrency.length * 3;
  bytesCount += 3 + object.ratesJson.length * 3;
  return bytesCount;
}

void _exchangeRateCacheModelSerialize(
  ExchangeRateCacheModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.baseCurrency);
  writer.writeDateTime(offsets[1], object.lastUpdated);
  writer.writeString(offsets[2], object.ratesJson);
}

ExchangeRateCacheModel _exchangeRateCacheModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ExchangeRateCacheModel();
  object.baseCurrency = reader.readString(offsets[0]);
  object.id = id;
  object.lastUpdated = reader.readDateTime(offsets[1]);
  object.ratesJson = reader.readString(offsets[2]);
  return object;
}

P _exchangeRateCacheModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _exchangeRateCacheModelGetId(ExchangeRateCacheModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _exchangeRateCacheModelGetLinks(
  ExchangeRateCacheModel object,
) {
  return [];
}

void _exchangeRateCacheModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  ExchangeRateCacheModel object,
) {
  object.id = id;
}

extension ExchangeRateCacheModelByIndex
    on IsarCollection<ExchangeRateCacheModel> {
  Future<ExchangeRateCacheModel?> getByBaseCurrency(String baseCurrency) {
    return getByIndex(r'baseCurrency', [baseCurrency]);
  }

  ExchangeRateCacheModel? getByBaseCurrencySync(String baseCurrency) {
    return getByIndexSync(r'baseCurrency', [baseCurrency]);
  }

  Future<bool> deleteByBaseCurrency(String baseCurrency) {
    return deleteByIndex(r'baseCurrency', [baseCurrency]);
  }

  bool deleteByBaseCurrencySync(String baseCurrency) {
    return deleteByIndexSync(r'baseCurrency', [baseCurrency]);
  }

  Future<List<ExchangeRateCacheModel?>> getAllByBaseCurrency(
    List<String> baseCurrencyValues,
  ) {
    final values = baseCurrencyValues.map((e) => [e]).toList();
    return getAllByIndex(r'baseCurrency', values);
  }

  List<ExchangeRateCacheModel?> getAllByBaseCurrencySync(
    List<String> baseCurrencyValues,
  ) {
    final values = baseCurrencyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'baseCurrency', values);
  }

  Future<int> deleteAllByBaseCurrency(List<String> baseCurrencyValues) {
    final values = baseCurrencyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'baseCurrency', values);
  }

  int deleteAllByBaseCurrencySync(List<String> baseCurrencyValues) {
    final values = baseCurrencyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'baseCurrency', values);
  }

  Future<Id> putByBaseCurrency(ExchangeRateCacheModel object) {
    return putByIndex(r'baseCurrency', object);
  }

  Id putByBaseCurrencySync(
    ExchangeRateCacheModel object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'baseCurrency', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByBaseCurrency(List<ExchangeRateCacheModel> objects) {
    return putAllByIndex(r'baseCurrency', objects);
  }

  List<Id> putAllByBaseCurrencySync(
    List<ExchangeRateCacheModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'baseCurrency', objects, saveLinks: saveLinks);
  }
}

extension ExchangeRateCacheModelQueryWhereSort
    on QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QWhere> {
  QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ExchangeRateCacheModelQueryWhere
    on
        QueryBuilder<
          ExchangeRateCacheModel,
          ExchangeRateCacheModel,
          QWhereClause
        > {
  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterWhereClause
  >
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterWhereClause
  >
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterWhereClause
  >
  baseCurrencyEqualTo(String baseCurrency) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'baseCurrency',
          value: [baseCurrency],
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterWhereClause
  >
  baseCurrencyNotEqualTo(String baseCurrency) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'baseCurrency',
                lower: [],
                upper: [baseCurrency],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'baseCurrency',
                lower: [baseCurrency],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'baseCurrency',
                lower: [baseCurrency],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'baseCurrency',
                lower: [],
                upper: [baseCurrency],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension ExchangeRateCacheModelQueryFilter
    on
        QueryBuilder<
          ExchangeRateCacheModel,
          ExchangeRateCacheModel,
          QFilterCondition
        > {
  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  baseCurrencyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'baseCurrency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  baseCurrencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'baseCurrency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  baseCurrencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'baseCurrency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  baseCurrencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'baseCurrency',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  baseCurrencyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'baseCurrency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  baseCurrencyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'baseCurrency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  baseCurrencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'baseCurrency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  baseCurrencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'baseCurrency',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  baseCurrencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'baseCurrency', value: ''),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  baseCurrencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'baseCurrency', value: ''),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  idBetween(
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

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  lastUpdatedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastUpdated', value: value),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  lastUpdatedGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastUpdated',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  lastUpdatedLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastUpdated',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  lastUpdatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastUpdated',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  ratesJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'ratesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  ratesJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'ratesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  ratesJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'ratesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  ratesJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ratesJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  ratesJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'ratesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  ratesJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'ratesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  ratesJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'ratesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  ratesJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'ratesJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  ratesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ratesJson', value: ''),
      );
    });
  }

  QueryBuilder<
    ExchangeRateCacheModel,
    ExchangeRateCacheModel,
    QAfterFilterCondition
  >
  ratesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'ratesJson', value: ''),
      );
    });
  }
}

extension ExchangeRateCacheModelQueryObject
    on
        QueryBuilder<
          ExchangeRateCacheModel,
          ExchangeRateCacheModel,
          QFilterCondition
        > {}

extension ExchangeRateCacheModelQueryLinks
    on
        QueryBuilder<
          ExchangeRateCacheModel,
          ExchangeRateCacheModel,
          QFilterCondition
        > {}

extension ExchangeRateCacheModelQuerySortBy
    on QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QSortBy> {
  QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QAfterSortBy>
  sortByBaseCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseCurrency', Sort.asc);
    });
  }

  QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QAfterSortBy>
  sortByBaseCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseCurrency', Sort.desc);
    });
  }

  QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QAfterSortBy>
  sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QAfterSortBy>
  sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QAfterSortBy>
  sortByRatesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ratesJson', Sort.asc);
    });
  }

  QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QAfterSortBy>
  sortByRatesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ratesJson', Sort.desc);
    });
  }
}

extension ExchangeRateCacheModelQuerySortThenBy
    on
        QueryBuilder<
          ExchangeRateCacheModel,
          ExchangeRateCacheModel,
          QSortThenBy
        > {
  QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QAfterSortBy>
  thenByBaseCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseCurrency', Sort.asc);
    });
  }

  QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QAfterSortBy>
  thenByBaseCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseCurrency', Sort.desc);
    });
  }

  QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QAfterSortBy>
  thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QAfterSortBy>
  thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QAfterSortBy>
  thenByRatesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ratesJson', Sort.asc);
    });
  }

  QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QAfterSortBy>
  thenByRatesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ratesJson', Sort.desc);
    });
  }
}

extension ExchangeRateCacheModelQueryWhereDistinct
    on QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QDistinct> {
  QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QDistinct>
  distinctByBaseCurrency({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseCurrency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QDistinct>
  distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<ExchangeRateCacheModel, ExchangeRateCacheModel, QDistinct>
  distinctByRatesJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ratesJson', caseSensitive: caseSensitive);
    });
  }
}

extension ExchangeRateCacheModelQueryProperty
    on
        QueryBuilder<
          ExchangeRateCacheModel,
          ExchangeRateCacheModel,
          QQueryProperty
        > {
  QueryBuilder<ExchangeRateCacheModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ExchangeRateCacheModel, String, QQueryOperations>
  baseCurrencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseCurrency');
    });
  }

  QueryBuilder<ExchangeRateCacheModel, DateTime, QQueryOperations>
  lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<ExchangeRateCacheModel, String, QQueryOperations>
  ratesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ratesJson');
    });
  }
}
