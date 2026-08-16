import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scadar/core/cache/models/expense_model.dart';
import 'package:scadar/core/constant/app_colors.dart';
import 'package:scadar/core/presentation/widgets/custom_card.dart';
import 'package:scadar/core/presentation/widgets/section_title.dart';
import 'package:scadar/features/home/bloc/currency_cubit.dart';
import 'package:scadar/features/home/bloc/finance_bloc.dart';
import 'package:scadar/features/home/bloc/finance_event.dart';
import 'package:scadar/features/home/bloc/finance_state.dart';
import 'package:scadar/features/analytics/widgets/add_budget_dialog.dart';
import 'package:screenshot/screenshot.dart';

enum AnalyticsTimeframe { day, month }

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  AnalyticsTimeframe _timeframe = AnalyticsTimeframe.day;
  final ScreenshotController _screenshotController = ScreenshotController();
  DateTime _selectedDate = DateTime.now();

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
          // Controls Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SegmentedButton<AnalyticsTimeframe>(
                segments: const [
                  ButtonSegment(
                    value: AnalyticsTimeframe.day,
                    label: Text('Day'),
                  ),
                  ButtonSegment(
                    value: AnalyticsTimeframe.month,
                    label: Text('Month'),
                  ),
                ],
                selected: <AnalyticsTimeframe>{_timeframe},
                onSelectionChanged: (Set<AnalyticsTimeframe> newSelection) {
                  setState(() {
                    _timeframe = newSelection.first;
                  });
                },
                style: SegmentedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  selectedBackgroundColor: AppColors.primary.withValues(
                    alpha: 0.2,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _pickDate,
                    icon: const Icon(
                      Icons.calendar_month,
                      color: AppColors.primary,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'image') {
                        _exportScreenshot();
                      } else if (value == 'csv') {
                        _exportCSV();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'image',
                        child: Text('Export as Image'),
                      ),
                      const PopupMenuItem(
                        value: 'csv',
                        child: Text('Export as CSV'),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.download, size: 18, color: AppColors.dark),
                          SizedBox(width: 8),
                          Text(
                            'Export',
                            style: TextStyle(
                              color: AppColors.dark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          Screenshot(
            controller: _screenshotController,
            child: Container(
              color: AppColors.tertiary, // Background color for screenshot
              child: Column(
                children: [
                  // Line Chart Card
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionTitle(
                          _timeframe == AnalyticsTimeframe.day
                              ? '7-Day Expenses (ending ${DateFormat.yMMMd().format(_selectedDate)})'
                              : 'Monthly expenses - ${_selectedDate.year}',
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 200,
                          child:
                              (_timeframe == AnalyticsTimeframe.day
                                  ? state.expenses.isEmpty
                                  : state.monthlyExpenses.values.every(
                                      (v) => v == 0,
                                    ))
                              ? const Center(
                                  child: Text(
                                    'No expenses recorded',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                )
                              : _buildLineChart(state),
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
                        SectionTitle(
                          _timeframe == AnalyticsTimeframe.day
                              ? '7-Day Categories (ending ${DateFormat.yMMMd().format(_selectedDate)})'
                              : 'Categories - ${_selectedDate.year}',
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 200,
                          child:
                              (_timeframe == AnalyticsTimeframe.day
                                  ? state.expenses.isEmpty
                                  : state.monthlyExpenses.values.every(
                                      (v) => v == 0,
                                    ))
                              ? const Center(
                                  child: Text(
                                    'No expenses recorded',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                )
                              : _buildPieChart(state),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildBudgetsCard(state),
                ],
              ),
            ),
          ),
          const SizedBox(height: 100), // Bottom padding for navbar
        ],
      ),
    );
  }

  Future<void> _exportScreenshot() async {
    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'scadar_analytics_$timestamp.png';

      if (Platform.isAndroid || Platform.isIOS) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(image);

        final params = SaveFileDialogParams(sourceFilePath: file.path);
        final filePath = await FlutterFileDialog.saveFile(params: params);

        if (filePath != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Saved successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        final FileSaveLocation? result = await getSaveLocation(
          suggestedName: fileName,
        );

        if (result == null) {
          // User cancelled the dialog
          return;
        }

        final file = File(result.path);
        await file.writeAsBytes(image);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to ${file.path}'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to export image: $e')));
    }
  }

  Future<void> _exportCSV() async {
    try {
      final state = context.read<FinanceBloc>().state;
      if (state is! FinanceLoaded) return;

      String csvData = "Date,Type,Category,Amount,Currency\n";

      List<ExpenseModel> expensesToExport = [];
      if (_timeframe == AnalyticsTimeframe.day) {
        expensesToExport = _getSevenDaysExpenses(state);
      } else {
        expensesToExport = state.allExpenses
            .where((e) => e.date.year == _selectedDate.year)
            .toList();
      }

      for (var exp in expensesToExport) {
        final date = DateFormat('yyyy-MM-dd').format(exp.date);
        final category = exp.category.name.toUpperCase();
        csvData += "$date,Expense,$category,${exp.amount},${exp.currency}\n";
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'scadar_data_$timestamp.csv';

      if (Platform.isAndroid || Platform.isIOS) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/$fileName');
        await file.writeAsString(csvData);

        final params = SaveFileDialogParams(sourceFilePath: file.path);
        final filePath = await FlutterFileDialog.saveFile(params: params);

        if (filePath != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Saved successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        final FileSaveLocation? result = await getSaveLocation(
          suggestedName: fileName,
        );

        if (result == null) return;

        final file = File(result.path);
        await file.writeAsString(csvData);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to ${file.path}'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to export CSV: $e')));
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDatePickerMode: _timeframe == AnalyticsTimeframe.month
          ? DatePickerMode.year
          : DatePickerMode.day,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      if (mounted) {
        context.read<FinanceBloc>().add(
          LoadFinanceData(month: picked.month, year: picked.year),
        );
      }
    }
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

  List<ExpenseModel> _getSevenDaysExpenses(FinanceLoaded state) {
    final startDate = _selectedDate.subtract(const Duration(days: 6));
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      23,
      59,
      59,
    );

    return state.allExpenses.where((exp) {
      return exp.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
          exp.date.isBefore(end.add(const Duration(seconds: 1)));
    }).toList();
  }

  Widget _buildLineChart(FinanceLoaded state) {
    if (_timeframe == AnalyticsTimeframe.month) {
      final List<FlSpot> spots = [];
      final double maxX = 12;
      double maxY = 1;

      for (int month = 1; month <= 12; month++) {
        final amount = state.monthlyExpenses[month] ?? 0.0;
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
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
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
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      );
    } else {
      // Day timeframe (7 days ending on _selectedDate)
      final startDate = _selectedDate.subtract(const Duration(days: 6));
      final start = DateTime(startDate.year, startDate.month, startDate.day);

      final Map<int, double> dailyExpenses = {
        for (int i = 0; i < 7; i++) i: 0.0,
      };

      final sevenDaysExpenses = _getSevenDaysExpenses(state);
      for (var exp in sevenDaysExpenses) {
        // Find which day index (0-6) this expense belongs to
        final expDate = DateTime(exp.date.year, exp.date.month, exp.date.day);
        final daysSince = expDate.difference(start).inDays;

        if (daysSince >= 0 && daysSince <= 6) {
          final convertedAmount = _getConvertedAmount(exp.amount, exp.currency);
          dailyExpenses[daysSince] =
              (dailyExpenses[daysSince] ?? 0) + convertedAmount;
        }
      }

      final List<FlSpot> spots = [];
      final double maxX = 6;
      double maxY = 1;

      for (int i = 0; i <= 6; i++) {
        final amount = dailyExpenses[i]!;
        spots.add(FlSpot(i.toDouble(), amount));
        if (amount > maxY) maxY = amount;
      }

      if (spots.isEmpty) return const SizedBox.shrink();

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
                  final int index = value.toInt();
                  if (index >= 0 && index <= 6) {
                    final date = start.add(Duration(days: index));
                    return Text(
                      date.day.toString(),
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
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          minX: 0,
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
  }

  Widget _buildPieChart(FinanceLoaded state) {
    final Map<ExpenseCategory, double> categoryExpenses = {};

    if (_timeframe == AnalyticsTimeframe.month) {
      state.yearlyCategoryExpenses.forEach((category, monthlyData) {
        double totalForCategory = 0;
        for (var amount in monthlyData.values) {
          totalForCategory += amount;
        }
        categoryExpenses[category] = totalForCategory;
      });
    } else {
      final sevenDaysExpenses = _getSevenDaysExpenses(state);
      for (var exp in sevenDaysExpenses) {
        final convertedAmount = _getConvertedAmount(exp.amount, exp.currency);
        categoryExpenses[exp.category] =
            (categoryExpenses[exp.category] ?? 0) + convertedAmount;
      }
    }

    final double total = categoryExpenses.values.fold(
      0,
      (sum, amount) => sum + amount,
    );

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
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
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
            children: categoryExpenses.keys.toList().asMap().entries.map((
              entry,
            ) {
              final index = entry.key;
              final category = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      color: colors[index % colors.length],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        category.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.primary,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetsCard(FinanceLoaded state) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SectionTitle('Monthly Budgets'),
              IconButton(
                icon: const Icon(Icons.add_circle, color: AppColors.primary),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => AddBudgetDialog(selectedDate: _selectedDate),
                  );
                },
              ),
            ],
          ),
          if (state.budgets.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No budgets set for this month',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            )
          else
            ...state.budgets.map((budget) {
              double spent = 0;
              if (budget.category == null) {
                // Overall budget
                for (var cat in state.yearlyCategoryExpenses.keys) {
                  spent += state.yearlyCategoryExpenses[cat]![_selectedDate.month] ?? 0;
                }
              } else {
                // Category budget
                spent = state.yearlyCategoryExpenses[budget.category]![_selectedDate.month] ?? 0;
              }
              
              final percent = (budget.limit > 0) ? (spent / budget.limit) : 0.0;
              final progress = percent.clamp(0.0, 1.0);
              final isOverBudget = spent > budget.limit;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          budget.category?.name.toUpperCase() ?? 'OVERALL',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.dark),
                        ),
                        Row(
                          children: [
                            Text(
                              '${spent.toStringAsFixed(0)} ${state.baseCurrency} / ${budget.limit.toStringAsFixed(0)} ${state.baseCurrency}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isOverBudget ? Colors.red : AppColors.dark,
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                context.read<FinanceBloc>().add(DeleteBudgetEvent(budget));
                              },
                              child: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.grey.withValues(alpha: 0.2),
                      color: isOverBudget ? Colors.red : AppColors.primary,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    if (isOverBudget)
                      const Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Over budget!',
                          style: TextStyle(color: Colors.red, fontSize: 10),
                        ),
                      ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
