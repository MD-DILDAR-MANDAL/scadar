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

  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final currencyState = context.read<CurrencyCubit>().state;
      if (currencyState is CurrencyLoaded) {
        _incomeCurrency = currencyState.globalCurrency;
        _isInit = true;
      }
    }
  }

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
    return BlocListener<CurrencyCubit, CurrencyState>(
      listener: (context, state) {
        if (state is CurrencyLoaded && !_isInit) {
          setState(() {
            _incomeCurrency = state.globalCurrency;
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

            // Incomes List
            BlocBuilder<FinanceBloc, FinanceState>(
              builder: (context, state) {
                if (state is FinanceLoaded && state.incomes.isNotEmpty) {
                  return CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle('Recent Incomes'),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.incomes.length,
                          itemBuilder: (context, index) {
                            final inc = state.incomes[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                '${inc.amount.toStringAsFixed(2)} ${inc.currency}',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${inc.dateAdded.day}/${inc.dateAdded.month}/${inc.dateAdded.year}',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: AppColors.primary, size: 20),
                                    onPressed: () => _showEditIncomeSheet(context, inc),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: AppColors.error, size: 20),
                                    onPressed: () => _showDeleteConfirmation(context, inc),
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
                return const SizedBox.shrink();
              },
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
    ));
  }

  void _showDeleteConfirmation(BuildContext context, IncomeModel income) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.tertiary,
        title: const Text('Delete Income', style: TextStyle(color: AppColors.primary)),
        content: const Text('Are you sure you want to delete this income?', style: TextStyle(color: AppColors.primary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.primary)),
          ),
          TextButton(
            onPressed: () {
              context.read<FinanceBloc>().add(DeleteIncomeEvent(income));
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showEditIncomeSheet(BuildContext context, IncomeModel income) {
    final amountCtrl = TextEditingController(text: income.amount.toString());
    String selectedCurrency = income.currency;
    final List<String> currencies = ['USD', 'EUR', 'GBP', 'INR', 'JPY', 'CAD', 'AUD'];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.tertiary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Edit Income',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          controller: amountCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          hintText: 'Amount',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: CustomDropdown<String>(
                          value: selectedCurrency,
                          items: currencies,
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() => selectedCurrency = val);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Save Changes',
                    onPressed: () {
                      final amount = double.tryParse(amountCtrl.text);
                      if (amount == null) return;
                      
                      income.amount = amount;
                      income.currency = selectedCurrency;
                      
                      this.context.read<FinanceBloc>().add(UpdateIncomeEvent(income));
                      Navigator.pop(ctx);
                    },
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
