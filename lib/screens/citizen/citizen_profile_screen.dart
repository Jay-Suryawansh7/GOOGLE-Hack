import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class CitizenProfileScreen extends StatelessWidget {
  const CitizenProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.surfaceContainer,
              child: Icon(Icons.person, size: 48, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Anonymous Citizen',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Level 3 Reporter',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.secondaryContainer,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildStatCard('Reports', '12'),
            const SizedBox(height: AppSpacing.md),
            _buildStatCard('XP Points', '340'),
            const SizedBox(height: AppSpacing.md),
            _buildStatCard('Streak', '5 days'),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton(
              onPressed: () => context.go('/settings'),
              child: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
