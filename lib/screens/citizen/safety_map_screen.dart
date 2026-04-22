import 'package:flutter/material.dart';
import '../../core/constants.dart';

class SafetyMapScreen extends StatelessWidget {
  const SafetyMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety Map')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map, size: 64, color: AppColors.onSurfaceVariant),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Safety Map',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'View safety zones and active issues on the map.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
