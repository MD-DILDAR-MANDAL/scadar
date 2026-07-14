import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scadar/core/repository/finance_repository.dart';
import 'package:scadar/features/home/bloc/finance_event.dart';
import 'package:scadar/features/home/bloc/finance_state.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  final FinanceRepository _financeRepository;

  FinanceBloc({required FinanceRepository financeRepository})
      : _financeRepository = financeRepository,
        super(FinanceInitial()) {
    on<LoadFinanceData>(_onLoadFinanceData);
    on<AddIncomeEvent>(_onAddIncome);
    on<AddExpenseEvent>(_onAddExpense);
  }

  Future<void> _onLoadFinanceData(
    LoadFinanceData event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    try {
      final incomes = await _financeRepository.getIncomesForMonth(event.month, event.year);
      final expenses = await _financeRepository.getExpensesForMonth(event.month, event.year);

      double totalIncome = 0;
      for (var inc in incomes) {
        totalIncome += inc.amount;
      }

      double totalExpense = 0;
      for (var exp in expenses) {
        totalExpense += exp.amount;
      }

      final totalBalance = totalIncome - totalExpense;

      String baseCurrency = 'USD';
      if (incomes.isNotEmpty) {
        baseCurrency = incomes.first.currency;
      } else if (expenses.isNotEmpty) {
        baseCurrency = expenses.first.currency;
      }

      emit(FinanceLoaded(
        incomes: incomes,
        expenses: expenses,
        totalBalance: totalBalance,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        baseCurrency: baseCurrency,
      ));
    } catch (e) {
      emit(FinanceError(e.toString()));
    }
  }

  Future<void> _onAddIncome(
    AddIncomeEvent event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _financeRepository.saveIncome(event.income);
      add(LoadFinanceData(month: event.income.month, year: event.income.year));
    } catch (e) {
      emit(FinanceError('Failed to add income: $e'));
    }
  }

  Future<void> _onAddExpense(
    AddExpenseEvent event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _financeRepository.saveExpense(event.expense);
      add(LoadFinanceData(month: event.expense.date.month, year: event.expense.date.year));
    } catch (e) {
      emit(FinanceError('Failed to add expense: $e'));
    }
  }
}
