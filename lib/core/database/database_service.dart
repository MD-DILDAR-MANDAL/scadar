import 'package:drift/drift.dart';
import 'package:scadar/core/database/app_database.dart';
import 'package:scadar/core/database/models/budget_model.dart';
import 'package:scadar/core/database/models/exchange_rate_cache_model.dart';
import 'package:scadar/core/database/models/expense_model.dart';
import 'package:scadar/core/database/models/income_model.dart';
import 'package:scadar/core/database/models/recurring_transaction_model.dart';

class DatabaseService {
  final AppDatabase _db;

  DatabaseService({AppDatabase? db}) : _db = db ?? AppDatabase();

  AppDatabase get db => _db;

  Future<void> openDB() async {
    // Database initialization is handled lazily by Drift.
  }

  // --- Expenses ---

  ExpenseModel _toExpenseModel(ExpenseEntry entry) {
    return ExpenseModel()
      ..id = entry.id
      ..amount = entry.amount
      ..category = ExpenseCategory.values.firstWhere(
        (e) => e.name == entry.category,
        orElse: () => ExpenseCategory.other,
      )
      ..date = entry.date
      ..description = entry.description
      ..currency = entry.currency;
  }

  ExpensesCompanion _toExpenseCompanion(ExpenseModel model) {
    return ExpensesCompanion(
      id: model.id > 0 ? Value(model.id) : const Value.absent(),
      amount: Value(model.amount),
      category: Value(model.category.name),
      date: Value(model.date),
      description: Value(model.description),
      currency: Value(model.currency),
    );
  }

  Future<void> saveExpense(ExpenseModel expense) async {
    final companion = _toExpenseCompanion(expense);
    if (expense.id > 0) {
      final updated = await (_db.update(_db.expenses)
            ..where((t) => t.id.equals(expense.id)))
          .write(companion);
      if (updated == 0) {
        final id = await _db.into(_db.expenses).insert(companion);
        expense.id = id;
      }
    } else {
      final id = await _db.into(_db.expenses).insert(companion);
      expense.id = id;
    }
  }

  Future<void> deleteExpense(int id) async {
    await (_db.delete(_db.expenses)..where((t) => t.id.equals(id))).go();
  }

