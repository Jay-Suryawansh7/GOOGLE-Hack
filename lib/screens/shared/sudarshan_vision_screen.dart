import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/navigation_extensions.dart';

class SudarshanVisionScreen extends StatelessWidget {
  const SudarshanVisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.safePop('/about-sudarshan'),
        ),
        title: const Text('Sudarshan Vision'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dekho. Batao. Badlo.',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'See it. Report it. Change it.',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Our Vision',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'We envision a world where every citizen is empowered to improve their community. Where reporting an issue is as easy as taking a photo, and resolving it is rewarded with trust and recognition.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Our Values',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildValueItem('Transparency', 'Every action is visible and accountable.'),
            _buildValueItem('Community First', 'We prioritize collective wellbeing over individual gain.'),
            _buildValueItem('Empowerment', 'Technology should amplify human potential, not replace it.'),
            _buildValueItem('Safety', 'A safe community is the foundation of progress.'),
          ],
        ),
      ),
    );
  }

  Widget _buildValueItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
