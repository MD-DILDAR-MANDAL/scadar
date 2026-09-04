import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scadar/core/constants/app_colors.dart';
import 'package:scadar/features/finance/bloc/finance_bloc.dart';
import 'package:scadar/features/finance/bloc/finance_event.dart';
import 'package:scadar/features/finance/bloc/finance_state.dart';
import 'package:scadar/features/subscriptions/widgets/add_subscription_dialog.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (_) => const AddSubscriptionDialog(),
          );
        },
      ),
      body: BlocBuilder<FinanceBloc, FinanceState>(
        builder: (context, state) {
          if (state is! FinanceLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.subscriptions.isEmpty) {
            return const Center(
              child: Text(
                'No recurring transactions.',
                style: TextStyle(color: AppColors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.subscriptions.length,
            itemBuilder: (context, index) {
              final sub = state.subscriptions[index];
              final amountStr = '${sub.isIncome ? '+' : '-'}${sub.amount.toStringAsFixed(2)} ${sub.currency}';
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    sub.description,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.dark),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Interval: ${sub.interval.name.toUpperCase()}'),
                      Text('Next: ${DateFormat.yMMMd().format(sub.nextExecutionDate)}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        amountStr,
                        style: TextStyle(
                          color: sub.isIncome ? AppColors.success : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Switch(
                        value: sub.isActive,
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) {
                          sub.isActive = val;
                          context.read<FinanceBloc>().add(UpdateSubscriptionEvent(sub));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          context.read<FinanceBloc>().add(DeleteSubscriptionEvent(sub));
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
