import 'package:get_it/get_it.dart';
import 'package:scadar/core/database/isar_service.dart';
import 'package:scadar/core/repositories/currency_repository.dart';
import 'package:scadar/core/repositories/finance_repository.dart';
import 'package:scadar/core/repositories/settings_repository.dart';
import 'package:scadar/core/services/backup_sync_service.dart';
import 'package:scadar/core/services/currency_converter_service.dart';
import 'package:scadar/core/services/google_drive_service.dart';
import 'package:scadar/features/backup/bloc/backup_bloc.dart';
import 'package:scadar/features/currency/bloc/currency_bloc.dart';
import 'package:scadar/features/finance/bloc/finance_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // Services
  sl.registerLazySingleton<IsarService>(() => IsarService());
  sl.registerLazySingleton<CurrencyConverterService>(() => CurrencyConverterService());
  sl.registerLazySingleton<GoogleDriveService>(() => GoogleDriveService());
  sl.registerLazySingleton<BackupSyncService>(
    () => BackupSyncService(
      isarService: sl(),
      googleDriveService: sl(),
      settingsRepository: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<FinanceRepository>(
    () => FinanceRepositoryImpl(isarService: sl()),
  );
  sl.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImpl(
      converterService: sl(),
      isarService: sl(),
    ),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(prefs: sl()),
  );

  // Blocs
  sl.registerFactory(() => FinanceBloc(
    financeRepository: sl(),
    currencyBloc: sl(),
  ));
  sl.registerLazySingleton(() => CurrencyBloc(
    currencyRepository: sl(),
    settingsRepository: sl(),
  ));
  sl.registerLazySingleton(() => BackupBloc(
    googleDriveService: sl(),
    backupSyncService: sl(),
    settingsRepository: sl(),
  ));

  // Wait for DB to open to ensure it's ready before the app starts if needed
  await sl<IsarService>().openDB();
}
