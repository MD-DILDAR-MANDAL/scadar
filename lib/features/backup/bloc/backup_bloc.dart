import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scadar/core/repositories/settings_repository.dart';
import 'package:scadar/core/services/backup_sync_service.dart';
import 'package:scadar/features/backup/bloc/backup_event.dart';
import 'package:scadar/features/backup/bloc/backup_state.dart';

class BackupBloc extends Bloc<BackupEvent, BackupState> {
  final BackupSyncService _backupSyncService;
  final SettingsRepository _settingsRepository;

  BackupBloc({
    required BackupSyncService backupSyncService,
    required SettingsRepository settingsRepository,
  })  : _backupSyncService = backupSyncService,
        _settingsRepository = settingsRepository,
        super(const BackupState()) {
    on<InitBackupEvent>(_onInitBackup);
    on<ExportBackupEvent>(_onExportBackup);
    on<ImportBackupEvent>(_onImportBackup);
    on<ClearBackupMessagesEvent>(_onClearMessages);
  }

  Future<void> _onInitBackup(
    InitBackupEvent event,
    Emitter<BackupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      final lastTime = await _settingsRepository.getLastSyncTime();
      final lastStatus = await _settingsRepository.getLastSyncStatus();

      emit(state.copyWith(
        isLoading: false,
        lastBackupTime: lastTime,
        lastBackupStatus: lastStatus,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to initialize backup settings: $e',
      ));
    }
  }

  Future<void> _onExportBackup(
    ExportBackupEvent event,
    Emitter<BackupState> emit,
  ) async {
    emit(state.copyWith(isExporting: true, clearError: true, clearSuccess: true));
    try {
      final result = await _backupSyncService.exportBackupToFile();
      final lastTime = await _settingsRepository.getLastSyncTime();
      final lastStatus = await _settingsRepository.getLastSyncStatus();

      if (result.success) {
        emit(state.copyWith(
          isExporting: false,
          lastBackupTime: lastTime,
          lastBackupStatus: lastStatus,
          successMessage: result.message ?? 'Backup exported successfully!',
        ));
      } else {
        emit(state.copyWith(
          isExporting: false,
          errorMessage: result.message ?? 'Export cancelled or failed.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isExporting: false,
        errorMessage: 'Backup export failed: $e',
      ));
    }
  }

  Future<void> _onImportBackup(
    ImportBackupEvent event,
    Emitter<BackupState> emit,
  ) async {
    emit(state.copyWith(isImporting: true, clearError: true, clearSuccess: true));
    try {
      final result = await _backupSyncService.importBackupFromFile();
      final lastTime = await _settingsRepository.getLastSyncTime();
      final lastStatus = await _settingsRepository.getLastSyncStatus();

      if (result.success) {
        emit(state.copyWith(
          isImporting: false,
          lastBackupTime: lastTime,
          lastBackupStatus: lastStatus,
          successMessage:
              'Restored ${result.expensesCount} expenses, ${result.incomesCount} incomes, ${result.budgetsCount} budgets, and ${result.recurringCount} recurring transactions!',
        ));
      } else {
        emit(state.copyWith(
          isImporting: false,
          errorMessage: result.message ?? 'Import cancelled or failed.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isImporting: false,
        errorMessage: 'Restore failed: $e',
      ));
    }
  }

  void _onClearMessages(
    ClearBackupMessagesEvent event,
    Emitter<BackupState> emit,
  ) {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }
}
