import 'package:isar_community/isar.dart';
import 'package:scadar/core/database/models/expense_model.dart';

part 'budget_model.g.dart';

@collection
class BudgetModel {
  BudgetModel();

  Id id = Isar.autoIncrement;

  late double limit;

  String? categoryName; // Stored as String because nullable enums as bytes aren't supported

  @ignore
  ExpenseCategory? get category {
    if (categoryName == null) return null;
    return ExpenseCategory.values.firstWhere((e) => e.name == categoryName, orElse: () => ExpenseCategory.other);
  }

  set category(ExpenseCategory? value) {
    categoryName = value?.name;
  }

  late int month;

  late int year;

  late String currency;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'limit': limit,
      'categoryName': categoryName,
      'month': month,
      'year': year,
      'currency': currency,
    };
  }

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    final model = BudgetModel()
      ..limit = (json['limit'] as num).toDouble()
      ..categoryName = json['categoryName'] as String?
      ..month = json['month'] as int
      ..year = json['year'] as int
      ..currency = json['currency'] as String? ?? 'USD';
    if (json['id'] != null && json['id'] is int && (json['id'] as int) > 0) {
      model.id = json['id'] as int;
    }
    return model;
  }
}
