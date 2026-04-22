import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin, vertical: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.surfaceContainer,
                    child: Icon(Icons.person, size: 18, color: AppColors.onSurfaceVariant),
                  ),
                  Text(
                    'SUDARSHAN',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: AppColors.primary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.containerMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 32,
                        color: AppColors.primaryContainer,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Manage your account preferences and app settings.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // General Section
                    _buildSectionCard(
                      title: 'GENERAL',
                      children: [
                        _buildSettingTile(
                          icon: Icons.notifications_outlined,
                          iconBg: AppColors.surfaceContainer,
                          title: 'Notifications',
                          subtitle: 'Alerts & quiet hours',
                          trailing: Switch(
                            value: true,
                            onChanged: (v) {},
                            activeColor: AppColors.secondaryContainer,
                          ),
                        ),
                        const Divider(height: 1, indent: 56),
                        _buildSettingTile(
                          icon: Icons.language,
                          iconBg: AppColors.surfaceContainer,
                          title: 'Language',
                          subtitle: 'English / Hindi',
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'English',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Support Section
                    _buildSectionCard(
                      title: 'SUPPORT & INFORMATION',
                      children: [
                        _buildSettingTile(
                          icon: Icons.shield_outlined,
                          iconBg: AppColors.surfaceContainer,
                          title: 'Privacy & Data',
                          subtitle: 'Policy & account management',
                          trailing: const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
                          onTap: () {},
                        ),
                        const Divider(height: 1, indent: 56),
                        _buildSettingTile(
                          icon: Icons.help_outline,
                          iconBg: AppColors.surfaceContainer,
                          title: 'Help & FAQ',
                          subtitle: 'Get support',
                          trailing: const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
                          onTap: () => context.go('/help-faq'),
                        ),
                        const Divider(height: 1, indent: 56),
                        _buildSettingTile(
                          icon: Icons.info_outline,
                          iconBg: AppColors.surfaceContainer,
                          title: 'About Sudarshan',
                          subtitle: 'Version 1.0.4',
                          trailing: const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
                          onTap: () => context.go('/about-sudarshan'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Logout
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.go('/welcome'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.errorContainer,
                          foregroundColor: AppColors.error,
                          elevation: 0,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: AppColors.primaryContainer),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
