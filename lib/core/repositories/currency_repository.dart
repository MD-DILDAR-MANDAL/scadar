import 'dart:convert';
import 'package:isar_community/isar.dart';
import 'package:scadar/core/database/isar_service.dart';
import 'package:scadar/core/database/models/exchange_rate_cache_model.dart';
import 'package:scadar/core/services/currency_converter_service.dart';

abstract class CurrencyRepository {
  Future<double> convert({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  });
  Future<List<String>> getAvailableCurrencies();
  Future<Map<String, double>> fetchRatesForBase(String baseCurrency);
}

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyConverterService _converterService;
  final IsarService _isarService;

  CurrencyRepositoryImpl({
    required CurrencyConverterService converterService,
    required IsarService isarService,
  })  : _converterService = converterService,
        _isarService = isarService;

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

  @override
  Future<Map<String, double>> fetchRatesForBase(String baseCurrency) async {
    final cached = await _isarService.getExchangeRateCache(baseCurrency);
    if (cached != null && DateTime.now().difference(cached.lastUpdated).inMinutes < 5) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(cached.ratesJson) as Map<String, dynamic>;
        return decoded.map((key, value) => MapEntry(key, (value as num).toDouble()));
      } catch (_) {
        // ignore JSON errors and fetch again
      }
    }

    // Fetch new rates
    final newRates = await _converterService.fetchRatesForBase(baseCurrency);
    
    // Save to cache silently
    try {
      final cacheModel = ExchangeRateCacheModel()
        ..baseCurrency = baseCurrency
        ..ratesJson = jsonEncode(newRates)
        ..lastUpdated = DateTime.now();
        
      if (cached != null) {
        cacheModel.id = cached.id;
      } else {
        cacheModel.id = Isar.autoIncrement;
      }
      
      await _isarService.saveExchangeRateCache(cacheModel);
    } catch (_) {
      // Silently ignore cache save errors
    }

    return newRates;
  }
}
