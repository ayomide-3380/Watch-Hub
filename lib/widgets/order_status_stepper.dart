import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';

class OrderStatusStepper extends StatelessWidget {
  final List<TrackingStep> steps;

  const OrderStatusStepper({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, hh:mm a');

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicator Column (Circle + Line)
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: step.isCompleted ? AppTheme.goldAccent : AppTheme.cardBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: step.isCompleted ? AppTheme.goldAccent : AppTheme.cardBorder,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    step.isCompleted ? Icons.check : Icons.circle,
                    size: step.isCompleted ? 14 : 8,
                    color: step.isCompleted ? AppTheme.obsidianBlack : AppTheme.textMuted,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 44,
                    color: step.isCompleted ? AppTheme.goldAccent : AppTheme.cardBorder,
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Content Column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: TextStyle(
                        color: step.isCompleted ? AppTheme.textPrimary : AppTheme.textMuted,
                        fontSize: 14,
                        fontWeight: step.isCompleted ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      step.description,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateFormat.format(step.timestamp),
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
