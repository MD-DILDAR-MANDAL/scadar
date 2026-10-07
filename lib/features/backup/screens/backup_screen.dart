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
          'Backup & Restore',
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
          if (state.isLoading && !state.isExporting && !state.isImporting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPrivacyCard(context),
                const SizedBox(height: 16),
                _buildStatusCard(context, state),
                const SizedBox(height: 16),
                _buildActionsCard(context, state),
                const SizedBox(height: 16),
                _buildBackupContentsCard(context),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrivacyCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.shield_outlined, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: SectionTitle('100% Offline & Private'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Your financial data is stored securely on your local device. '
            'You can create complete offline JSON backups and save them anywhere '
            '(SD card, Nextcloud, Syncthing, or local folders) to keep full ownership of your data.',
            style: TextStyle(
              color: AppColors.primary.withValues(alpha: 0.8),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, BackupState state) {
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');
    final formattedDate = state.lastBackupTime != null
        ? dateFormat.format(state.lastBackupTime!)
        : 'Never';

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Backup Status'),
          const SizedBox(height: 12),
          _buildInfoRow('Last Operation:', formattedDate),
          const SizedBox(height: 8),
          _buildInfoRow('Status:', state.lastBackupStatus ?? 'No prior backup record'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.primary.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
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
          const SectionTitle('Backup Actions'),
          const SizedBox(height: 16),
          if (state.isExporting) ...[
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
                      'Exporting backup file...',
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
              onPressed: () =>
                  context.read<BackupBloc>().add(const ExportBackupEvent()),
              text: 'Export Backup to File',
            ),
          ],
          const SizedBox(height: 12),
          if (state.isImporting) ...[
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
                      'Restoring data from file...',
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
              onPressed: () => _showRestoreConfirmation(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Restore from Backup File',
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

  Widget _buildBackupContentsCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Included in Backup'),
          const SizedBox(height: 12),
          _buildCheckItem('Expenses and categories'),
          _buildCheckItem('Incomes and records'),
          _buildCheckItem('Monthly budgets and targets'),
          _buildCheckItem('Recurring transactions'),
          _buildCheckItem('Currency preference settings'),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: AppColors.success),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.primary.withValues(alpha: 0.9),
                fontSize: 14,
              ),
            ),
          ),
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
            'Restoring from a backup file will replace your current local transactions with the contents of the chosen backup file. Are you sure you want to proceed?',
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
                context.read<BackupBloc>().add(const ImportBackupEvent());
              },
              child: const Text('Select File to Restore'),
            ),
          ],
        );
      },
    );
  }
}
