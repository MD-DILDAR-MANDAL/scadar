import 'package:get_it/get_it.dart';
import 'package:scadar/core/cache/isar_service.dart';
import 'package:scadar/core/repository/currency_repository.dart';
import 'package:scadar/core/repository/finance_repository.dart';
import 'package:scadar/core/utils/currency_converter_service.dart';
import 'package:scadar/core/services/backup_sync_service.dart';
import 'package:scadar/core/services/google_drive_service.dart';
import 'package:scadar/features/backup/bloc/backup_bloc.dart';
import 'package:scadar/features/home/bloc/currency_cubit.dart';
import 'package:scadar/features/home/bloc/finance_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scadar/core/repository/settings_repository.dart';

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
    currencyCubit: sl(),
  ));
  sl.registerLazySingleton(() => CurrencyCubit(
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
