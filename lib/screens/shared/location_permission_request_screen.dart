import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class LocationPermissionRequestScreen extends StatelessWidget {
  const LocationPermissionRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.containerMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on_outlined, size: 64, color: AppColors.secondaryContainer),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Location Permission',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Allow Sudarshan to access your location to find nearby issues and tasks.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Allow'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Deny'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
