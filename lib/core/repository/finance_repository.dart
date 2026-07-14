import 'package:scadar/core/cache/isar_service.dart';
import 'package:scadar/core/cache/models/expense_model.dart';
import 'package:scadar/core/cache/models/income_model.dart';

abstract class FinanceRepository {
  Future<void> saveIncome(IncomeModel income);
  Future<List<IncomeModel>> getIncomesForMonth(int month, int year);
  Future<void> saveExpense(ExpenseModel expense);
  Future<List<ExpenseModel>> getExpensesForMonth(int month, int year);
}

class FinanceRepositoryImpl implements FinanceRepository {
  final IsarService _isarService;

  FinanceRepositoryImpl({required IsarService isarService}) : _isarService = isarService;

  @override
  Future<void> saveIncome(IncomeModel income) async {
    return _isarService.saveIncome(income);
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
  Future<List<ExpenseModel>> getExpensesForMonth(int month, int year) async {
    return _isarService.getExpensesForMonth(month, year);
  }
}
