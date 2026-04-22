import 'package:flutter/material.dart';
import '../core/constants.dart';

class SudarshanAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final bool showMenu;
  final bool showNotification;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final Widget? titleWidget;

  const SudarshanAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.showMenu = true,
    this.showNotification = true,
    this.leading,
    this.actions,
    this.onMenuTap,
    this.onNotificationTap,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        border: const Border(
          bottom: BorderSide(color: AppColors.outlineVariant),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
          child: Row(
            children: [
              if (showBackButton)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  onPressed: () => Navigator.of(context).pop(),
                )
              else if (showMenu)
                IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.primary),
                  onPressed: onMenuTap ?? () {},
                )
              else if (leading != null)
                leading!,
              const Spacer(),
              if (titleWidget != null)
                titleWidget!
              else if (title != null)
                Text(
                  title!,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondaryContainer,
                    letterSpacing: -0.5,
                  ),
                ),
              const Spacer(),
              if (showNotification)
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: AppColors.primary),
                  onPressed: onNotificationTap ?? () {},
                )
              else
                const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
