import 'package:equatable/equatable.dart';
import 'package:scadar/core/cache/models/expense_model.dart';
import 'package:scadar/core/cache/models/income_model.dart';

abstract class FinanceState extends Equatable {
  const FinanceState();
  
  @override
  List<Object?> get props => [];
}

class FinanceInitial extends FinanceState {}

class FinanceLoading extends FinanceState {}

class FinanceLoaded extends FinanceState {
  final List<IncomeModel> incomes;
  final List<ExpenseModel> expenses;
  final List<ExpenseModel> allExpenses;
  final Map<int, double> monthlyExpenses;
  final Map<ExpenseCategory, Map<int, double>> yearlyCategoryExpenses;
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final String baseCurrency;

  const FinanceLoaded({
    required this.incomes,
    required this.expenses,
    required this.allExpenses,
    required this.monthlyExpenses,
    required this.yearlyCategoryExpenses,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.baseCurrency,
  });

  @override
  List<Object?> get props => [
        incomes,
        expenses,
        allExpenses,
        monthlyExpenses,
        yearlyCategoryExpenses,
        totalBalance,
        totalIncome,
        totalExpense,
        baseCurrency,
      ];
}

class FinanceError extends FinanceState {
  final String message;

  const FinanceError(this.message);

  @override
  List<Object?> get props => [message];
}
