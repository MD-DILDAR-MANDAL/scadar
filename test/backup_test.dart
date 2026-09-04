import 'package:flutter_test/flutter_test.dart';
import 'package:scadar/core/cache/models/budget_model.dart';
import 'package:scadar/core/cache/models/expense_model.dart';
import 'package:scadar/core/cache/models/income_model.dart';
import 'package:scadar/core/cache/models/recurring_transaction_model.dart';

void main() {
  group('Model Serialization Tests', () {
    test('ExpenseModel toJson and fromJson', () {
      final now = DateTime(2026, 9, 4, 12, 0, 0);
      final expense = ExpenseModel()
        ..id = 1
        ..amount = 45.50
        ..category = ExpenseCategory.shopping
        ..date = now
        ..description = 'Groceries'
        ..currency = 'USD';

      final json = expense.toJson();
      expect(json['amount'], 45.50);
      expect(json['category'], 'shopping');
      expect(json['description'], 'Groceries');

      final fromJson = ExpenseModel.fromJson(json);
      expect(fromJson.amount, 45.50);
      expect(fromJson.category, ExpenseCategory.shopping);
      expect(fromJson.description, 'Groceries');
      expect(fromJson.currency, 'USD');
      expect(fromJson.date, now);
    });

    test('IncomeModel toJson and fromJson', () {
      final now = DateTime(2026, 9, 1, 10, 30, 0);
      final income = IncomeModel()
        ..id = 2
        ..amount = 2500.0
        ..month = 9
        ..year = 2026
        ..currency = 'EUR'
        ..dateAdded = now;

      final json = income.toJson();
      expect(json['amount'], 2500.0);
      expect(json['month'], 9);
      expect(json['year'], 2026);

      final fromJson = IncomeModel.fromJson(json);
      expect(fromJson.amount, 2500.0);
      expect(fromJson.month, 9);
      expect(fromJson.year, 2026);
      expect(fromJson.currency, 'EUR');
      expect(fromJson.dateAdded, now);
    });

    test('BudgetModel toJson and fromJson', () {
      final budget = BudgetModel()
        ..id = 3
        ..limit = 600.0
        ..category = ExpenseCategory.utilities
        ..month = 9
        ..year = 2026
        ..currency = 'USD';

      final json = budget.toJson();
      expect(json['limit'], 600.0);
      expect(json['categoryName'], 'utilities');

      final fromJson = BudgetModel.fromJson(json);
      expect(fromJson.limit, 600.0);
      expect(fromJson.category, ExpenseCategory.utilities);
      expect(fromJson.month, 9);
      expect(fromJson.year, 2026);
    });

    test('RecurringTransactionModel toJson and fromJson', () {
      final nextDate = DateTime(2026, 10, 1, 0, 0, 0);
      final recurring = RecurringTransactionModel()
        ..id = 4
        ..amount = 14.99
        ..isIncome = false
        ..expenseCategory = ExpenseCategory.subscription
        ..description = 'Streaming Service'
        ..currency = 'USD'
        ..interval = RecurrenceInterval.monthly
        ..nextExecutionDate = nextDate
        ..isActive = true;

      final json = recurring.toJson();
      expect(json['amount'], 14.99);
      expect(json['interval'], 'monthly');
      expect(json['isActive'], true);

      final fromJson = RecurringTransactionModel.fromJson(json);
      expect(fromJson.amount, 14.99);
      expect(fromJson.isIncome, false);
      expect(fromJson.expenseCategory, ExpenseCategory.subscription);
      expect(fromJson.interval, RecurrenceInterval.monthly);
      expect(fromJson.nextExecutionDate, nextDate);
    });
  });
}
