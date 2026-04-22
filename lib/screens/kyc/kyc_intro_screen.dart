import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../core/navigation_extensions.dart';

class KycIntroScreen extends StatelessWidget {
  const KycIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.safePop('/volunteer-profile'),
        ),
        title: const Text('KYC Verification'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.containerMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify Your Identity',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Complete KYC to unlock volunteer features and build trust in the community.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildStepItem('1', 'Take a selfie'),
              const SizedBox(height: AppSpacing.md),
              _buildStepItem('2', 'Upload ID Front'),
              const SizedBox(height: AppSpacing.md),
              _buildStepItem('3', 'Upload ID Back'),
              const SizedBox(height: AppSpacing.md),
              _buildStepItem('4', 'Wait for approval'),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go('/selfie-capture'),
                child: const Text('Start KYC'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => context.go('/volunteer-feed'),
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(AppBorderRadius.full),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
