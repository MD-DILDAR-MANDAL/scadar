import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scadar/core/cache/models/budget_model.dart';
import 'package:scadar/core/cache/models/expense_model.dart';
import 'package:scadar/core/constant/app_colors.dart';
import 'package:scadar/features/home/bloc/finance_bloc.dart';
import 'package:scadar/features/home/bloc/finance_event.dart';
import 'package:scadar/features/home/bloc/currency_cubit.dart';

class AddBudgetDialog extends StatefulWidget {
  final DateTime selectedDate;
  
  const AddBudgetDialog({super.key, required this.selectedDate});

  @override
  State<AddBudgetDialog> createState() => _AddBudgetDialogState();
}

class _AddBudgetDialogState extends State<AddBudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  ExpenseCategory? _selectedCategory; // null means 'Overall'

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _saveBudget() {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      if (amount <= 0) return;

      final currencyState = context.read<CurrencyCubit>().state;
      String currency = 'USD';
      if (currencyState is CurrencyLoaded) {
        currency = currencyState.globalCurrency;
      }

      final budget = BudgetModel()
        ..limit = amount
        ..category = _selectedCategory
        ..month = widget.selectedDate.month
        ..year = widget.selectedDate.year
        ..currency = currency;

      context.read<FinanceBloc>().add(AddBudgetEvent(budget));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Monthly Budget', style: TextStyle(color: AppColors.primary)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<ExpenseCategory?>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<ExpenseCategory?>(
                  value: null,
                  child: Text('Overall Budget'),
                ),
                ...ExpenseCategory.values.map(
                  (cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat.name.toUpperCase()),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Budget Limit',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.money),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter an amount';
                if (double.tryParse(value) == null) return 'Please enter a valid number';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: AppColors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: _saveBudget,
          child: const Text('Save', style: TextStyle(color: AppColors.white)),
        ),
      ],
    );
  }
}
