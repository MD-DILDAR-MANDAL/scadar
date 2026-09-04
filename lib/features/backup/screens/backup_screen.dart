import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scadar/core/constants/app_colors.dart';
import 'package:scadar/core/widgets/custom_button.dart';
import 'package:scadar/core/widgets/custom_card.dart';
import 'package:scadar/core/widgets/section_title.dart';
import 'package:scadar/features/backup/bloc/backup_bloc.dart';
import 'package:scadar/features/backup/bloc/backup_event.dart';
import 'package:scadar/features/backup/bloc/backup_state.dart';
import 'package:scadar/features/currency/bloc/currency_bloc.dart';
import 'package:scadar/features/currency/bloc/currency_event.dart';
import 'package:scadar/features/finance/bloc/finance_bloc.dart';
import 'package:scadar/features/finance/bloc/finance_event.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BackupBloc>().add(const InitBackupEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Backup & Cloud Sync',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<BackupBloc, BackupState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
              ),
            );
            context.read<BackupBloc>().add(const ClearBackupMessagesEvent());
          }
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: AppColors.success,
              ),
            );
            // Refresh data in CurrencyBloc and FinanceBloc
            final now = DateTime.now();
            context.read<CurrencyBloc>().add(const InitGlobalCurrencyEvent());
            context.read<FinanceBloc>().add(
                  LoadFinanceData(month: now.month, year: now.year),
                );
            context.read<BackupBloc>().add(const ClearBackupMessagesEvent());
          }
        },
        builder: (context, state) {
          if (state.isLoading && !state.isSyncing && !state.isRestoring) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAccountCard(context, state),
                const SizedBox(height: 16),
                _buildAutoSyncCard(context, state),
                const SizedBox(height: 16),
                _buildCloudStatusCard(context, state),
                const SizedBox(height: 16),
                _buildActionsCard(context, state),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, BackupState state) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Google Drive Account'),
          const SizedBox(height: 12),
          if (state.isAuthenticated) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary,
                  backgroundImage: state.photoUrl != null
                      ? NetworkImage(state.photoUrl!)
                      : null,
                  child: state.photoUrl == null
                      ? Text(
                          (state.displayName?.isNotEmpty == true
                                  ? state.displayName![0]
                                  : state.userEmail?.isNotEmpty == true
                                      ? state.userEmail![0]
                                      : 'G')
                              .toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.tertiary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.displayName ?? 'Google User',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        state.userEmail ?? '',
                        style: TextStyle(
                          color: AppColors.primary.withValues(alpha: 0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => context.read<BackupBloc>().add(const GoogleSignOutEvent()),
              icon: const Icon(Icons.logout, color: AppColors.error, size: 18),
              label: const Text(
                'Disconnect Account',
                style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ] else ...[
            Text(
              'Sign in to your Google Account to enable automatic cloud backups and data restore across devices.',
              style: TextStyle(
                color: AppColors.primary.withValues(alpha: 0.8),
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              onPressed: () => context.read<BackupBloc>().add(const GoogleSignInEvent()),
              text: 'Sign In with Google',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAutoSyncCard(BuildContext context, BackupState state) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle('Automatic Cloud Sync'),
                    SizedBox(height: 4),
                    Text(
                      'Silently sync your expenses and incomes to Google Drive when the app is minimized or modified.',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: state.isAutoSyncEnabled,
                activeThumbColor: AppColors.primary,
                activeTrackColor: AppColors.tertiary,
                inactiveThumbColor: AppColors.tertiary,
                inactiveTrackColor: AppColors.dark,
                onChanged: (value) {
                  if (!state.isAuthenticated && value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please sign in to Google Drive first.'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                    return;
                  }
                  context.read<BackupBloc>().add(ToggleAutoSyncEvent(value));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCloudStatusCard(BuildContext context, BackupState state) {
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');
    final lastSyncString = state.lastSyncTime != null
        ? dateFormat.format(state.lastSyncTime!)
        : 'Never';

    final remoteInfo = state.remoteBackupInfo;
    final remoteModifiedString = remoteInfo?.modifiedTime != null
        ? dateFormat.format(remoteInfo!.modifiedTime!)
        : 'No backup found on Drive';

    final sizeString = remoteInfo?.sizeInBytes != null
        ? '${(remoteInfo!.sizeInBytes! / 1024).toStringAsFixed(1)} KB'
        : 'N/A';

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Cloud Backup Status'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.sync, 'Last Local Sync', lastSyncString),
          const Divider(color: AppColors.primary, height: 20),
          _buildInfoRow(Icons.cloud_done_outlined, 'Drive File Modified', remoteModifiedString),
          const Divider(color: AppColors.primary, height: 20),
          _buildInfoRow(Icons.data_usage_outlined, 'Backup Size', sizeString),
          const Divider(color: AppColors.primary, height: 20),
          _buildInfoRow(Icons.lock_outline, 'Privacy', 'Stored in private AppData folder'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.primary.withValues(alpha: 0.8),
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionsCard(BuildContext context, BackupState state) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Backup & Restore Actions'),
          const SizedBox(height: 16),
          if (state.isSyncing) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Backing up data to Google Drive...',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            CustomButton(
              onPressed: state.isAuthenticated
                  ? () => context.read<BackupBloc>().add(const SyncNowEvent())
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please sign in to Google Drive first.'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    },
              text: 'Back Up Now',
            ),
          ],
          const SizedBox(height: 12),
          if (state.isRestoring) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Restoring data from Google Drive...',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            OutlinedButton(
              onPressed: state.isAuthenticated
                  ? () => _showRestoreConfirmation(context)
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please sign in to Google Drive first.'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Restore from Google Drive',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showRestoreConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.tertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          title: const Text(
            'Restore Backup?',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Restoring will replace all current local entries with the latest backup saved on your Google Drive. Are you sure you want to proceed?',
            style: TextStyle(color: AppColors.primary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<BackupBloc>().add(const RestoreNowEvent());
              },
              child: const Text('Restore'),
            ),
          ],
        );
      },
    );
  }
}
