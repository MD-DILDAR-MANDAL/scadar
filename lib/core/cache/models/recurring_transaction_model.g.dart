// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecurringTransactionModelCollection on Isar {
  IsarCollection<RecurringTransactionModel> get recurringTransactionModels =>
      this.collection();
}

const RecurringTransactionModelSchema = CollectionSchema(
  name: r'RecurringTransactionModel',
  id: 6130514885703977993,
  properties: {
    r'amount': PropertySchema(id: 0, name: r'amount', type: IsarType.double),
    r'currency': PropertySchema(
      id: 1,
      name: r'currency',
      type: IsarType.string,
    ),
    r'description': PropertySchema(
      id: 2,
      name: r'description',
      type: IsarType.string,
    ),
    r'expenseCategoryName': PropertySchema(
      id: 3,
      name: r'expenseCategoryName',
      type: IsarType.string,
    ),
    r'interval': PropertySchema(
      id: 4,
      name: r'interval',
      type: IsarType.byte,
      enumMap: _RecurringTransactionModelintervalEnumValueMap,
    ),
    r'isActive': PropertySchema(id: 5, name: r'isActive', type: IsarType.bool),
    r'isIncome': PropertySchema(id: 6, name: r'isIncome', type: IsarType.bool),
    r'nextExecutionDate': PropertySchema(
      id: 7,
      name: r'nextExecutionDate',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _recurringTransactionModelEstimateSize,
  serialize: _recurringTransactionModelSerialize,
  deserialize: _recurringTransactionModelDeserialize,
  deserializeProp: _recurringTransactionModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _recurringTransactionModelGetId,
  getLinks: _recurringTransactionModelGetLinks,
  attach: _recurringTransactionModelAttach,
  version: '3.3.2',
);

int _recurringTransactionModelEstimateSize(
  RecurringTransactionModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.currency.length * 3;
  bytesCount += 3 + object.description.length * 3;
  {
    final value = object.expenseCategoryName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _recurringTransactionModelSerialize(
  RecurringTransactionModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeString(offsets[1], object.currency);
  writer.writeString(offsets[2], object.description);
  writer.writeString(offsets[3], object.expenseCategoryName);
  writer.writeByte(offsets[4], object.interval.index);
  writer.writeBool(offsets[5], object.isActive);
  writer.writeBool(offsets[6], object.isIncome);
  writer.writeDateTime(offsets[7], object.nextExecutionDate);
}

RecurringTransactionModel _recurringTransactionModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecurringTransactionModel();
  object.amount = reader.readDouble(offsets[0]);
  object.currency = reader.readString(offsets[1]);
  object.description = reader.readString(offsets[2]);
  object.expenseCategoryName = reader.readStringOrNull(offsets[3]);
  object.id = id;
  object.interval =
      _RecurringTransactionModelintervalValueEnumMap[reader.readByteOrNull(
        offsets[4],
      )] ??
      RecurrenceInterval.daily;
  object.isActive = reader.readBool(offsets[5]);
  object.isIncome = reader.readBool(offsets[6]);
  object.nextExecutionDate = reader.readDateTime(offsets[7]);
  return object;
}

P _recurringTransactionModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (_RecurringTransactionModelintervalValueEnumMap[reader
                  .readByteOrNull(offset)] ??
              RecurrenceInterval.daily)
          as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _RecurringTransactionModelintervalEnumValueMap = {
  'daily': 0,
  'weekly': 1,
  'biWeekly': 2,
  'monthly': 3,
  'yearly': 4,
};
const _RecurringTransactionModelintervalValueEnumMap = {
  0: RecurrenceInterval.daily,
  1: RecurrenceInterval.weekly,
  2: RecurrenceInterval.biWeekly,
  3: RecurrenceInterval.monthly,
  4: RecurrenceInterval.yearly,
};

Id _recurringTransactionModelGetId(RecurringTransactionModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recurringTransactionModelGetLinks(
  RecurringTransactionModel object,
) {
  return [];
}

void _recurringTransactionModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  RecurringTransactionModel object,
) {
  object.id = id;
}

extension RecurringTransactionModelQueryWhereSort
    on
        QueryBuilder<
          RecurringTransactionModel,
          RecurringTransactionModel,
          QWhere
        > {
  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterWhere
  >
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RecurringTransactionModelQueryWhere
    on
        QueryBuilder<
          RecurringTransactionModel,
          RecurringTransactionModel,
          QWhereClause
        > {
  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
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
    RecurringTransactionModel,
    RecurringTransactionModel,
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
    RecurringTransactionModel,
    RecurringTransactionModel,
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
    RecurringTransactionModel,
    RecurringTransactionModel,
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
}

extension RecurringTransactionModelQueryFilter
    on
        QueryBuilder<
          RecurringTransactionModel,
          RecurringTransactionModel,
          QFilterCondition
        > {
  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  amountEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'amount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'amount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'amount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'amount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  currencyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'currency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  currencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  currencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  currencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currency',
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
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  currencyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'currency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  currencyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'currency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  currencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'currency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  currencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'currency',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  currencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'currency', value: ''),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  currencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'currency', value: ''),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  descriptionEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'description',
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
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  descriptionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  descriptionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'description',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  expenseCategoryNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'expenseCategoryName'),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  expenseCategoryNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'expenseCategoryName'),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  expenseCategoryNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'expenseCategoryName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  expenseCategoryNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'expenseCategoryName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  expenseCategoryNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'expenseCategoryName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  expenseCategoryNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'expenseCategoryName',
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
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  expenseCategoryNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'expenseCategoryName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  expenseCategoryNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'expenseCategoryName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  expenseCategoryNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'expenseCategoryName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  expenseCategoryNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'expenseCategoryName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  expenseCategoryNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'expenseCategoryName', value: ''),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  expenseCategoryNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'expenseCategoryName',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
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
    RecurringTransactionModel,
    RecurringTransactionModel,
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
    RecurringTransactionModel,
    RecurringTransactionModel,
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
    RecurringTransactionModel,
    RecurringTransactionModel,
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
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  intervalEqualTo(RecurrenceInterval value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'interval', value: value),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  intervalGreaterThan(RecurrenceInterval value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'interval',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  intervalLessThan(RecurrenceInterval value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'interval',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  intervalBetween(
    RecurrenceInterval lower,
    RecurrenceInterval upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'interval',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  isIncomeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isIncome', value: value),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  nextExecutionDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'nextExecutionDate', value: value),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  nextExecutionDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'nextExecutionDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  nextExecutionDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'nextExecutionDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterFilterCondition
  >
  nextExecutionDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nextExecutionDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension RecurringTransactionModelQueryObject
    on
        QueryBuilder<
          RecurringTransactionModel,
          RecurringTransactionModel,
          QFilterCondition
        > {}

extension RecurringTransactionModelQueryLinks
    on
        QueryBuilder<
          RecurringTransactionModel,
          RecurringTransactionModel,
          QFilterCondition
        > {}

extension RecurringTransactionModelQuerySortBy
    on
        QueryBuilder<
          RecurringTransactionModel,
          RecurringTransactionModel,
          QSortBy
        > {
  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByExpenseCategoryName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseCategoryName', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByExpenseCategoryNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseCategoryName', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByIsIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isIncome', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByIsIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isIncome', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByNextExecutionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextExecutionDate', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  sortByNextExecutionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextExecutionDate', Sort.desc);
    });
  }
}

extension RecurringTransactionModelQuerySortThenBy
    on
        QueryBuilder<
          RecurringTransactionModel,
          RecurringTransactionModel,
          QSortThenBy
        > {
  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByExpenseCategoryName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseCategoryName', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByExpenseCategoryNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseCategoryName', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByIsIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isIncome', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByIsIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isIncome', Sort.desc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByNextExecutionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextExecutionDate', Sort.asc);
    });
  }

  QueryBuilder<
    RecurringTransactionModel,
    RecurringTransactionModel,
    QAfterSortBy
  >
  thenByNextExecutionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextExecutionDate', Sort.desc);
    });
  }
}

