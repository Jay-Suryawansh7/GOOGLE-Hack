import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class BadgeUnlockScreen extends StatelessWidget {
  const BadgeUnlockScreen({super.key});

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
                  Icons.emoji_events,
                  size: 60,
                  color: AppColors.secondaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Badge Unlocked!',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.secondaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Community Guardian',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'You have resolved 10 issues in your community. Keep up the great work!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () => context.go('/volunteer-feed'),
                child: const Text('Share & Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
