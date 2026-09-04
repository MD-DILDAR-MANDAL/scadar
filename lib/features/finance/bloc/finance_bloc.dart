import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scadar/core/database/models/expense_model.dart';
import 'package:scadar/core/repositories/finance_repository.dart';
import 'package:scadar/features/currency/bloc/currency_bloc.dart';
import 'package:scadar/features/currency/bloc/currency_state.dart';
import 'package:scadar/features/finance/bloc/finance_event.dart';
import 'package:scadar/features/finance/bloc/finance_state.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  final FinanceRepository _financeRepository;
  final CurrencyBloc _currencyBloc;
  late final StreamSubscription<CurrencyState> _currencySubscription;

  FinanceBloc({
    required FinanceRepository financeRepository,
    required CurrencyBloc currencyBloc,
  })  : _financeRepository = financeRepository,
        _currencyBloc = currencyBloc,
        super(FinanceInitial()) {
    on<LoadFinanceData>(_onLoadFinanceData);
    on<AddIncomeEvent>(_onAddIncome);
    on<UpdateIncomeEvent>(_onUpdateIncome);
    on<DeleteIncomeEvent>(_onDeleteIncome);
    on<AddExpenseEvent>(_onAddExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
    on<AddBudgetEvent>(_onAddBudget);
    on<DeleteBudgetEvent>(_onDeleteBudget);
    on<AddSubscriptionEvent>(_onAddSubscription);
    on<UpdateSubscriptionEvent>(_onUpdateSubscription);
    on<DeleteSubscriptionEvent>(_onDeleteSubscription);

    _currencySubscription = _currencyBloc.stream.listen((state) {
      if (state is CurrencyLoaded) {
        final now = DateTime.now();
        add(LoadFinanceData(month: now.month, year: now.year));
      }
    });
  }

  @override
  Future<void> close() {
    _currencySubscription.cancel();
    return super.close();
  }

  double _convertAmount(double amount, String fromCurrency, String globalCurrency, Map<String, double> rates) {
    if (fromCurrency == globalCurrency) return amount;
    if (rates.containsKey(fromCurrency)) {
      return amount / rates[fromCurrency]!;
    }
    return amount; // Fallback
  }

  Future<void> _onLoadFinanceData(
    LoadFinanceData event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    try {
      await _financeRepository.processRecurringTransactions();

      final incomes = await _financeRepository.getIncomesForMonth(event.month, event.year);
      final expenses = await _financeRepository.getExpensesForMonth(event.month, event.year);
      final budgets = await _financeRepository.getBudgetsForMonth(event.month, event.year);
      final subscriptions = await _financeRepository.getAllRecurringTransactions();
      
      // Fetch all expenses for the current year to build the monthly graph
      final allExpenses = await _financeRepository.getAllExpenses();
      final yearExpenses = allExpenses.where((e) => e.date.year == event.year).toList();

      String globalCurrency = 'USD';
      Map<String, double> rates = {};

      if (_currencyBloc.state is CurrencyLoaded) {
        final currencyState = _currencyBloc.state as CurrencyLoaded;
        globalCurrency = currencyState.globalCurrency;
        rates = currencyState.ratesMap;
      }

      final monthlyExpenses = <int, double>{};
      final yearlyCategoryExpenses = <ExpenseCategory, Map<int, double>>{};
      
      for (int i = 1; i <= 12; i++) {
        monthlyExpenses[i] = 0.0;
        for (var cat in ExpenseCategory.values) {
          yearlyCategoryExpenses.putIfAbsent(cat, () => {})[i] = 0.0;
        }
      }
      for (var exp in yearExpenses) {
        final month = exp.date.month;
        final converted = _convertAmount(exp.amount, exp.currency, globalCurrency, rates);
        monthlyExpenses[month] = (monthlyExpenses[month] ?? 0) + converted;
        yearlyCategoryExpenses[exp.category]![month] = (yearlyCategoryExpenses[exp.category]![month] ?? 0) + converted;
      }

      double totalIncome = 0;
      for (var inc in incomes) {
        totalIncome += _convertAmount(inc.amount, inc.currency, globalCurrency, rates);
      }

      double totalExpense = 0;
      for (var exp in expenses) {
        totalExpense += _convertAmount(exp.amount, exp.currency, globalCurrency, rates);
      }

      final totalBalance = totalIncome - totalExpense;

      emit(FinanceLoaded(
        incomes: incomes,
        expenses: expenses,
        allExpenses: allExpenses,
        budgets: budgets,
        subscriptions: subscriptions,
        monthlyExpenses: monthlyExpenses,
        yearlyCategoryExpenses: yearlyCategoryExpenses,
        totalBalance: totalBalance,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        baseCurrency: globalCurrency,
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

  Future<void> _onUpdateIncome(
    UpdateIncomeEvent event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _financeRepository.saveIncome(event.income);
      add(LoadFinanceData(month: event.income.month, year: event.income.year));
    } catch (e) {
      emit(FinanceError('Failed to update income: $e'));
    }
  }

  Future<void> _onDeleteIncome(
    DeleteIncomeEvent event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _financeRepository.deleteIncome(event.income.id);
      add(LoadFinanceData(month: event.income.month, year: event.income.year));
    } catch (e) {
      emit(FinanceError('Failed to delete income: $e'));
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

  Future<void> _onUpdateExpense(
    UpdateExpenseEvent event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _financeRepository.saveExpense(event.expense);
      add(LoadFinanceData(month: event.expense.date.month, year: event.expense.date.year));
    } catch (e) {
      emit(FinanceError('Failed to update expense: $e'));
    }
  }

  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _financeRepository.deleteExpense(event.expense.id);
      add(LoadFinanceData(month: event.expense.date.month, year: event.expense.date.year));
    } catch (e) {
      emit(FinanceError('Failed to delete expense: $e'));
    }
  }

  Future<void> _onAddBudget(
    AddBudgetEvent event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      // Handle overwrite: delete any existing budget for the same category/month
      if (state is FinanceLoaded) {
        final loadedState = state as FinanceLoaded;
        final existing = loadedState.budgets.where((b) => b.category == event.budget.category);
        for (var b in existing) {
          await _financeRepository.deleteBudget(b.id);
        }
      }
      await _financeRepository.saveBudget(event.budget);
      add(LoadFinanceData(month: event.budget.month, year: event.budget.year));
    } catch (e) {
      emit(FinanceError('Failed to add budget: $e'));
    }
  }

  Future<void> _onDeleteBudget(
    DeleteBudgetEvent event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _financeRepository.deleteBudget(event.budget.id);
      add(LoadFinanceData(month: event.budget.month, year: event.budget.year));
    } catch (e) {
      emit(FinanceError('Failed to delete budget: $e'));
    }
  }

  Future<void> _onAddSubscription(
    AddSubscriptionEvent event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _financeRepository.saveRecurringTransaction(event.subscription);
      final now = DateTime.now();
      add(LoadFinanceData(month: now.month, year: now.year));
    } catch (e) {
      emit(FinanceError('Failed to add subscription: $e'));
    }
  }

  Future<void> _onUpdateSubscription(
    UpdateSubscriptionEvent event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _financeRepository.saveRecurringTransaction(event.subscription);
      final now = DateTime.now();
      add(LoadFinanceData(month: now.month, year: now.year));
    } catch (e) {
      emit(FinanceError('Failed to update subscription: $e'));
    }
  }

  Future<void> _onDeleteSubscription(
    DeleteSubscriptionEvent event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _financeRepository.deleteRecurringTransaction(event.subscription.id);
      final now = DateTime.now();
      add(LoadFinanceData(month: now.month, year: now.year));
    } catch (e) {
      emit(FinanceError('Failed to delete subscription: $e'));
    }
  }
}
