import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scadar/app/navigation/navigation_screen.dart';
import 'package:scadar/app/theme/app_theme.dart';
import 'package:scadar/core/di/injection_container.dart';
import 'package:scadar/core/services/backup_sync_service.dart';
import 'package:scadar/features/backup/bloc/backup_bloc.dart';
import 'package:scadar/features/backup/bloc/backup_event.dart';
import 'package:scadar/features/currency/bloc/currency_bloc.dart';
import 'package:scadar/features/currency/bloc/currency_event.dart';
import 'package:scadar/features/finance/bloc/finance_bloc.dart';
import 'package:scadar/features/finance/bloc/finance_event.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      sl<BackupSyncService>().performAutoSyncIfEnabled();
    }
  }

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
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const NavigationScreen(),
      ),
    );
  }
}
