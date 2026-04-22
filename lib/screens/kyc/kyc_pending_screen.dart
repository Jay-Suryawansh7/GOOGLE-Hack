import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/navigation_extensions.dart';

class KycPendingScreen extends StatelessWidget {
  const KycPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.containerMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.hourglass_top,
                size: 64,
                color: AppColors.secondaryContainer,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'KYC Submitted',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your verification is under review. This usually takes 24-48 hours.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () => context.safePop('/volunteer-profile'),
                child: const Text('Back to Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
