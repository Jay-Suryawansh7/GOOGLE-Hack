import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // Hero image section
          Container(
            height: MediaQuery.of(context).size.height * 0.55,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppBorderRadius.xxl),
                bottomRight: Radius.circular(AppBorderRadius.xxl),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppBorderRadius.xxl),
                bottomRight: Radius.circular(AppBorderRadius.xxl),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image placeholder
                  Image.network(
                    'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=800&q=80',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.primaryContainer,
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.primaryContainer,
                          AppColors.primaryContainer.withValues(alpha: 0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Logo
                  Positioned(
                    bottom: 40,
                    left: 32,
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondaryContainer.withValues(alpha: 0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.visibility,
                            color: AppColors.onPrimary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sudarshan',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: AppColors.onPrimary,
                                fontSize: 32,
                              ),
                            ),
                            Text(
                              'सुदर्शन',
                              style: TextStyle(
                                color: AppColors.surfaceVariant.withValues(alpha: 0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.containerMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Dekho. Batao. Badlo.',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.primaryContainer,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'See it. Report it. Change it. Empowering your community through action. Be the clarity of insight in your neighborhood.',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  // Get Started button
                  ElevatedButton(
                    onPressed: () => context.go('/phone-entry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryContainer,
                      foregroundColor: AppColors.onPrimary,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      shadowColor: AppColors.secondaryContainer.withValues(alpha: 0.6),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.01,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Log In button
                  OutlinedButton(
                    onPressed: () => context.go('/phone-entry'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryContainer,
                      side: const BorderSide(color: AppColors.primaryContainer, width: 2),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
