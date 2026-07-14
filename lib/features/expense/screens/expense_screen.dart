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
    return Scaffold(
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
    );
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
                '${expenses.fold<double>(0, (sum, item) => sum + item.amount).toStringAsFixed(2)} $baseCurrency',
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
                      '${exp.amount.toStringAsFixed(2)} ${exp.currency}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
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
}
