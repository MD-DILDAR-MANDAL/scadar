import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scadar/core/database/models/expense_model.dart';
import 'package:scadar/core/database/models/income_model.dart';
import 'package:scadar/core/database/models/exchange_rate_cache_model.dart';
import 'package:scadar/core/database/models/budget_model.dart';
import 'package:scadar/core/database/models/recurring_transaction_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [IncomeModelSchema, ExpenseModelSchema, ExchangeRateCacheModelSchema, BudgetModelSchema, RecurringTransactionModelSchema],
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> saveIncome(IncomeModel income) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.incomeModels.putSync(income));
  }

  Future<void> deleteIncome(int id) async {
    final isar = await db;
    isar.writeTxnSync<bool>(() => isar.incomeModels.deleteSync(id));
  }

  Future<List<IncomeModel>> getIncomesForMonth(int month, int year) async {
    final isar = await db;
    return await isar.incomeModels
        .filter()
        .monthEqualTo(month)
        .and()
        .yearEqualTo(year)
        .findAll();
  }

  Future<void> saveExpense(ExpenseModel expense) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.expenseModels.putSync(expense));
  }

  Future<void> deleteExpense(int id) async {
    final isar = await db;
    isar.writeTxnSync<bool>(() => isar.expenseModels.deleteSync(id));
  }

  Future<List<ExpenseModel>> getExpensesForMonth(int month, int year) async {
    final isar = await db;
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59);

    return await isar.expenseModels
        .filter()
        .dateBetween(startDate, endDate)
        .findAll();
  }

  Future<List<ExpenseModel>> getAllExpenses() async {
    final isar = await db;
    return await isar.expenseModels.where().findAll();
  }

  Future<List<IncomeModel>> getAllIncomes() async {
    final isar = await db;
    return await isar.incomeModels.where().findAll();
  }

  Future<ExchangeRateCacheModel?> getExchangeRateCache(String baseCurrency) async {
    final isar = await db;
    return await isar.exchangeRateCacheModels
        .filter()
        .baseCurrencyEqualTo(baseCurrency)
        .findFirst();
  }

  Future<void> saveExchangeRateCache(ExchangeRateCacheModel cache) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.exchangeRateCacheModels.putSync(cache));
  }

  Future<void> saveBudget(BudgetModel budget) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.budgetModels.putSync(budget));
  }

  Future<void> deleteBudget(int id) async {
    final isar = await db;
    isar.writeTxnSync<bool>(() => isar.budgetModels.deleteSync(id));
  }

  Future<List<BudgetModel>> getBudgetsForMonth(int month, int year) async {
    final isar = await db;
    return await isar.budgetModels
        .filter()
        .monthEqualTo(month)
        .and()
        .yearEqualTo(year)
        .findAll();
  }

  Future<void> saveRecurringTransaction(RecurringTransactionModel model) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.recurringTransactionModels.putSync(model));
  }

  Future<void> deleteRecurringTransaction(int id) async {
    final isar = await db;
    isar.writeTxnSync<bool>(() => isar.recurringTransactionModels.deleteSync(id));
  }

  Future<List<RecurringTransactionModel>> getAllRecurringTransactions() async {
    final isar = await db;
    return await isar.recurringTransactionModels.where().findAll();
  }

  Future<List<BudgetModel>> getAllBudgets() async {
    final isar = await db;
    return await isar.budgetModels.where().findAll();
  }

  Future<void> clearAndRestoreAllData({
    required List<ExpenseModel> expenses,
    required List<IncomeModel> incomes,
    required List<BudgetModel> budgets,
    required List<RecurringTransactionModel> recurring,
  }) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.expenseModels.clear();
      await isar.incomeModels.clear();
      await isar.budgetModels.clear();
      await isar.recurringTransactionModels.clear();

      await isar.expenseModels.putAll(expenses);
      await isar.incomeModels.putAll(incomes);
      await isar.budgetModels.putAll(budgets);
      await isar.recurringTransactionModels.putAll(recurring);
    });
  }
}
