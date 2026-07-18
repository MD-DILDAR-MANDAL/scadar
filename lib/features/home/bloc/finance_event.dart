import 'package:equatable/equatable.dart';
import 'package:scadar/core/cache/models/expense_model.dart';
import 'package:scadar/core/cache/models/income_model.dart';

abstract class FinanceEvent extends Equatable {
  const FinanceEvent();

  @override
  List<Object?> get props => [];
}

class LoadFinanceData extends FinanceEvent {
  final int month;
  final int year;

  const LoadFinanceData({required this.month, required this.year});

  @override
  List<Object?> get props => [month, year];
}

class AddIncomeEvent extends FinanceEvent {
  final IncomeModel income;
  
  const AddIncomeEvent(this.income);
  
  @override
  List<Object?> get props => [income];
}

class UpdateIncomeEvent extends FinanceEvent {
  final IncomeModel income;
  
  const UpdateIncomeEvent(this.income);
  
  @override
  List<Object?> get props => [income];
}

class DeleteIncomeEvent extends FinanceEvent {
  final IncomeModel income;
  
  const DeleteIncomeEvent(this.income);
  
  @override
  List<Object?> get props => [income];
}

class AddExpenseEvent extends FinanceEvent {
  final ExpenseModel expense;
  
  const AddExpenseEvent(this.expense);
  
  @override
  List<Object?> get props => [expense];
}

class UpdateExpenseEvent extends FinanceEvent {
  final ExpenseModel expense;
  
  const UpdateExpenseEvent(this.expense);
  
  @override
  List<Object?> get props => [expense];
}

class DeleteExpenseEvent extends FinanceEvent {
  final ExpenseModel expense;
  
  const DeleteExpenseEvent(this.expense);
  
  @override
  List<Object?> get props => [expense];
}
