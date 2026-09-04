import 'dart:convert';
import 'package:scadar/core/cache/isar_service.dart';
import 'package:scadar/core/cache/models/budget_model.dart';
import 'package:scadar/core/cache/models/expense_model.dart';
import 'package:scadar/core/cache/models/income_model.dart';
import 'package:scadar/core/cache/models/recurring_transaction_model.dart';
import 'package:scadar/core/repository/settings_repository.dart';
import 'package:scadar/core/services/google_drive_service.dart';

class RemoteBackupInfo {
  final String? fileId;
  final String? fileName;
  final DateTime? modifiedTime;
  final int? sizeInBytes;

  const RemoteBackupInfo({
    this.fileId,
    this.fileName,
    this.modifiedTime,
    this.sizeInBytes,
  });
}

class BackupSyncService {
  static const String backupFileName = 'scadar_backup.json';

  final IsarService _isarService;
  final GoogleDriveService _googleDriveService;
  final SettingsRepository _settingsRepository;

  BackupSyncService({
    required IsarService isarService,
    required GoogleDriveService googleDriveService,
    required SettingsRepository settingsRepository,
  })  : _isarService = isarService,
        _googleDriveService = googleDriveService,
        _settingsRepository = settingsRepository;

  Future<String> createBackupJson() async {
    final expenses = await _isarService.getAllExpenses();
    final incomes = await _isarService.getAllIncomes();
    final budgets = await _isarService.getAllBudgets();
    final recurring = await _isarService.getAllRecurringTransactions();
    final globalCurrency = await _settingsRepository.getGlobalCurrency();

    final payload = {
      'version': 1,
      'app': 'scadar',
      'exportedAt': DateTime.now().toIso8601String(),
      'globalCurrency': globalCurrency,
      'counts': {
        'expenses': expenses.length,
        'incomes': incomes.length,
        'budgets': budgets.length,
        'recurring': recurring.length,
      },
      'expenses': expenses.map((e) => e.toJson()).toList(),
      'incomes': incomes.map((i) => i.toJson()).toList(),
      'budgets': budgets.map((b) => b.toJson()).toList(),
      'recurring': recurring.map((r) => r.toJson()).toList(),
    };

    return jsonEncode(payload);
  }

  Future<void> syncToGoogleDrive() async {
    try {
      final jsonString = await createBackupJson();
      await _googleDriveService.uploadAppDataFile(
        fileName: backupFileName,
        content: jsonString,
      );
      final now = DateTime.now();
      await _settingsRepository.setLastSyncTime(now);
      await _settingsRepository.setLastSyncStatus('Success');
    } catch (e) {
      await _settingsRepository.setLastSyncStatus('Failed: $e');
      rethrow;
    }
  }

  Future<bool> performAutoSyncIfEnabled() async {
    try {
      final isEnabled = await _settingsRepository.isAutoSyncEnabled();
      if (!isEnabled) return false;

      // Attempt silent sign-in if not already signed in
      if (!_googleDriveService.isSignedIn) {
        final account = await _googleDriveService.signInSilently();
        if (account == null) return false;
      }

      await syncToGoogleDrive();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<RemoteBackupInfo?> getRemoteBackupInfo() async {
    try {
      final file = await _googleDriveService.getAppDataFileInfo(backupFileName);
      if (file == null) return null;

      return RemoteBackupInfo(
        fileId: file.id,
        fileName: file.name,
        modifiedTime: file.modifiedTime,
        sizeInBytes: file.size != null ? int.tryParse(file.size!) : null,
      );
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> restoreFromGoogleDrive() async {
    final jsonString = await _googleDriveService.downloadAppDataFile(backupFileName);
    if (jsonString == null) {
      throw Exception('No remote backup found on Google Drive.');
    }

    final dynamic data = jsonDecode(jsonString);
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid backup format received from Google Drive.');
    }

    final rawExpenses = data['expenses'] as List<dynamic>? ?? [];
    final rawIncomes = data['incomes'] as List<dynamic>? ?? [];
    final rawBudgets = data['budgets'] as List<dynamic>? ?? [];
    final rawRecurring = data['recurring'] as List<dynamic>? ?? [];

    final expenses = rawExpenses
        .map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final incomes = rawIncomes
        .map((i) => IncomeModel.fromJson(i as Map<String, dynamic>))
        .toList();
    final budgets = rawBudgets
        .map((b) => BudgetModel.fromJson(b as Map<String, dynamic>))
        .toList();
    final recurring = rawRecurring
        .map((r) => RecurringTransactionModel.fromJson(r as Map<String, dynamic>))
        .toList();

    await _isarService.clearAndRestoreAllData(
      expenses: expenses,
      incomes: incomes,
      budgets: budgets,
      recurring: recurring,
    );

    if (data.containsKey('globalCurrency') && data['globalCurrency'] is String) {
      await _settingsRepository.saveGlobalCurrency(data['globalCurrency'] as String);
    }

    return {
      'expensesCount': expenses.length,
      'incomesCount': incomes.length,
      'budgetsCount': budgets.length,
      'recurringCount': recurring.length,
      'exportedAt': data['exportedAt'],
    };
  }
}
