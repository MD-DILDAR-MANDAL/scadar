import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scadar/app/navigation/navigation_screen.dart';
import 'package:scadar/app/theme/app_theme.dart';
import 'package:scadar/core/di/injection_container.dart';
import 'package:scadar/features/backup/bloc/backup_bloc.dart';
import 'package:scadar/features/backup/bloc/backup_event.dart';
import 'package:scadar/features/currency/bloc/currency_bloc.dart';
import 'package:scadar/features/currency/bloc/currency_event.dart';
import 'package:scadar/features/finance/bloc/finance_bloc.dart';
import 'package:scadar/features/finance/bloc/finance_event.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<CurrencyBloc>()..add(const InitGlobalCurrencyEvent()),
        ),
        BlocProvider(
          create: (context) => sl<FinanceBloc>()
            ..add(
              LoadFinanceData(
                month: DateTime.now().month,
                year: DateTime.now().year,
              ),
            ),
        ),
        BlocProvider(
          create: (context) => sl<BackupBloc>()..add(const InitBackupEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Scadar',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const NavigationScreen(),
      ),
    );
  }
}
