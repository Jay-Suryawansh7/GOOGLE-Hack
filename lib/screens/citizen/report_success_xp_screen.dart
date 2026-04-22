import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class ReportSuccessXpScreen extends StatelessWidget {
  const ReportSuccessXpScreen({super.key});

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
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.secondaryFixed.withValues(alpha:0.3),
                  borderRadius: BorderRadius.circular(AppBorderRadius.full),
                ),
                child: const Icon(
                  Icons.check,
                  size: 40,
                  color: AppColors.secondaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '+10 XP',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.secondaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Issue Reported!',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Thank you for keeping your community safe.',
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
