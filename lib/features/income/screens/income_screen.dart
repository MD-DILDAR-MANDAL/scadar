import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scadar/core/cache/models/income_model.dart';
import 'package:scadar/core/constant/app_colors.dart';
import 'package:scadar/core/presentation/widgets/custom_button.dart';
import 'package:scadar/core/presentation/widgets/custom_dropdown.dart';
import 'package:scadar/core/presentation/widgets/custom_text_field.dart';
import 'package:scadar/core/presentation/widgets/custom_card.dart';
import 'package:scadar/core/presentation/widgets/section_title.dart';
import 'package:scadar/features/home/bloc/currency_cubit.dart';
import 'package:scadar/features/home/bloc/finance_bloc.dart';
import 'package:scadar/features/home/bloc/finance_event.dart';
import 'package:scadar/features/home/bloc/finance_state.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _amountController = TextEditingController();
  final _convertAmountController = TextEditingController();
  String _incomeCurrency = 'USD';
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';

  @override
  void dispose() {
    _amountController.dispose();
    _convertAmountController.dispose();
    super.dispose();
  }

  void _addIncome() {
    final amountText = _amountController.text;
    if (amountText.isEmpty) return;

    final amount = double.tryParse(amountText);
    if (amount == null) return;

    final income = IncomeModel()
      ..amount = amount
      ..currency = _incomeCurrency
      ..month = DateTime.now().month
      ..year = DateTime.now().year
      ..dateAdded = DateTime.now();

    context.read<FinanceBloc>().add(AddIncomeEvent(income));
    _amountController.clear();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Income Added!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Total Income Card
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle('Total Income'),
                  const SizedBox(height: 12),
                  BlocBuilder<FinanceBloc, FinanceState>(
                    builder: (context, state) {
                      if (state is FinanceLoading) {
                        return const CircularProgressIndicator();
                      } else if (state is FinanceLoaded) {
                        return Text(
                          '${state.totalIncome.toStringAsFixed(2)} ${state.baseCurrency}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        );
                      }
                      return const Text('\$ 0.00');
                    },
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.primary, thickness: 0.5),
                  const SizedBox(height: 16),
                  const Text(
                    'Add New Income',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                          value: _incomeCurrency,
                          items: const [
                            'USD',
                            'EUR',
                            'GBP',
                            'INR',
                            'JPY',
                            'CAD',
                            'AUD',
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _incomeCurrency = val);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    onPressed: _addIncome,
                    text: 'Add Income',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Currency Converter Card
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle('Currency Converter'),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _convertAmountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    hintText: 'Amount to convert',
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<CurrencyCubit, CurrencyState>(
                    builder: (context, state) {
                      List<String> items = ['USD', 'EUR', 'GBP', 'INR', 'JPY'];
                      if (state is CurrencyLoaded &&
                          state.availableCurrencies.isNotEmpty) {
                        items = state.availableCurrencies;
                        if (!items.contains(_fromCurrency)) {
                          _fromCurrency = items.first;
                        }
                        if (!items.contains(_toCurrency)) {
                          _toCurrency = items.last;
                        }
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: CustomDropdown<String>(
                              value: _fromCurrency,
                              items: items,
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _fromCurrency = val);
                                }
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                final temp = _fromCurrency;
                                _fromCurrency = _toCurrency;
                                _toCurrency = temp;
                              });
                            },
                            icon: const Icon(
                              Icons.swap_horiz,
                              size: 32,
                              color: AppColors.primary,
                            ),
                          ),
                          Expanded(
                            child: CustomDropdown<String>(
                              value: _toCurrency,
                              items: items,
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _toCurrency = val);
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    onPressed: () {
                      final amount =
                          double.tryParse(_convertAmountController.text) ?? 1.0;
                      context.read<CurrencyCubit>().convert(
                        amount: amount,
                        fromCurrency: _fromCurrency,
                        toCurrency: _toCurrency,
                      );
                    },
                    text: 'Convert',
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<CurrencyCubit, CurrencyState>(
                    builder: (context, state) {
                      if (state is CurrencyLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is CurrencyLoaded) {
                        return Center(
                          child: Text(
                            '${_convertAmountController.text.isEmpty ? "1" : _convertAmountController.text} $_fromCurrency = ${state.convertedAmount.toStringAsFixed(2)} $_toCurrency',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      } else if (state is CurrencyError) {
                        return Text(
                          state.message,
                          style: const TextStyle(color: AppColors.errorLight),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

}
