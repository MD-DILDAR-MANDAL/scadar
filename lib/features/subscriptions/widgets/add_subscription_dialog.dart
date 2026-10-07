import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scadar/core/constants/app_colors.dart';
import 'package:scadar/core/database/models/expense_model.dart';
import 'package:scadar/core/database/models/recurring_transaction_model.dart';
import 'package:scadar/features/currency/bloc/currency_bloc.dart';
import 'package:scadar/features/currency/bloc/currency_state.dart';
import 'package:scadar/features/finance/bloc/finance_bloc.dart';
import 'package:scadar/features/finance/bloc/finance_event.dart';

class AddSubscriptionDialog extends StatefulWidget {
  const AddSubscriptionDialog({super.key});

  @override
  State<AddSubscriptionDialog> createState() => _AddSubscriptionDialogState();
}

class _AddSubscriptionDialogState extends State<AddSubscriptionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descController = TextEditingController();

  bool _isIncome = false;
  ExpenseCategory? _selectedCategory;
  RecurrenceInterval _interval = RecurrenceInterval.monthly;
  DateTime _nextExecutionDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      if (amount <= 0) return;

      final currencyState = context.read<CurrencyBloc>().state;
      String currency = 'USD';
      if (currencyState is CurrencyLoaded) {
        currency = currencyState.globalCurrency;
      }

      final subscription = RecurringTransactionModel()
        ..amount = amount
        ..isIncome = _isIncome
        ..expenseCategory = _isIncome ? null : _selectedCategory
        ..description = _descController.text
        ..currency = currency
        ..interval = _interval
        ..nextExecutionDate = _nextExecutionDate
        ..isActive = true;

      context.read<FinanceBloc>().add(AddSubscriptionEvent(subscription));
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextExecutionDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _nextExecutionDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Subscription', style: TextStyle(color: AppColors.primary)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Is Income?'),
                value: _isIncome,
                activeThumbColor: AppColors.primary,
                onChanged: (val) {
                  setState(() {
                    _isIncome = val;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description (e.g. Netflix)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              if (!_isIncome) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<ExpenseCategory>(
                  value: _selectedCategory, // ignore: deprecated_member_use
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: ExpenseCategory.values.map(
                    (cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat.name.toUpperCase()),
                    ),
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) => value == null ? 'Required' : null,
                ),
              ],
              const SizedBox(height: 16),
              DropdownButtonFormField<RecurrenceInterval>(
                value: _interval, // ignore: deprecated_member_use
                decoration: const InputDecoration(
                  labelText: 'Interval',
                  border: OutlineInputBorder(),
                ),
                items: RecurrenceInterval.values.map(
                  (i) => DropdownMenuItem(
                    value: i,
                    child: Text(i.name.toUpperCase()),
                  ),
                ).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _interval = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Next Execution Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(DateFormat.yMMMd().format(_nextExecutionDate)),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: AppColors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: _save,
          child: const Text('Save', style: TextStyle(color: AppColors.white)),
        ),
      ],
    );
  }
}
