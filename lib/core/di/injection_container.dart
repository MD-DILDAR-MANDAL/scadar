import 'package:get_it/get_it.dart';
import 'package:scadar/core/cache/isar_service.dart';
import 'package:scadar/core/repository/currency_repository.dart';
import 'package:scadar/core/repository/finance_repository.dart';
import 'package:scadar/core/utils/currency_converter_service.dart';
import 'package:scadar/features/home/bloc/currency_cubit.dart';
import 'package:scadar/features/home/bloc/finance_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton<IsarService>(() => IsarService());
  sl.registerLazySingleton<CurrencyConverterService>(() => CurrencyConverterService());

  // Repositories
  sl.registerLazySingleton<FinanceRepository>(
    () => FinanceRepositoryImpl(isarService: sl()),
  );
  sl.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImpl(converterService: sl()),
  );

  // Blocs
  sl.registerFactory(() => FinanceBloc(financeRepository: sl()));
  sl.registerFactory(() => CurrencyCubit(currencyRepository: sl()));

  // Wait for DB to open to ensure it's ready before the app starts if needed
  await sl<IsarService>().openDB();
}
