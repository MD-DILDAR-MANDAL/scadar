import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scadar/core/cache/models/expense_model.dart';
import 'package:scadar/core/cache/models/income_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [IncomeModelSchema, ExpenseModelSchema],
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> saveIncome(IncomeModel income) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.incomeModels.putSync(income));
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
}
