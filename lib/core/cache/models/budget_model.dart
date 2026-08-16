import 'package:isar_community/isar.dart';
import 'package:scadar/core/cache/models/expense_model.dart';

part 'budget_model.g.dart';

@collection
class BudgetModel {
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
}