extension RecurringTransactionModelQueryWhereDistinct
    on
        QueryBuilder<
          RecurringTransactionModel,
          RecurringTransactionModel,
          QDistinct
        > {
  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByCurrency({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByExpenseCategoryName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'expenseCategoryName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'interval');
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByIsIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isIncome');
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurringTransactionModel, QDistinct>
  distinctByNextExecutionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextExecutionDate');
    });
  }
}

extension RecurringTransactionModelQueryProperty
    on
        QueryBuilder<
          RecurringTransactionModel,
          RecurringTransactionModel,
          QQueryProperty
        > {
  QueryBuilder<RecurringTransactionModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecurringTransactionModel, double, QQueryOperations>
  amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<RecurringTransactionModel, String, QQueryOperations>
  currencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currency');
    });
  }

  QueryBuilder<RecurringTransactionModel, String, QQueryOperations>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<RecurringTransactionModel, String?, QQueryOperations>
  expenseCategoryNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expenseCategoryName');
    });
  }

  QueryBuilder<RecurringTransactionModel, RecurrenceInterval, QQueryOperations>
  intervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'interval');
    });
  }

  QueryBuilder<RecurringTransactionModel, bool, QQueryOperations>
  isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<RecurringTransactionModel, bool, QQueryOperations>
  isIncomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isIncome');
    });
  }

  QueryBuilder<RecurringTransactionModel, DateTime, QQueryOperations>
  nextExecutionDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextExecutionDate');
    });
  }
}
