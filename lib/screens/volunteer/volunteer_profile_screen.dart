import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class VolunteerProfileScreen extends StatelessWidget {
  const VolunteerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
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
              'Volunteer Rajesh',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Trust Score: 85',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.secondaryContainer,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildStatCard('Tasks Completed', '24'),
            const SizedBox(height: AppSpacing.md),
            _buildStatCard('XP Points', '1200'),
            const SizedBox(height: AppSpacing.md),
            _buildStatCard('Response Time', '8 min'),
            const SizedBox(height: AppSpacing.xl),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primaryFixed.withValues(alpha:0.3),
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified, color: AppColors.primaryContainer),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'KYC Verified',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
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
