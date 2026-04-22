import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class TakenSnackbarScreen extends StatelessWidget {
  const TakenSnackbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Unavailable')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.containerMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.severityHigh),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Task Already Taken',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Another volunteer has already claimed this task. Check the feed for other opportunities.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Back to Feed'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
