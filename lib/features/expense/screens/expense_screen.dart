import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scadar/core/cache/models/expense_model.dart';
import 'package:scadar/core/constant/app_colors.dart';
import 'package:scadar/core/presentation/widgets/custom_button.dart';
import 'package:scadar/core/presentation/widgets/custom_dropdown.dart';
import 'package:scadar/core/presentation/widgets/custom_text_field.dart';
import 'package:scadar/core/presentation/widgets/custom_card.dart';
import 'package:scadar/core/presentation/widgets/section_title.dart';
import 'package:scadar/features/home/bloc/finance_bloc.dart';
import 'package:scadar/features/home/bloc/finance_event.dart';
import 'package:scadar/features/home/bloc/finance_state.dart';
import 'package:scadar/features/home/bloc/currency_cubit.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  ExpenseCategory _selectedCategory = ExpenseCategory.housing;
  String _currency = 'USD';
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final currencyState = context.read<CurrencyCubit>().state;
      if (currencyState is CurrencyLoaded) {
        _currency = currencyState.globalCurrency;
        _isInit = true;
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _addExpense() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) return;

    final expense = ExpenseModel()
      ..amount = amount
      ..category = _selectedCategory
      ..description = _descController.text
      ..currency = _currency
      ..date = DateTime.now();

    context.read<FinanceBloc>().add(AddExpenseEvent(expense));
    
    _amountController.clear();
    _descController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Expense Added!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrencyCubit, CurrencyState>(
      listener: (context, state) {
        if (state is CurrencyLoaded && !_isInit) {
          setState(() {
            _currency = state.globalCurrency;
            _isInit = true;
          });
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Add Expense Card
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle('Add New Expense'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          hintText: 'Amount',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: CustomDropdown<String>(
                          value: _currency,
                          items: const ['USD', 'EUR', 'GBP', 'INR', 'JPY', 'CAD', 'AUD'],
                          onChanged: (val) {
                            if (val != null) setState(() => _currency = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CustomDropdown<ExpenseCategory>(
                    value: _selectedCategory,
                    items: ExpenseCategory.values,
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                    displayText: (cat) => cat.name.toUpperCase(),
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _descController,
                    hintText: 'Description',
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    onPressed: _addExpense,
                    text: 'Add Expense',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Expenses List Card
            const SectionTitle('Expenses per categories'),
            const SizedBox(height: 12),
            BlocBuilder<FinanceBloc, FinanceState>(
              builder: (context, state) {
                if (state is FinanceLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FinanceLoaded) {
                  final expenses = state.expenses;
                  if (expenses.isEmpty) {
                    return const Text('No expenses recorded for this month.', style: TextStyle(color: AppColors.primary));
                  }
                  
                  // Group expenses by category
                  final Map<ExpenseCategory, List<ExpenseModel>> grouped = {};
                  for (var exp in expenses) {
                    grouped.putIfAbsent(exp.category, () => []).add(exp);
                  }

                  return Column(
                    children: grouped.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildCategoryCard(entry.key.name.toUpperCase(), entry.value, state.baseCurrency),
                      );
                    }).toList(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 100), // Bottom padding for navbar
          ],
        ),
      ),
    ));
  }


  double _getConvertedAmount(double amount, String currency) {
    final currencyCubit = context.read<CurrencyCubit>();
    if (currencyCubit.state is CurrencyLoaded) {
      final state = currencyCubit.state as CurrencyLoaded;
      if (currency == state.globalCurrency) return amount;
      if (state.ratesMap.containsKey(currency)) {
        return amount / state.ratesMap[currency]!;
      }
    }
    return amount;
  }

  Widget _buildCategoryCard(String title, List<ExpenseModel> expenses, String baseCurrency) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SectionTitle(title),
              Text(
                '${expenses.fold<double>(0, (sum, item) => sum + _getConvertedAmount(item.amount, item.currency)).toStringAsFixed(2)} $baseCurrency',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final exp = expenses[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        exp.description.isEmpty ? 'Unknown' : exp.description,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${_getConvertedAmount(exp.amount, exp.currency).toStringAsFixed(2)} $baseCurrency',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20, color: AppColors.primary),
                          onPressed: () => _showEditDialog(context, exp),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                          onPressed: () => _confirmDelete(context, exp),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, ExpenseModel expense) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<FinanceBloc>().add(DeleteExpenseEvent(expense));
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, ExpenseModel expense) {
    final editAmountController = TextEditingController(text: expense.amount.toString());
    final editDescController = TextEditingController(text: expense.description);
    ExpenseCategory editCategory = expense.category;
    String editCurrency = expense.currency;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SectionTitle('Edit Expense'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          controller: editAmountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          hintText: 'Amount',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: CustomDropdown<String>(
                          value: editCurrency,
                          items: const ['USD', 'EUR', 'GBP', 'INR', 'JPY', 'CAD', 'AUD'],
                          onChanged: (val) {
                            if (val != null) setModalState(() => editCurrency = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CustomDropdown<ExpenseCategory>(
                    value: editCategory,
                    items: ExpenseCategory.values,
                    onChanged: (val) {
                      if (val != null) setModalState(() => editCategory = val);
                    },
                    displayText: (cat) => cat.name.toUpperCase(),
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: editDescController,
                    hintText: 'Description',
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    onPressed: () {
                      final amount = double.tryParse(editAmountController.text);
                      if (amount != null) {
                        final updatedExpense = ExpenseModel()
                          ..id = expense.id
                          ..amount = amount
                          ..category = editCategory
                          ..description = editDescController.text
                          ..currency = editCurrency
                          ..date = expense.date;

                        context.read<FinanceBloc>().add(UpdateExpenseEvent(updatedExpense));
                        Navigator.pop(ctx);
                      }
                    },
                    text: 'Save Changes',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

