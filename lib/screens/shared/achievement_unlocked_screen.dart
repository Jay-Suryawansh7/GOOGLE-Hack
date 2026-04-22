import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class AchievementUnlockedScreen extends StatelessWidget {
  const AchievementUnlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.containerMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.secondaryFixed.withValues(alpha:0.3),
                  borderRadius: BorderRadius.circular(AppBorderRadius.full),
                  border: Border.all(color: AppColors.secondaryContainer, width: 4),
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  size: 60,
                  color: AppColors.secondaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Achievement Unlocked!',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.secondaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '3-Day Streak!',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'You have reported issues for 3 consecutive days. Your community appreciates you!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () => context.go('/citizen-home'),
                child: const Text('Back to Feed'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
