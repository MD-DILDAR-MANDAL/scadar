import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scadar/core/database/app_database.dart';
import 'package:scadar/core/database/database_service.dart';
import 'package:scadar/core/database/models/budget_model.dart';
import 'package:scadar/core/database/models/expense_model.dart';
import 'package:scadar/core/database/models/income_model.dart';
import 'package:scadar/core/database/models/recurring_transaction_model.dart';

void main() {
  late AppDatabase db;
  late DatabaseService dbService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dbService = DatabaseService(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('DatabaseService Drift In-Memory Tests', () {
    test('save and retrieve expense', () async {
      final expense = ExpenseModel()
        ..amount = 50.0
        ..category = ExpenseCategory.shopping
        ..date = DateTime(2026, 10, 5)
        ..description = 'Groceries'
        ..currency = 'USD';

      await dbService.saveExpense(expense);
      final all = await dbService.getAllExpenses();
      expect(all.length, 1);
      expect(all.first.description, 'Groceries');
      expect(all.first.amount, 50.0);
      expect(all.first.category, ExpenseCategory.shopping);
    });

    test('save and retrieve income', () async {
      final income = IncomeModel()
        ..amount = 3000.0
        ..month = 10
        ..year = 2026
        ..currency = 'USD'
        ..dateAdded = DateTime(2026, 10, 1);

      await dbService.saveIncome(income);
      final monthIncomes = await dbService.getIncomesForMonth(10, 2026);
      expect(monthIncomes.length, 1);
      expect(monthIncomes.first.amount, 3000.0);
    });

    test('save and delete budget', () async {
      final budget = BudgetModel()
        ..limit = 400.0
        ..categoryName = 'utilities'
        ..month = 10
        ..year = 2026
        ..currency = 'USD';

      await dbService.saveBudget(budget);
      var budgets = await dbService.getBudgetsForMonth(10, 2026);
      expect(budgets.length, 1);

      await dbService.deleteBudget(budgets.first.id);
      budgets = await dbService.getBudgetsForMonth(10, 2026);
      expect(budgets.isEmpty, true);
    });

    test('clearAndRestoreAllData restores all items atomically', () async {
      final expense = ExpenseModel()
        ..amount = 12.0
        ..category = ExpenseCategory.health
        ..date = DateTime(2026, 10, 1)
        ..description = 'Medicine'
        ..currency = 'USD';

      final income = IncomeModel()
        ..amount = 1500.0
        ..month = 10
        ..year = 2026
        ..currency = 'USD'
        ..dateAdded = DateTime(2026, 10, 1);

      final budget = BudgetModel()
        ..limit = 100.0
        ..categoryName = 'health'
        ..month = 10
        ..year = 2026
        ..currency = 'USD';

      final recurring = RecurringTransactionModel()
        ..amount = 10.0
        ..isIncome = false
        ..expenseCategoryName = 'health'
        ..description = 'Supplements'
        ..currency = 'USD'
        ..interval = RecurrenceInterval.monthly
        ..nextExecutionDate = DateTime(2026, 11, 1)
        ..isActive = true;

      await dbService.clearAndRestoreAllData(
        expenses: [expense],
        incomes: [income],
        budgets: [budget],
        recurring: [recurring],
      );

      final expenses = await dbService.getAllExpenses();
      final incomes = await dbService.getAllIncomes();
      final budgets = await dbService.getAllBudgets();
      final recurringList = await dbService.getAllRecurringTransactions();

      expect(expenses.length, 1);
      expect(incomes.length, 1);
      expect(budgets.length, 1);
      expect(recurringList.length, 1);
      expect(expenses.first.description, 'Medicine');
      expect(recurringList.first.description, 'Supplements');
    });
  });
}

