import 'package:equatable/equatable.dart';

abstract class BackupEvent extends Equatable {
  const BackupEvent();

  @override
  List<Object?> get props => [];
}

class InitBackupEvent extends BackupEvent {
  const InitBackupEvent();
}

class ExportBackupEvent extends BackupEvent {
  const ExportBackupEvent();
}

class ImportBackupEvent extends BackupEvent {
  const ImportBackupEvent();
}

class ClearBackupMessagesEvent extends BackupEvent {
  const ClearBackupMessagesEvent();
}
