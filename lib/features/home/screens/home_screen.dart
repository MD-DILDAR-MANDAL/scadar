import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scadar/core/constants/app_colors.dart';
import 'package:scadar/core/database/models/expense_model.dart';
import 'package:scadar/core/database/models/income_model.dart';
import 'package:scadar/core/widgets/custom_card.dart';
import 'package:scadar/core/widgets/section_title.dart';
import 'package:scadar/features/backup/screens/backup_screen.dart';
import 'package:scadar/features/currency/bloc/currency_bloc.dart';
import 'package:scadar/features/currency/bloc/currency_event.dart';
import 'package:scadar/features/currency/bloc/currency_state.dart';
import 'package:scadar/features/finance/bloc/finance_bloc.dart';
import 'package:scadar/features/finance/bloc/finance_state.dart';
import 'package:scadar/features/subscriptions/screens/subscriptions_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scadar Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_sync_outlined, color: AppColors.white),
            tooltip: 'Cloud Backup & Sync',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => const BackupScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.autorenew, color: AppColors.white),
            tooltip: 'Subscriptions',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const SubscriptionsScreen(),
                ),
              );
            },
          ),
          BlocBuilder<CurrencyBloc, CurrencyState>(
            builder: (context, currencyState) {
              if (currencyState is CurrencyLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButton<String>(
                    value: currencyState.globalCurrency,
                    dropdownColor: AppColors.primary,
                    style: const TextStyle(
                      color: AppColors.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.tertiary,
                    ),
                    underline: const SizedBox(),
                    items: currencyState.availableCurrencies.map((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        context.read<CurrencyBloc>().add(
                          SetGlobalCurrencyEvent(newValue),
                        );
                      }
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<FinanceBloc, FinanceState>(
        builder: (context, state) {
          if (state is FinanceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FinanceLoaded) {
            return _buildContent(context, state);
          } else if (state is FinanceError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, FinanceLoaded state) {
    final allTransactions = _getRecentTransactions(
      state.incomes,
      state.expenses,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card 1: Total Balance
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Total Balance'),
                const SizedBox(height: 8),
                Text(
                  '${state.totalBalance.toStringAsFixed(2)} ${state.baseCurrency}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Card: Monthly Expenses Chart (Yearly overview)
          CustomCard(
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Monthly Expenses (Yearly)'),
                const SizedBox(height: 16),
                Expanded(
                  child: state.monthlyExpenses.isEmpty
                      ? const Center(
                          child: Text(
                            'No expenses',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        )
                      : _buildMonthlyExpensesLineChart(state.monthlyExpenses),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Card 3: Expenses per categories Pie Chart
          CustomCard(
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Expenses by Category'),
                const SizedBox(height: 16),
                Expanded(
                  child: state.expenses.isEmpty
                      ? const Center(
                          child: Text(
                            'No expenses',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        )
                      : _buildExpensesMultilineChart(
                          state.yearlyCategoryExpenses,
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Card 4: Last transactions
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Last transactions'),
                const SizedBox(height: 12),
                allTransactions.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'No recent transactions',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: allTransactions.length > 5
                            ? 5
                            : allTransactions.length,
                        itemBuilder: (context, index) {
                          final tx = allTransactions[index];
                          final isIncome = tx.containsKey('income');
                          final amount = isIncome
                              ? (tx['income'] as IncomeModel).amount
                              : (tx['expense'] as ExpenseModel).amount;
                          final date = isIncome
                              ? (tx['income'] as IncomeModel).dateAdded
                              : (tx['expense'] as ExpenseModel).date;
                          final currency = isIncome
                              ? (tx['income'] as IncomeModel).currency
                              : (tx['expense'] as ExpenseModel).currency;
                          final title = isIncome
                              ? 'Income'
                              : (tx['expense'] as ExpenseModel).description;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title.isEmpty ? 'Unknown' : title,
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      DateFormat.yMMMd().format(date),
                                      style: TextStyle(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.7,
                                        ),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${isIncome ? '+' : '-'}${amount.toStringAsFixed(2)} $currency',
                                  style: TextStyle(
                                    color: isIncome
                                        ? AppColors.success
                                        : AppColors.error,
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
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getRecentTransactions(
    List<IncomeModel> incomes,
    List<ExpenseModel> expenses,
  ) {
    final List<Map<String, dynamic>> list = [];
    for (var inc in incomes) {
      list.add({'income': inc, 'date': inc.dateAdded});
    }
    for (var exp in expenses) {
      list.add({'expense': exp, 'date': exp.date});
    }
    list.sort(
      (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
    );
    return list;
  }

  Widget _buildExpensesMultilineChart(
    Map<ExpenseCategory, Map<int, double>> yearlyCategoryExpenses,
  ) {
    final List<LineChartBarData> lineBarsData = [];
    final List<Color> colors = AppColors.chartColors;

    final double maxX = 12;
    double maxY = 1;

    int i = 0;
    yearlyCategoryExpenses.forEach((category, monthlyData) {
      final List<FlSpot> spots = [];
      for (int month = 1; month <= 12; month++) {
        final amount = monthlyData[month] ?? 0.0;
        spots.add(FlSpot(month.toDouble(), amount));
        if (amount > maxY) maxY = amount;
      }

      lineBarsData.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          preventCurveOverShooting: true,
          color: colors[i % colors.length],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      );
      i++;
    });

    if (lineBarsData.isEmpty) return const SizedBox.shrink();

    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final chart = LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value >= 1 && value <= 12) {
                  return Text(
                    monthNames[value.toInt() - 1],
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 1,
        maxX: maxX,
        minY: 0,
        maxY: maxY + (maxY * 0.2), // 20% headroom
        lineBarsData: lineBarsData,
      ),
    );

    return Column(
      children: [
        Expanded(child: chart),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: yearlyCategoryExpenses.keys.toList().asMap().entries.map((
            entry,
          ) {
            final index = entry.key;
            final category = entry.value;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  category.name.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMonthlyExpensesLineChart(Map<int, double> monthlyExpenses) {
    final List<FlSpot> spots = [];
    final double maxX = 12;
    double maxY = 1;

    for (int month = 1; month <= 12; month++) {
      final amount = monthlyExpenses[month] ?? 0.0;
      spots.add(FlSpot(month.toDouble(), amount));
      if (amount > maxY) maxY = amount;
    }

    if (spots.isEmpty) return const SizedBox.shrink();

    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value >= 1 && value <= 12) {
                  return Text(
                    monthNames[value.toInt() - 1],
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 1,
        maxX: maxX,
        minY: 0,
        maxY: maxY + (maxY * 0.2), // 20% headroom
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            preventCurveOverShooting: true,
            color: AppColors.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}
