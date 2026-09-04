import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsRepository {
  Future<String> getGlobalCurrency();
  Future<void> saveGlobalCurrency(String currency);
  Future<bool> isAutoSyncEnabled();
  Future<void> setAutoSyncEnabled(bool enabled);
  Future<DateTime?> getLastSyncTime();
  Future<void> setLastSyncTime(DateTime time);
  Future<String?> getLastSyncStatus();
  Future<void> setLastSyncStatus(String status);
}

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;
  static const _globalCurrencyKey = 'global_currency_key';
  static const _autoSyncKey = 'auto_sync_google_drive_key';
  static const _lastSyncTimeKey = 'last_sync_time_key';
  static const _lastSyncStatusKey = 'last_sync_status_key';

  SettingsRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<String> getGlobalCurrency() async {
    return _prefs.getString(_globalCurrencyKey) ?? 'USD';
  }

  @override
  Future<void> saveGlobalCurrency(String currency) async {
    await _prefs.setString(_globalCurrencyKey, currency);
  }

  @override
  Future<bool> isAutoSyncEnabled() async {
    return _prefs.getBool(_autoSyncKey) ?? false;
  }

  @override
  Future<void> setAutoSyncEnabled(bool enabled) async {
    await _prefs.setBool(_autoSyncKey, enabled);
  }

  @override
  Future<DateTime?> getLastSyncTime() async {
    final iso = _prefs.getString(_lastSyncTimeKey);
    if (iso == null) return null;
    return DateTime.tryParse(iso);
  }

  @override
  Future<void> setLastSyncTime(DateTime time) async {
    await _prefs.setString(_lastSyncTimeKey, time.toIso8601String());
  }

  @override
  Future<String?> getLastSyncStatus() async {
    return _prefs.getString(_lastSyncStatusKey);
  }

  @override
  Future<void> setLastSyncStatus(String status) async {
    await _prefs.setString(_lastSyncStatusKey, status);
  }
}
