import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/navigation_extensions.dart';

class IssueDetailResolvedScreen extends StatelessWidget {
  const IssueDetailResolvedScreen({super.key});

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
                color: AppColors.severityLow.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.full),
              ),
              child: Text(
                'Resolved',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.severityLow,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Park bench broken',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Resolved 1 day ago by Volunteer Rajesh',
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
              'Resolution',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Bench has been repaired with new wooden planks and reinforced joints.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
