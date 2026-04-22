import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/navigation_extensions.dart';

class IssueDetailActiveScreen extends StatelessWidget {
  const IssueDetailActiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.safePop('/citizen-home'),
        ),
        title: const Text('Issue Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.severityCritical.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.full),
              ),
              child: Text(
                'Active',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.severityCritical,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Water logging on Main Road',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Reported 2 hours ago by Anonymous',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              ),
              child: const Center(child: Icon(Icons.image, size: 48, color: AppColors.onSurfaceVariant)),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Description',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Heavy water logging due to blocked drains. Vehicles are struggling to pass and pedestrians are getting splashed.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.secondaryContainer),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Sector 12, Noida',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
