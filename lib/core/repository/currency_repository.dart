import 'package:scadar/core/utils/currency_converter_service.dart';

abstract class CurrencyRepository {
  Future<double> convert({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  });
  Future<List<String>> getAvailableCurrencies();
}

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyConverterService _converterService;

  CurrencyRepositoryImpl({required CurrencyConverterService converterService})
      : _converterService = converterService;

  @override
  Future<double> convert({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    return _converterService.convert(
      amount: amount,
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
    );
  }

  @override
  Future<List<String>> getAvailableCurrencies() async {
    return _converterService.getAvailableCurrencies();
  }
}
