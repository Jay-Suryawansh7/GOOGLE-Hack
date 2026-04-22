import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class ZoneDetailSheetScreen extends StatelessWidget {
  const ZoneDetailSheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const Text('Zone Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sector 12',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Noida, Uttar Pradesh',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                _buildStatBox('Active Issues', '5', AppColors.severityCritical),
                const SizedBox(width: AppSpacing.md),
                _buildStatBox('Resolved', '23', AppColors.severityLow),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Safety Score',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(
              value: 0.75,
              backgroundColor: AppColors.xpBarBackground,
              valueColor: const AlwaysStoppedAnimation(AppColors.severityLow),
              borderRadius: BorderRadius.circular(AppBorderRadius.full),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text('75% - Moderately Safe'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}
