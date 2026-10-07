import 'package:flutter_test/flutter_test.dart';
import 'package:scadar/core/repositories/currency_repository.dart';
import 'package:scadar/core/repositories/settings_repository.dart';
import 'package:scadar/features/currency/bloc/currency_bloc.dart';
import 'package:scadar/features/currency/bloc/currency_event.dart';
import 'package:scadar/features/currency/bloc/currency_state.dart';

class FakeCurrencyRepository implements CurrencyRepository {
  List<String> currencies = ['USD', 'EUR', 'INR'];
  Map<String, double> rates = {'USD': 1.0, 'EUR': 0.9, 'INR': 83.0};
  double convertedResult = 90.0;

  @override
  Future<double> convert({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    return convertedResult;
  }

  @override
  Future<Map<String, double>> fetchRatesForBase(String baseCurrency) async {
    return rates;
  }

  @override
  Future<List<String>> getAvailableCurrencies() async {
    return currencies;
  }
}

class FakeSettingsRepository implements SettingsRepository {
  String currency = 'USD';
  bool autoSync = false;
  DateTime? lastSyncTime;
  String? lastSyncStatus;

  @override
  Future<String> getGlobalCurrency() async => currency;

  @override
  Future<void> saveGlobalCurrency(String curr) async {
    currency = curr;
  }

  @override
  Future<bool> isAutoSyncEnabled() async => autoSync;

  @override
  Future<void> setAutoSyncEnabled(bool enabled) async {
    autoSync = enabled;
  }

  @override
  Future<DateTime?> getLastSyncTime() async => lastSyncTime;

  @override
  Future<void> setLastSyncTime(DateTime time) async {
    lastSyncTime = time;
  }

  @override
  Future<String?> getLastSyncStatus() async => lastSyncStatus;

  @override
  Future<void> setLastSyncStatus(String status) async {
    lastSyncStatus = status;
  }
}

void main() {
  group('CurrencyBloc Tests', () {
    late FakeCurrencyRepository currencyRepository;
    late FakeSettingsRepository settingsRepository;
    late CurrencyBloc currencyBloc;

    setUp(() {
      currencyRepository = FakeCurrencyRepository();
      settingsRepository = FakeSettingsRepository();
      currencyBloc = CurrencyBloc(
        currencyRepository: currencyRepository,
        settingsRepository: settingsRepository,
      );
    });

    tearDown(() {
      currencyBloc.close();
    });

    test('initial state is CurrencyInitial', () {
      expect(currencyBloc.state, isA<CurrencyInitial>());
    });

    test('InitGlobalCurrencyEvent emits CurrencyLoading then CurrencyLoaded', () async {
      final expected = [
        isA<CurrencyLoading>(),
        isA<CurrencyLoaded>()
            .having((s) => s.globalCurrency, 'globalCurrency', 'USD')
            .having((s) => s.availableCurrencies, 'availableCurrencies', ['USD', 'EUR', 'INR'])
            .having((s) => s.ratesMap['EUR'], 'EUR rate', 0.9),
      ];

      final future = expectLater(currencyBloc.stream, emitsInOrder(expected));
      currencyBloc.add(const InitGlobalCurrencyEvent());
      await future;
    });

    test('SetGlobalCurrencyEvent updates global currency and emits CurrencyLoaded', () async {
      final expected = [
        isA<CurrencyLoading>(),
        isA<CurrencyLoaded>()
            .having((s) => s.globalCurrency, 'globalCurrency', 'EUR'),
      ];

      final future = expectLater(currencyBloc.stream, emitsInOrder(expected));
      currencyBloc.add(const SetGlobalCurrencyEvent('EUR'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(await settingsRepository.getGlobalCurrency(), 'EUR');
      await future;
    });

    test('ConvertCurrencyEvent emits CurrencyLoading then CurrencyLoaded with convertedAmount', () async {
      final expected = [
        isA<CurrencyLoading>(),
        isA<CurrencyLoaded>()
            .having((s) => s.convertedAmount, 'convertedAmount', 90.0),
      ];

      final future = expectLater(currencyBloc.stream, emitsInOrder(expected));
      currencyBloc.add(const ConvertCurrencyEvent(
        amount: 100,
        fromCurrency: 'USD',
        toCurrency: 'EUR',
      ));
      await future;
    });
  });
}
