import 'package:flutter/material.dart';
import '../../core/constants.dart';

class VolunteerHistoryScreen extends StatelessWidget {
  const VolunteerHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              border: Border(
                left: BorderSide(
                  color: index == 0 ? AppColors.severityLow : AppColors.severityLow,
                  width: 4,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  index == 0 ? 'Park bench broken' : 'Street light repaired',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Resolved',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.severityLow,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '+${(index + 1) * 20} XP earned',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.secondaryContainer,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
