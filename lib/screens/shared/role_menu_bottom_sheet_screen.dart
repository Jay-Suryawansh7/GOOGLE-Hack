import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../core/navigation_extensions.dart';

class RoleMenuBottomSheetScreen extends StatelessWidget {
  const RoleMenuBottomSheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.safePop('/citizen-home'),
        ),
        title: const Text('Menu'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        children: [
          _buildMenuItem(
            context,
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => context.push('/settings'),
          ),
          _buildMenuItem(
            context,
            icon: Icons.info,
            title: 'About Sudarshan',
            onTap: () => context.push('/about-sudarshan'),
          ),
          _buildMenuItem(
            context,
            icon: Icons.help,
            title: 'Help & FAQ',
            onTap: () => context.push('/help-faq'),
          ),
          _buildMenuItem(
            context,
            icon: Icons.swap_horiz,
            title: 'Switch Role',
            onTap: () => context.go('/role-selection'),
          ),
          const Divider(),
          _buildMenuItem(
            context,
            icon: Icons.logout,
            title: 'Logout',
            textColor: AppColors.error,
            onTap: () => context.go('/welcome'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.primary),
      title: Text(title, style: TextStyle(color: textColor)),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
