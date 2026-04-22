import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../core/navigation_extensions.dart';

class TaskDetailClaimedScreen extends StatelessWidget {
  const TaskDetailClaimedScreen({super.key});

  void _showResolveConfirmation(BuildContext context) {
    context.push('/resolve-confirmation');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.safePop('/volunteer-feed'),
        ),
        title: const Text('Task Claimed'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.full),
              ),
              child: Text(
                'Claimed by you',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.secondaryContainer,
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
              'Exact location revealed after claim',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.secondaryContainer),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text('Near Sector 12 Metro Station, Gate 2')),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.navigation),
                  SizedBox(width: AppSpacing.sm),
                  Text('Navigate'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () => _showResolveConfirmation(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.severityLow),
              child: const Text('Mark Resolved'),
            ),
          ],
        ),
      ),
    );
  }
}
