import 'package:scadar/core/cache/isar_service.dart';
import 'package:scadar/core/cache/models/expense_model.dart';
import 'package:scadar/core/cache/models/income_model.dart';

abstract class FinanceRepository {
  Future<void> saveIncome(IncomeModel income);
  Future<void> deleteIncome(int id);
  Future<List<IncomeModel>> getIncomesForMonth(int month, int year);
  Future<void> saveExpense(ExpenseModel expense);
  Future<void> deleteExpense(int id);
  Future<List<ExpenseModel>> getExpensesForMonth(int month, int year);
  Future<List<ExpenseModel>> getAllExpenses();
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
}
