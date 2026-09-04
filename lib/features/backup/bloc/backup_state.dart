import 'package:equatable/equatable.dart';
import 'package:scadar/core/services/backup_sync_service.dart';

class BackupState extends Equatable {
  final bool isAuthenticated;
  final String? userEmail;
  final String? displayName;
  final String? photoUrl;
  final bool isAutoSyncEnabled;
  final DateTime? lastSyncTime;
  final String? lastSyncStatus;
  final RemoteBackupInfo? remoteBackupInfo;
  final bool isLoading;
  final bool isSyncing;
  final bool isRestoring;
  final String? errorMessage;
  final String? successMessage;

  const BackupState({
    this.isAuthenticated = false,
    this.userEmail,
    this.displayName,
    this.photoUrl,
    this.isAutoSyncEnabled = false,
    this.lastSyncTime,
    this.lastSyncStatus,
    this.remoteBackupInfo,
    this.isLoading = false,
    this.isSyncing = false,
    this.isRestoring = false,
    this.errorMessage,
    this.successMessage,
  });

  BackupState copyWith({
    bool? isAuthenticated,
    String? userEmail,
    String? displayName,
    String? photoUrl,
    bool? isAutoSyncEnabled,
    DateTime? lastSyncTime,
    String? lastSyncStatus,
    RemoteBackupInfo? remoteBackupInfo,
    bool? isLoading,
    bool? isSyncing,
    bool? isRestoring,
    String? errorMessage,
    String? successMessage,
    bool clearUser = false,
    bool clearRemoteInfo = false,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return BackupState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userEmail: clearUser ? null : (userEmail ?? this.userEmail),
      displayName: clearUser ? null : (displayName ?? this.displayName),
      photoUrl: clearUser ? null : (photoUrl ?? this.photoUrl),
      isAutoSyncEnabled: isAutoSyncEnabled ?? this.isAutoSyncEnabled,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      lastSyncStatus: lastSyncStatus ?? this.lastSyncStatus,
      remoteBackupInfo: clearRemoteInfo ? null : (remoteBackupInfo ?? this.remoteBackupInfo),
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      isRestoring: isRestoring ?? this.isRestoring,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        isAuthenticated,
        userEmail,
        displayName,
        photoUrl,
        isAutoSyncEnabled,
        lastSyncTime,
        lastSyncStatus,
        remoteBackupInfo,
        isLoading,
        isSyncing,
        isRestoring,
        errorMessage,
        successMessage,
      ];
}