  Future<List<ExpenseModel>> getExpensesForMonth(int month, int year) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59);

    final query = _db.select(_db.expenses)
      ..where((t) => t.date.isBiggerOrEqualValue(startDate) & t.date.isSmallerOrEqualValue(endDate));
    final entries = await query.get();
    return entries.map(_toExpenseModel).toList();
  }

  Future<List<ExpenseModel>> getAllExpenses() async {
    final entries = await _db.select(_db.expenses).get();
    return entries.map(_toExpenseModel).toList();
  }

  // --- Incomes ---

  IncomeModel _toIncomeModel(IncomeEntry entry) {
    return IncomeModel()
      ..id = entry.id
      ..amount = entry.amount
      ..month = entry.month
      ..year = entry.year
      ..currency = entry.currency
      ..dateAdded = entry.dateAdded;
  }

  IncomesCompanion _toIncomeCompanion(IncomeModel model) {
    return IncomesCompanion(
      id: model.id > 0 ? Value(model.id) : const Value.absent(),
      amount: Value(model.amount),
      month: Value(model.month),
      year: Value(model.year),
      currency: Value(model.currency),
      dateAdded: Value(model.dateAdded),
    );
  }

  Future<void> saveIncome(IncomeModel income) async {
    final companion = _toIncomeCompanion(income);
    if (income.id > 0) {
      final updated = await (_db.update(_db.incomes)
            ..where((t) => t.id.equals(income.id)))
          .write(companion);
      if (updated == 0) {
        final id = await _db.into(_db.incomes).insert(companion);
        income.id = id;
      }
    } else {
      final id = await _db.into(_db.incomes).insert(companion);
      income.id = id;
    }
  }

  Future<void> deleteIncome(int id) async {
    await (_db.delete(_db.incomes)..where((t) => t.id.equals(id))).go();
  }

  Future<List<IncomeModel>> getIncomesForMonth(int month, int year) async {
    final query = _db.select(_db.incomes)
      ..where((t) => t.month.equals(month) & t.year.equals(year));
    final entries = await query.get();
    return entries.map(_toIncomeModel).toList();
  }

  Future<List<IncomeModel>> getAllIncomes() async {
    final entries = await _db.select(_db.incomes).get();
    return entries.map(_toIncomeModel).toList();
  }

  // --- Budgets ---

  BudgetModel _toBudgetModel(BudgetEntry entry) {
    return BudgetModel()
      ..id = entry.id
      ..limit = entry.limitAmount
      ..categoryName = entry.categoryName
      ..month = entry.month
      ..year = entry.year
      ..currency = entry.currency;
  }

  BudgetsCompanion _toBudgetCompanion(BudgetModel model) {
    return BudgetsCompanion(
      id: model.id > 0 ? Value(model.id) : const Value.absent(),
      limitAmount: Value(model.limit),
      categoryName: Value(model.categoryName),
      month: Value(model.month),
      year: Value(model.year),
      currency: Value(model.currency),
    );
  }

  Future<void> saveBudget(BudgetModel budget) async {
    final companion = _toBudgetCompanion(budget);
    if (budget.id > 0) {
      final updated = await (_db.update(_db.budgets)
            ..where((t) => t.id.equals(budget.id)))
          .write(companion);
      if (updated == 0) {
        final id = await _db.into(_db.budgets).insert(companion);
        budget.id = id;
      }
    } else {
      final id = await _db.into(_db.budgets).insert(companion);
      budget.id = id;
    }
  }

  Future<void> deleteBudget(int id) async {
    await (_db.delete(_db.budgets)..where((t) => t.id.equals(id))).go();
  }

  Future<List<BudgetModel>> getBudgetsForMonth(int month, int year) async {
    final query = _db.select(_db.budgets)
      ..where((t) => t.month.equals(month) & t.year.equals(year));
    final entries = await query.get();
    return entries.map(_toBudgetModel).toList();
  }

  Future<List<BudgetModel>> getAllBudgets() async {
    final entries = await _db.select(_db.budgets).get();
    return entries.map(_toBudgetModel).toList();
  }

  // --- Recurring Transactions ---

  RecurringTransactionModel _toRecurringModel(RecurringTransactionEntry entry) {
    return RecurringTransactionModel()
      ..id = entry.id
      ..amount = entry.amount
      ..isIncome = entry.isIncome
      ..expenseCategoryName = entry.expenseCategoryName
      ..description = entry.description
      ..currency = entry.currency
      ..interval = RecurrenceInterval.values.firstWhere(
        (e) => e.name == entry.interval,
        orElse: () => RecurrenceInterval.monthly,
      )
      ..nextExecutionDate = entry.nextExecutionDate
      ..isActive = entry.isActive;
  }

  RecurringTransactionsCompanion _toRecurringCompanion(RecurringTransactionModel model) {
    return RecurringTransactionsCompanion(
      id: model.id > 0 ? Value(model.id) : const Value.absent(),
      amount: Value(model.amount),
      isIncome: Value(model.isIncome),
      expenseCategoryName: Value(model.expenseCategoryName),
      description: Value(model.description),
      currency: Value(model.currency),
      interval: Value(model.interval.name),
      nextExecutionDate: Value(model.nextExecutionDate),
      isActive: Value(model.isActive),
    );
  }

  Future<void> saveRecurringTransaction(RecurringTransactionModel model) async {
    final companion = _toRecurringCompanion(model);
    if (model.id > 0) {
      final updated = await (_db.update(_db.recurringTransactions)
            ..where((t) => t.id.equals(model.id)))
          .write(companion);
      if (updated == 0) {
        final id = await _db.into(_db.recurringTransactions).insert(companion);
        model.id = id;
      }
    } else {
      final id = await _db.into(_db.recurringTransactions).insert(companion);
      model.id = id;
    }
  }

  Future<void> deleteRecurringTransaction(int id) async {
    await (_db.delete(_db.recurringTransactions)..where((t) => t.id.equals(id))).go();
  }

  Future<List<RecurringTransactionModel>> getAllRecurringTransactions() async {
    final entries = await _db.select(_db.recurringTransactions).get();
    return entries.map(_toRecurringModel).toList();
  }

  // --- Exchange Rate Cache ---

  ExchangeRateCacheModel _toExchangeRateCacheModel(ExchangeRateCacheEntry entry) {
    return ExchangeRateCacheModel()
      ..id = entry.id
      ..baseCurrency = entry.baseCurrency
      ..ratesJson = entry.ratesJson
      ..lastUpdated = entry.lastUpdated;
  }

  Future<ExchangeRateCacheModel?> getExchangeRateCache(String baseCurrency) async {
    final query = _db.select(_db.exchangeRateCaches)
      ..where((t) => t.baseCurrency.equals(baseCurrency));
    final entry = await query.getSingleOrNull();
    return entry != null ? _toExchangeRateCacheModel(entry) : null;
  }

  Future<void> saveExchangeRateCache(ExchangeRateCacheModel cache) async {
    final companion = ExchangeRateCachesCompanion(
      id: cache.id > 0 ? Value(cache.id) : const Value.absent(),
      baseCurrency: Value(cache.baseCurrency),
      ratesJson: Value(cache.ratesJson),
      lastUpdated: Value(cache.lastUpdated),
    );
    await _db.into(_db.exchangeRateCaches).insertOnConflictUpdate(companion);
  }

  // --- Restore ---

  Future<void> clearAndRestoreAllData({
    required List<ExpenseModel> expenses,
    required List<IncomeModel> incomes,
    required List<BudgetModel> budgets,
    required List<RecurringTransactionModel> recurring,
  }) async {
    await _db.transaction(() async {
      await _db.delete(_db.expenses).go();
      await _db.delete(_db.incomes).go();
      await _db.delete(_db.budgets).go();
      await _db.delete(_db.recurringTransactions).go();

      for (final exp in expenses) {
        await _db.into(_db.expenses).insert(_toExpenseCompanion(exp));
      }
      for (final inc in incomes) {
        await _db.into(_db.incomes).insert(_toIncomeCompanion(inc));
      }
      for (final b in budgets) {
        await _db.into(_db.budgets).insert(_toBudgetCompanion(b));
      }
      for (final r in recurring) {
        await _db.into(_db.recurringTransactions).insert(_toRecurringCompanion(r));
      }
    });
  }
}

