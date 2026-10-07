import 'package:equatable/equatable.dart';
import 'package:scadar/core/database/models/expense_model.dart';
import 'package:scadar/core/database/models/income_model.dart';
import 'package:scadar/core/database/models/budget_model.dart';
import 'package:scadar/core/database/models/recurring_transaction_model.dart';

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

class AddBudgetEvent extends FinanceEvent {
  final BudgetModel budget;
  
  const AddBudgetEvent(this.budget);
  
  @override
  List<Object?> get props => [budget];
}

class DeleteBudgetEvent extends FinanceEvent {
  final BudgetModel budget;
  
  const DeleteBudgetEvent(this.budget);
  
  @override
  List<Object?> get props => [budget];
}

class AddSubscriptionEvent extends FinanceEvent {
  final RecurringTransactionModel subscription;
  
  const AddSubscriptionEvent(this.subscription);
  
  @override
  List<Object?> get props => [subscription];
}

class UpdateSubscriptionEvent extends FinanceEvent {
  final RecurringTransactionModel subscription;
  
  const UpdateSubscriptionEvent(this.subscription);
  
  @override
  List<Object?> get props => [subscription];
}

class DeleteSubscriptionEvent extends FinanceEvent {
  final RecurringTransactionModel subscription;
  
  const DeleteSubscriptionEvent(this.subscription);
  
  @override
  List<Object?> get props => [subscription];
}
