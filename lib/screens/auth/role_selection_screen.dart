import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String _selectedRole = 'Citizen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.containerMargin),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl),
              // Logo
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: const Icon(
                  Icons.visibility,
                  color: AppColors.secondaryContainer,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Choose Your Role',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.primaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Select how you want to participate in Sudarshan.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Citizen Card
              _buildRoleCard(
                icon: Icons.campaign,
                iconBg: AppColors.secondaryFixed,
                iconColor: AppColors.secondary,
                title: 'Citizen',
                description: 'Report issues in your neighborhood.',
                isSelected: _selectedRole == 'Citizen',
                onTap: () => setState(() => _selectedRole = 'Citizen'),
              ),
              const SizedBox(height: AppSpacing.md),
              // Volunteer Card
              _buildRoleCard(
                icon: Icons.volunteer_activism,
                iconBg: AppColors.primaryFixed,
                iconColor: AppColors.primaryContainer,
                title: 'Volunteer',
                description: 'Resolve issues and earn points.',
                isSelected: _selectedRole == 'Volunteer',
                onTap: () => setState(() => _selectedRole = 'Volunteer'),
              ),
              const Spacer(),
              // Continue Button
              ElevatedButton(
                onPressed: () {
                  if (_selectedRole == 'Citizen') {
                    context.go('/citizen-home');
                  } else {
                    context.go('/volunteer-feed');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: AppColors.onPrimary,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
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
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.secondaryContainer : AppColors.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? AppShadows.level1 : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: 20,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.secondaryContainer : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.secondaryContainer : AppColors.outline,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: AppColors.onPrimary, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
