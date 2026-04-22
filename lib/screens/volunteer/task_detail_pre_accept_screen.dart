import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_client.dart';
import '../../core/constants.dart';
import '../../core/navigation_extensions.dart';

class TaskDetailPreAcceptScreen extends StatelessWidget {
  const TaskDetailPreAcceptScreen({super.key});

  Future<void> _acceptTask(BuildContext context) async {
    try {
      final response = await ApiClient.dio.patch('/issues/sample-id/claim');
      if (response.statusCode == 200) {
        if (context.mounted) context.push('/task-detail-claimed');
      } else {
        if (context.mounted) context.push('/taken-snackbar');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to claim: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.safePop('/volunteer-feed'),
        ),
        title: const Text('Task Detail'),
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
                '0.5 km away',
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
              'Sector 12, Noida',
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
              'Heavy water logging reported near the main crossing. Vehicles are having difficulty passing through.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton(
              onPressed: () => _acceptTask(context),
              child: const Text('Accept Task'),
            ),
          ],
        ),
      ),
    );
  }
}
