import 'package:dio/dio.dart';

class CurrencyConverterService {
  final Dio _dio;
  
  CurrencyConverterService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'https://api.frankfurter.app'));

  Future<double> convert({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    if (fromCurrency == toCurrency) return amount;

    try {
      final response = await _dio.get<Map<String, dynamic>>('/latest', queryParameters: {
        'amount': amount,
        'from': fromCurrency,
        'to': toCurrency,
      });

      if (response.statusCode == 200 && response.data != null) {
        final rates = response.data!['rates'] as Map<String, dynamic>;
        if (rates.containsKey(toCurrency)) {
          return (rates[toCurrency] as num).toDouble();
        }
      }
      throw Exception('Failed to get conversion rate');
    } catch (e) {
      throw Exception('Error converting currency: $e');
    }
  }

  Future<List<String>> getAvailableCurrencies() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/currencies');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!;
        return data.keys.toList();
      }
      return ['USD', 'EUR', 'GBP', 'INR', 'JPY', 'CAD', 'AUD']; // Fallback
    } catch (e) {
      return ['USD', 'EUR', 'GBP', 'INR', 'JPY', 'CAD', 'AUD']; // Fallback
    }
  }

  Future<Map<String, double>> fetchRatesForBase(String baseCurrency) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/latest', queryParameters: {
        'from': baseCurrency,
      });

      if (response.statusCode == 200 && response.data != null) {
        final rates = response.data!['rates'] as Map<String, dynamic>;
        return rates.map((key, value) => MapEntry(key, (value as num).toDouble()));
      }
      throw Exception('Failed to fetch rates');
    } catch (e) {
      throw Exception('Error fetching rates for base $baseCurrency: $e');
    }
  }
}
