import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scadar/core/constants/app_colors.dart';
import 'package:scadar/features/analytics/screens/analytics_screen.dart';
import 'package:scadar/features/backup/bloc/backup_bloc.dart';
import 'package:scadar/features/backup/bloc/backup_state.dart';
import 'package:scadar/features/currency/bloc/currency_bloc.dart';
import 'package:scadar/features/currency/bloc/currency_event.dart';
import 'package:scadar/features/expense/screens/expense_screen.dart';
import 'package:scadar/features/finance/bloc/finance_bloc.dart';
import 'package:scadar/features/finance/bloc/finance_event.dart';
import 'package:scadar/features/home/screens/home_screen.dart';
import 'package:scadar/features/income/screens/income_screen.dart';
import 'package:scadar/features/subscriptions/screens/subscriptions_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int selectedIndex = 0;

  final screens = <Widget>[
    const HomeScreen(),
    const ExpenseScreen(),
    const IncomeScreen(),
    const AnalyticsScreen(),
    const SubscriptionsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<BackupBloc, BackupState>(
      listenWhen: (previous, current) =>
          previous.isRestoring && !current.isRestoring && current.errorMessage == null,
      listener: (context, state) {
        final now = DateTime.now();
        context.read<CurrencyBloc>().add(const InitGlobalCurrencyEvent());
        context.read<FinanceBloc>().add(
              LoadFinanceData(month: now.month, year: now.year),
            );
      },
      child: Scaffold(
        body: SafeArea(child: screens[selectedIndex]),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(50),
            ),
            clipBehavior: Clip.antiAlias,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 0.0,
              currentIndex: selectedIndex,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined, size: 30),
                  label: "Home",
                  activeIcon: BuildActiveIcon(iconData: Icons.home),
                  backgroundColor: AppColors.tertiary,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.payments_outlined, size: 30),
                  label: "Expense",
                  activeIcon: BuildActiveIcon(iconData: Icons.payments),
                  backgroundColor: AppColors.tertiary,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.savings_outlined, size: 30),
                  label: "Income",
                  activeIcon: BuildActiveIcon(iconData: Icons.savings),
                  backgroundColor: AppColors.tertiary,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics_outlined, size: 30),
                  label: "Analytics",
                  activeIcon: BuildActiveIcon(iconData: Icons.analytics),
                  backgroundColor: AppColors.tertiary,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.autorenew_outlined, size: 30),
                  label: "Subs",
                  activeIcon: BuildActiveIcon(iconData: Icons.autorenew),
                  backgroundColor: AppColors.tertiary,
                ),
              ],
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              selectedItemColor: AppColors.primary,
              backgroundColor: AppColors.secondary,
              unselectedIconTheme: const IconThemeData(color: AppColors.primary),
              selectedLabelStyle: const TextStyle(
                color: AppColors.tertiary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BuildActiveIcon extends StatelessWidget {
  final IconData iconData;
  const BuildActiveIcon({required this.iconData, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.tertiary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(iconData, size: 30),
      ),
    );
  }
}
