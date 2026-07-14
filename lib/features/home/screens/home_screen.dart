import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scadar/core/cache/models/expense_model.dart';
import 'package:scadar/core/cache/models/income_model.dart';
import 'package:scadar/core/constant/app_colors.dart';
import 'package:scadar/core/presentation/widgets/custom_card.dart';
import 'package:scadar/core/presentation/widgets/section_title.dart';
import 'package:scadar/features/home/bloc/finance_bloc.dart';
import 'package:scadar/features/home/bloc/finance_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          // Card 2: Expenses Chart
          CustomCard(
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Total Expenses'),
                const SizedBox(height: 4),
                Text(
                  '${state.totalExpense.toStringAsFixed(2)} ${state.baseCurrency}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: state.expenses.isEmpty
                      ? const Center(
                          child: Text(
                            'No expenses',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        )
                      : _buildExpensesBarChart(state.expenses),
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
                      : _buildExpensesPieChart(state.expenses),
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

  Widget _buildExpensesBarChart(List<ExpenseModel> expenses) {
    // Group by day for the current month
    final Map<int, double> dailyExpenses = {};
    for (var exp in expenses) {
      final day = exp.date.day;
      dailyExpenses[day] = (dailyExpenses[day] ?? 0) + exp.amount;
    }

    final List<BarChartGroupData> barGroups = [];
    dailyExpenses.forEach((day, amount) {
      barGroups.add(
        BarChartGroupData(
          x: day,
          barRods: [
            BarChartRodData(
              toY: amount,
              color: AppColors.primary,
              width: 12,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    });

    if (barGroups.isEmpty) return const SizedBox.shrink();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: barGroups,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildExpensesPieChart(List<ExpenseModel> expenses) {
    final Map<ExpenseCategory, double> categoryExpenses = {};
    for (var exp in expenses) {
      categoryExpenses[exp.category] =
          (categoryExpenses[exp.category] ?? 0) + exp.amount;
    }

    final List<PieChartSectionData> sections = [];
    final List<Color> colors = AppColors.chartColors;

    int i = 0;
    categoryExpenses.forEach((category, amount) {
      sections.add(
        PieChartSectionData(
          color: colors[i % colors.length],
          value: amount,
          title: '${category.name}\n${amount.toStringAsFixed(0)}',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      );
      i++;
    });

    return PieChart(
      PieChartData(sections: sections, centerSpaceRadius: 30, sectionsSpace: 2),
    );
  }
}
