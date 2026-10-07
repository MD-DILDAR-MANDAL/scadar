import 'dart:convert';
import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scadar/core/database/database_service.dart';
import 'package:scadar/core/database/models/budget_model.dart';
import 'package:scadar/core/database/models/expense_model.dart';
import 'package:scadar/core/database/models/income_model.dart';
import 'package:scadar/core/database/models/recurring_transaction_model.dart';
import 'package:scadar/core/repositories/settings_repository.dart';

class BackupResult {
  final bool success;
  final String? message;
  final int expensesCount;
  final int incomesCount;
  final int budgetsCount;
  final int recurringCount;

  const BackupResult({
    required this.success,
    this.message,
    this.expensesCount = 0,
    this.incomesCount = 0,
    this.budgetsCount = 0,
    this.recurringCount = 0,
  });
}

class BackupSyncService {
  final DatabaseService _databaseService;
  final SettingsRepository _settingsRepository;

  BackupSyncService({
    required DatabaseService databaseService,
    required SettingsRepository settingsRepository,
  })  : _databaseService = databaseService,
        _settingsRepository = settingsRepository;

  Future<String> createBackupJson() async {
    final expenses = await _databaseService.getAllExpenses();
    final incomes = await _databaseService.getAllIncomes();
    final budgets = await _databaseService.getAllBudgets();
    final recurring = await _databaseService.getAllRecurringTransactions();
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

  Future<BackupResult> exportBackupToFile() async {
    try {
      final jsonString = await createBackupJson();
      final dateStr = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'scadar_backup_$dateStr.json';

      String? savedPath;

      if (Platform.isAndroid || Platform.isIOS) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsString(jsonString);

        final params = SaveFileDialogParams(
          sourceFilePath: tempFile.path,
          fileName: fileName,
        );
        savedPath = await FlutterFileDialog.saveFile(params: params);
      } else {
        final location = await getSaveLocation(suggestedName: fileName);
        if (location != null) {
          final file = File(location.path);
          await file.writeAsString(jsonString);
          savedPath = file.path;
        }
      }

      if (savedPath != null) {
        final now = DateTime.now();
        await _settingsRepository.setLastSyncTime(now);
        await _settingsRepository.setLastSyncStatus('Exported successfully');
        return const BackupResult(
          success: true,
          message: 'Backup exported successfully',
        );
      } else {
        return const BackupResult(
          success: false,
          message: 'Export was cancelled',
        );
      }
    } catch (e) {
      await _settingsRepository.setLastSyncStatus('Export failed: $e');
      return BackupResult(
        success: false,
        message: 'Failed to export backup: $e',
      );
    }
  }

  Future<BackupResult> restoreFromJson(String jsonString) async {
    final Map<String, dynamic> data = jsonDecode(jsonString) as Map<String, dynamic>;

    if (data['app'] != 'scadar') {
      throw const FormatException('Invalid Scadar backup format');
    }

    final rawExpenses = (data['expenses'] as List<dynamic>?) ?? [];
    final rawIncomes = (data['incomes'] as List<dynamic>?) ?? [];
    final rawBudgets = (data['budgets'] as List<dynamic>?) ?? [];
    final rawRecurring = (data['recurring'] as List<dynamic>?) ?? [];

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

    await _databaseService.clearAndRestoreAllData(
      expenses: expenses,
      incomes: incomes,
      budgets: budgets,
      recurring: recurring,
    );

    final currency = data['globalCurrency'] as String?;
    if (currency != null && currency.isNotEmpty) {
      await _settingsRepository.saveGlobalCurrency(currency);
    }

    final now = DateTime.now();
    await _settingsRepository.setLastSyncTime(now);
    await _settingsRepository.setLastSyncStatus('Restored successfully');

    return BackupResult(
      success: true,
      message: 'Restored successfully',
      expensesCount: expenses.length,
      incomesCount: incomes.length,
      budgetsCount: budgets.length,
      recurringCount: recurring.length,
    );
  }

  Future<BackupResult> importBackupFromFile() async {
    try {
      String? jsonContent;

      if (Platform.isAndroid || Platform.isIOS) {
        const params = OpenFileDialogParams();
        final filePath = await FlutterFileDialog.pickFile(params: params);
        if (filePath == null) {
          return const BackupResult(
            success: false,
            message: 'No file selected',
          );
        }
        final file = File(filePath);
        jsonContent = await file.readAsString();
      } else {
        const typeGroup = XTypeGroup(
          label: 'JSON backup files',
          extensions: ['json'],
        );
        final file = await openFile(acceptedTypeGroups: [typeGroup]);
        if (file == null) {
          return const BackupResult(
            success: false,
            message: 'No file selected',
          );
        }
        jsonContent = await file.readAsString();
      }

      if (jsonContent.isEmpty) {
        return const BackupResult(
          success: false,
          message: 'Selected file is empty',
        );
      }

      return await restoreFromJson(jsonContent);
    } catch (e) {
      await _settingsRepository.setLastSyncStatus('Restore failed: $e');
      return BackupResult(
        success: false,
        message: 'Failed to restore backup: $e',
      );
    }
  }

  Future<DateTime?> getLastBackupTime() => _settingsRepository.getLastSyncTime();
  Future<String?> getLastBackupStatus() => _settingsRepository.getLastSyncStatus();
}
