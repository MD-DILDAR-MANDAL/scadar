import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scadar/core/repositories/settings_repository.dart';
import 'package:scadar/core/services/backup_sync_service.dart';
import 'package:scadar/core/services/google_drive_service.dart';
import 'package:scadar/features/backup/bloc/backup_event.dart';
import 'package:scadar/features/backup/bloc/backup_state.dart';

class BackupBloc extends Bloc<BackupEvent, BackupState> {
  final GoogleDriveService _googleDriveService;
  final BackupSyncService _backupSyncService;
  final SettingsRepository _settingsRepository;

  BackupBloc({
    required GoogleDriveService googleDriveService,
    required BackupSyncService backupSyncService,
    required SettingsRepository settingsRepository,
  })  : _googleDriveService = googleDriveService,
        _backupSyncService = backupSyncService,
        _settingsRepository = settingsRepository,
        super(const BackupState()) {
    on<InitBackupEvent>(_onInitBackup);
    on<GoogleSignInEvent>(_onGoogleSignIn);
    on<GoogleSignOutEvent>(_onGoogleSignOut);
    on<ToggleAutoSyncEvent>(_onToggleAutoSync);
    on<SyncNowEvent>(_onSyncNow);
    on<RestoreNowEvent>(_onRestoreNow);
    on<ClearBackupMessagesEvent>(_onClearMessages);
  }

  Future<void> _onInitBackup(
    InitBackupEvent event,
    Emitter<BackupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      final autoSync = await _settingsRepository.isAutoSyncEnabled();
      final lastTime = await _settingsRepository.getLastSyncTime();
      final lastStatus = await _settingsRepository.getLastSyncStatus();

      final account = await _googleDriveService.signInSilently();
      RemoteBackupInfo? remoteInfo;

      if (account != null) {
        remoteInfo = await _backupSyncService.getRemoteBackupInfo();
      }

      emit(state.copyWith(
        isLoading: false,
        isAuthenticated: account != null,
        userEmail: account?.email,
        displayName: account?.displayName,
        photoUrl: account?.photoUrl,
        isAutoSyncEnabled: autoSync,
        lastSyncTime: lastTime,
        lastSyncStatus: lastStatus,
        remoteBackupInfo: remoteInfo,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to initialize backup settings: $e',
      ));
    }
  }

  Future<void> _onGoogleSignIn(
    GoogleSignInEvent event,
    Emitter<BackupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      final account = await _googleDriveService.signIn();
      if (account != null) {
        final remoteInfo = await _backupSyncService.getRemoteBackupInfo();
        emit(state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userEmail: account.email,
          displayName: account.displayName,
          photoUrl: account.photoUrl,
          remoteBackupInfo: remoteInfo,
          successMessage: 'Connected as ${account.email}',
        ));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Sign-in failed: $e',
      ));
    }
  }

  Future<void> _onGoogleSignOut(
    GoogleSignOutEvent event,
    Emitter<BackupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      await _googleDriveService.signOut();
      emit(state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        clearUser: true,
        clearRemoteInfo: true,
        successMessage: 'Signed out from Google Account',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Sign-out failed: $e',
      ));
    }
  }

  Future<void> _onToggleAutoSync(
    ToggleAutoSyncEvent event,
    Emitter<BackupState> emit,
  ) async {
    await _settingsRepository.setAutoSyncEnabled(event.enabled);
    emit(state.copyWith(isAutoSyncEnabled: event.enabled, clearError: true, clearSuccess: true));

    if (event.enabled && state.isAuthenticated) {
      add(const SyncNowEvent());
    }
  }

  Future<void> _onSyncNow(
    SyncNowEvent event,
    Emitter<BackupState> emit,
  ) async {
    if (!state.isAuthenticated) {
      emit(state.copyWith(errorMessage: 'Please sign in to Google Drive first.'));
      return;
    }

    emit(state.copyWith(isSyncing: true, clearError: true, clearSuccess: true));
    try {
      await _backupSyncService.syncToGoogleDrive();
      final lastTime = await _settingsRepository.getLastSyncTime();
      final remoteInfo = await _backupSyncService.getRemoteBackupInfo();

      emit(state.copyWith(
        isSyncing: false,
        lastSyncTime: lastTime,
        lastSyncStatus: 'Success',
        remoteBackupInfo: remoteInfo,
        successMessage: 'Data backed up successfully to Google Drive!',
      ));
    } catch (e) {
      emit(state.copyWith(
        isSyncing: false,
        errorMessage: 'Backup failed: $e',
      ));
    }
  }

  Future<void> _onRestoreNow(
    RestoreNowEvent event,
    Emitter<BackupState> emit,
  ) async {
    if (!state.isAuthenticated) {
      emit(state.copyWith(errorMessage: 'Please sign in to Google Drive first.'));
      return;
    }

    emit(state.copyWith(isRestoring: true, clearError: true, clearSuccess: true));
    try {
      final result = await _backupSyncService.restoreFromGoogleDrive();
      final lastTime = await _settingsRepository.getLastSyncTime();

      emit(state.copyWith(
        isRestoring: false,
        lastSyncTime: lastTime,
        successMessage: 'Restored ${result['expensesCount']} expenses, ${result['incomesCount']} incomes, ${result['budgetsCount']} budgets successfully!',
      ));
    } catch (e) {
      emit(state.copyWith(
        isRestoring: false,
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
