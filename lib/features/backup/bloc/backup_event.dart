import 'package:equatable/equatable.dart';

abstract class BackupEvent extends Equatable {
  const BackupEvent();

  @override
  List<Object?> get props => [];
}

class InitBackupEvent extends BackupEvent {
  const InitBackupEvent();
}

class GoogleSignInEvent extends BackupEvent {
  const GoogleSignInEvent();
}

class GoogleSignOutEvent extends BackupEvent {
  const GoogleSignOutEvent();
}

class ToggleAutoSyncEvent extends BackupEvent {
  final bool enabled;

  const ToggleAutoSyncEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class SyncNowEvent extends BackupEvent {
  const SyncNowEvent();
}

class RestoreNowEvent extends BackupEvent {
  const RestoreNowEvent();
}

class ClearBackupMessagesEvent extends BackupEvent {
  const ClearBackupMessagesEvent();
}
