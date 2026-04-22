import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../core/navigation_extensions.dart';

class AboutSudarshanScreen extends StatelessWidget {
  const AboutSudarshanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.safePop('/citizen-home'),
        ),
        title: const Text('About Sudarshan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    ),
                    child: const Icon(
                      Icons.visibility,
                      size: 40,
                      color: AppColors.secondaryContainer,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Sudarshan',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Version 1.0.0',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Our Mission',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Sudarshan empowers citizens to report community issues and volunteers to resolve them. Together, we build safer, cleaner, and more connected neighborhoods.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'The Team',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Built with passion by a team of engineers, designers, and community advocates who believe technology can drive real-world change.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextButton(
              onPressed: () => context.go('/sudarshan-vision'),
              child: const Text('Read the Sudarshan Vision'),
            ),
          ],
        ),
      ),
    );
  }
}
