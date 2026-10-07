import 'package:scadar/core/database/models/expense_model.dart';

enum RecurrenceInterval { daily, weekly, biWeekly, monthly, yearly }

class RecurringTransactionModel {
  RecurringTransactionModel();

  int id = 0;

  late double amount;

  late bool isIncome;

  String? expenseCategoryName; // Only used if !isIncome.

  ExpenseCategory? get expenseCategory {
    if (expenseCategoryName == null) return null;
    return ExpenseCategory.values.firstWhere(
      (e) => e.name == expenseCategoryName,
      orElse: () => ExpenseCategory.other,
    );
  }

  set expenseCategory(ExpenseCategory? value) {
    expenseCategoryName = value?.name;
  }

  late String description;

  late String currency;

  late RecurrenceInterval interval;

  late DateTime nextExecutionDate;

  late bool isActive;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'isIncome': isIncome,
      'expenseCategoryName': expenseCategoryName,
      'description': description,
      'currency': currency,
      'interval': interval.name,
      'nextExecutionDate': nextExecutionDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory RecurringTransactionModel.fromJson(Map<String, dynamic> json) {
    final model = RecurringTransactionModel()
      ..amount = (json['amount'] as num).toDouble()
      ..isIncome = json['isIncome'] as bool? ?? false
      ..expenseCategoryName = json['expenseCategoryName'] as String?
      ..description = json['description'] as String? ?? ''
      ..currency = json['currency'] as String? ?? 'USD'
      ..interval = RecurrenceInterval.values.firstWhere(
        (e) => e.name == json['interval'],
        orElse: () => RecurrenceInterval.monthly,
      )
      ..nextExecutionDate = DateTime.parse(json['nextExecutionDate'] as String)
      ..isActive = json['isActive'] as bool? ?? true;
    if (json['id'] != null && json['id'] is int && (json['id'] as int) > 0) {
      model.id = json['id'] as int;
    }
    return model;
  }
}
