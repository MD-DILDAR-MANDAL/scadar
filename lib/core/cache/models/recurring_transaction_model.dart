import 'package:isar_community/isar.dart';
import 'package:scadar/core/cache/models/expense_model.dart';

part 'recurring_transaction_model.g.dart';

enum RecurrenceInterval { daily, weekly, biWeekly, monthly, yearly }

@collection
class RecurringTransactionModel {
  Id id = Isar.autoIncrement;

  late double amount;

  late bool isIncome;

  String? expenseCategoryName; // Only used if !isIncome.

  @ignore
  ExpenseCategory? get expenseCategory {
    if (expenseCategoryName == null) return null;
    return ExpenseCategory.values.firstWhere((e) => e.name == expenseCategoryName, orElse: () => ExpenseCategory.other);
  }

  set expenseCategory(ExpenseCategory? value) {
    expenseCategoryName = value?.name;
  }

  late String description;

  late String currency;

  @enumerated
  late RecurrenceInterval interval;

  late DateTime nextExecutionDate;

  late bool isActive;
}
