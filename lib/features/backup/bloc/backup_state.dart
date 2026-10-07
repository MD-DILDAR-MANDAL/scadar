import 'package:equatable/equatable.dart';

class BackupState extends Equatable {
  final bool isLoading;
  final bool isExporting;
  final bool isImporting;
  bool get isRestoring => isImporting;
  final DateTime? lastBackupTime;
  final String? lastBackupStatus;
  final String? errorMessage;
  final String? successMessage;

  const BackupState({
    this.isLoading = false,
    this.isExporting = false,
    this.isImporting = false,
    this.lastBackupTime,
    this.lastBackupStatus,
    this.errorMessage,
    this.successMessage,
  });

  BackupState copyWith({
    bool? isLoading,
    bool? isExporting,
    bool? isImporting,
    DateTime? lastBackupTime,
    String? lastBackupStatus,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return BackupState(
      isLoading: isLoading ?? this.isLoading,
      isExporting: isExporting ?? this.isExporting,
      isImporting: isImporting ?? this.isImporting,
      lastBackupTime: lastBackupTime ?? this.lastBackupTime,
      lastBackupStatus: lastBackupStatus ?? this.lastBackupStatus,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isExporting,
        isImporting,
        lastBackupTime,
        lastBackupStatus,
        errorMessage,
        successMessage,
      ];
}
