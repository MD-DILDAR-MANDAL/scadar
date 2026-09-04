import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scadar/core/constant/app_colors.dart';
import 'package:scadar/core/di/injection_container.dart';
import 'package:scadar/core/services/backup_sync_service.dart';
import 'package:scadar/features/backup/bloc/backup_bloc.dart';
import 'package:scadar/features/backup/bloc/backup_event.dart';
import 'package:scadar/features/home/bloc/currency_cubit.dart';
import 'package:scadar/features/home/bloc/finance_bloc.dart';
import 'package:scadar/features/home/bloc/finance_event.dart';
import 'package:scadar/navigate.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
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
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      sl<BackupSyncService>().performAutoSyncIfEnabled();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<CurrencyCubit>()..initGlobalCurrency(),
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
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.tertiary,
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            tertiary: AppColors.tertiary,
            error: AppColors.error,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.secondary,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.primary,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.tertiary,
          ),
        ),
        home: const Navigate(),
      ),
    );
  }
}
