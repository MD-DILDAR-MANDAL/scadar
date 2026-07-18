import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsRepository {
  Future<String> getGlobalCurrency();
  Future<void> saveGlobalCurrency(String currency);
}

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;
  static const _globalCurrencyKey = 'global_currency_key';

  SettingsRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<String> getGlobalCurrency() async {
    return _prefs.getString(_globalCurrencyKey) ?? 'USD';
  }

  @override
  Future<void> saveGlobalCurrency(String currency) async {
    await _prefs.setString(_globalCurrencyKey, currency);
  }
}
