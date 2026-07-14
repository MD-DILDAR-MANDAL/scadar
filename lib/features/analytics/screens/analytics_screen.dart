import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scadar/core/constant/app_colors.dart';
import 'package:scadar/core/presentation/widgets/custom_card.dart';
import 'package:scadar/core/presentation/widgets/section_title.dart';
import 'package:scadar/features/home/bloc/finance_bloc.dart';
import 'package:scadar/features/home/bloc/finance_state.dart';
import 'package:scadar/core/cache/models/expense_model.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FinanceBloc, FinanceState>(
        builder: (context, state) {
          if (state is FinanceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FinanceLoaded) {
            return _buildContent(context, state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, FinanceLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Export Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 18),
                label: const Text('export'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.dark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Line Chart Card
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Each day expense graph'),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: state.expenses.isEmpty
                      ? const Center(child: Text('No expenses recorded', style: TextStyle(color: AppColors.primary)))
                      : _buildLineChart(state.expenses),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Pie Chart Card
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('All categories for single month pie chart'),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: state.expenses.isEmpty
                      ? const Center(child: Text('No expenses recorded', style: TextStyle(color: AppColors.primary)))
                      : _buildPieChart(state.expenses),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100), // Bottom padding for navbar
        ],
      ),
    );
  }

  Widget _buildLineChart(List<ExpenseModel> expenses) {
    // Group by day for the current month
    final Map<int, double> dailyExpenses = {};
    for (var exp in expenses) {
      final day = exp.date.day;
      dailyExpenses[day] = (dailyExpenses[day] ?? 0) + exp.amount;
    }

    final List<FlSpot> spots = [];
    double maxX = 1;
    double maxY = 1;

    final sortedDays = dailyExpenses.keys.toList()..sort();
    for (var day in sortedDays) {
      final amount = dailyExpenses[day]!;
      spots.add(FlSpot(day.toDouble(), amount));
      if (day > maxX) maxX = day.toDouble();
      if (amount > maxY) maxY = amount;
    }

    if (spots.isEmpty) return const SizedBox.shrink();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: 5,
              getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(color: AppColors.primary, fontSize: 10)),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(color: AppColors.primary, fontSize: 10)),
            ),
          ),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: AppColors.primary.withValues(alpha: 0.2))),
        minX: spots.first.x,
        maxX: maxX,
        minY: 0,
        maxY: maxY + (maxY * 0.2), // 20% headroom
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(List<ExpenseModel> expenses) {
    final Map<ExpenseCategory, double> categoryExpenses = {};
    for (var exp in expenses) {
      categoryExpenses[exp.category] = (categoryExpenses[exp.category] ?? 0) + exp.amount;
    }

    final double total = expenses.fold(0, (sum, exp) => sum + exp.amount);
    
    final List<PieChartSectionData> sections = [];
    final List<Color> colors = AppColors.chartColors;
    
    int i = 0;
    categoryExpenses.forEach((category, amount) {
      final percentage = (amount / total * 100).toStringAsFixed(1);
      sections.add(
        PieChartSectionData(
          color: colors[i % colors.length],
          value: amount,
          title: '$percentage%',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.white),
        ),
      );
      i++;
    });

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: sections,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categoryExpenses.keys.toList().asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Container(width: 12, height: 12, color: colors[index % colors.length]),
                    const SizedBox(width: 8),
                    Expanded(child: Text(category.name.toUpperCase(), style: const TextStyle(fontSize: 10, color: AppColors.primary, overflow: TextOverflow.ellipsis))),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
