import 'package:scadar/core/database/isar_service.dart';
import 'package:scadar/core/database/models/expense_model.dart';
import 'package:scadar/core/database/models/income_model.dart';
import 'package:scadar/core/database/models/budget_model.dart';
import 'package:scadar/core/database/models/recurring_transaction_model.dart';

abstract class FinanceRepository {
  Future<void> saveIncome(IncomeModel income);
  Future<void> deleteIncome(int id);
  Future<List<IncomeModel>> getIncomesForMonth(int month, int year);
  Future<void> saveExpense(ExpenseModel expense);
  Future<void> deleteExpense(int id);
  Future<List<ExpenseModel>> getExpensesForMonth(int month, int year);
  Future<List<ExpenseModel>> getAllExpenses();
  Future<void> saveBudget(BudgetModel budget);
  Future<void> deleteBudget(int id);
  Future<List<BudgetModel>> getBudgetsForMonth(int month, int year);
  Future<void> saveRecurringTransaction(RecurringTransactionModel model);
  Future<void> deleteRecurringTransaction(int id);
  Future<List<RecurringTransactionModel>> getAllRecurringTransactions();
  Future<void> processRecurringTransactions();
}

class FinanceRepositoryImpl implements FinanceRepository {
  final IsarService _isarService;

  FinanceRepositoryImpl({required IsarService isarService}) : _isarService = isarService;

  @override
  Future<void> saveIncome(IncomeModel income) async {
    return _isarService.saveIncome(income);
  }

  @override
  Future<void> deleteIncome(int id) async {
    return _isarService.deleteIncome(id);
  }

  @override
  Future<List<IncomeModel>> getIncomesForMonth(int month, int year) async {
    return _isarService.getIncomesForMonth(month, year);
  }

  @override
  Future<void> saveExpense(ExpenseModel expense) async {
    return _isarService.saveExpense(expense);
  }

  @override
  Future<void> deleteExpense(int id) async {
    return _isarService.deleteExpense(id);
  }

  @override
  Future<List<ExpenseModel>> getExpensesForMonth(int month, int year) async {
    return _isarService.getExpensesForMonth(month, year);
  }

  @override
  Future<List<ExpenseModel>> getAllExpenses() async {
    return _isarService.getAllExpenses();
  }

  @override
  Future<void> saveBudget(BudgetModel budget) async {
    return _isarService.saveBudget(budget);
  }

  @override
  Future<void> deleteBudget(int id) async {
    return _isarService.deleteBudget(id);
  }

  @override
  Future<List<BudgetModel>> getBudgetsForMonth(int month, int year) async {
    return _isarService.getBudgetsForMonth(month, year);
  }

  @override
  Future<void> saveRecurringTransaction(RecurringTransactionModel model) async {
    return _isarService.saveRecurringTransaction(model);
  }

  @override
  Future<void> deleteRecurringTransaction(int id) async {
    return _isarService.deleteRecurringTransaction(id);
  }

  @override
  Future<List<RecurringTransactionModel>> getAllRecurringTransactions() async {
    return _isarService.getAllRecurringTransactions();
  }

  @override
  Future<void> processRecurringTransactions() async {
    final transactions = await _isarService.getAllRecurringTransactions();
    final now = DateTime.now();

    for (var tx in transactions) {
      if (!tx.isActive) continue;

      bool updated = false;

      while (tx.nextExecutionDate.isBefore(now) || tx.nextExecutionDate.isAtSameMomentAs(now)) {
        if (tx.isIncome) {
          final income = IncomeModel()
            ..amount = tx.amount
            ..month = tx.nextExecutionDate.month
            ..year = tx.nextExecutionDate.year
            ..dateAdded = tx.nextExecutionDate
            ..currency = tx.currency;
          await _isarService.saveIncome(income);
        } else {
          final expense = ExpenseModel()
            ..amount = tx.amount
            ..category = tx.expenseCategory ?? ExpenseCategory.other
            ..description = tx.description
            ..date = tx.nextExecutionDate
            ..currency = tx.currency;
          await _isarService.saveExpense(expense);
        }

        switch (tx.interval) {
          case RecurrenceInterval.daily:
            tx.nextExecutionDate = tx.nextExecutionDate.add(const Duration(days: 1));
            break;
          case RecurrenceInterval.weekly:
            tx.nextExecutionDate = tx.nextExecutionDate.add(const Duration(days: 7));
            break;
          case RecurrenceInterval.biWeekly:
            tx.nextExecutionDate = tx.nextExecutionDate.add(const Duration(days: 14));
            break;
          case RecurrenceInterval.monthly:
            int newMonth = tx.nextExecutionDate.month + 1;
            int newYear = tx.nextExecutionDate.year;
            if (newMonth > 12) {
              newMonth = 1;
              newYear++;
            }
            int newDay = tx.nextExecutionDate.day;
            final daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
            if (newDay > daysInNewMonth) {
              newDay = daysInNewMonth;
            }
            tx.nextExecutionDate = DateTime(newYear, newMonth, newDay, tx.nextExecutionDate.hour, tx.nextExecutionDate.minute);
            break;
          case RecurrenceInterval.yearly:
            tx.nextExecutionDate = DateTime(tx.nextExecutionDate.year + 1, tx.nextExecutionDate.month, tx.nextExecutionDate.day, tx.nextExecutionDate.hour, tx.nextExecutionDate.minute);
            break;
        }
        updated = true;
      }

      if (updated) {
        await _isarService.saveRecurringTransaction(tx);
      }
    }
  }
}
