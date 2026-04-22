import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF040723);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF1B1F3B);
  static const Color onPrimaryContainer = Color(0xFF8386A8);
  static const Color inversePrimary = Color(0xFFC1C4E9);

  // Secondary (Saffron)
  static const Color secondary = Color(0xFFAB3500);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFE6A34);
  static const Color onSecondaryContainer = Color(0xFF5D1900);

  // Tertiary (Mint)
  static const Color tertiary = Color(0xFF000C0A);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF002622);
  static const Color onTertiaryContainer = Color(0xFF00998D);

  // Surface
  static const Color surface = Color(0xFFF7F9FC);
  static const Color surfaceDim = Color(0xFFD8DADD);
  static const Color surfaceBright = Color(0xFFF7F9FC);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F4F7);
  static const Color surfaceContainer = Color(0xFFECEEF1);
  static const Color surfaceContainerHigh = Color(0xFFE6E8EB);
  static const Color surfaceContainerHighest = Color(0xFFE0E3E6);
  static const Color surfaceVariant = Color(0xFFE0E3E6);
  static const Color surfaceTint = Color(0xFF595C7C);

  // Text
  static const Color onSurface = Color(0xFF191C1E);
  static const Color onSurfaceVariant = Color(0xFF46464D);
  static const Color inverseSurface = Color(0xFF2D3133);
  static const Color inverseOnSurface = Color(0xFFEFF1F4);

  // Outline
  static const Color outline = Color(0xFF77767E);
  static const Color outlineVariant = Color(0xFFC7C5CE);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Fixed colors
  static const Color primaryFixed = Color(0xFFDFE0FF);
  static const Color primaryFixedDim = Color(0xFFC1C4E9);
  static const Color onPrimaryFixed = Color(0xFF151935);
  static const Color onPrimaryFixedVariant = Color(0xFF414563);
  static const Color secondaryFixed = Color(0xFFFFDBD0);
  static const Color secondaryFixedDim = Color(0xFFFFB59D);
  static const Color onSecondaryFixed = Color(0xFF390C00);
  static const Color onSecondaryFixedVariant = Color(0xFF832600);
  static const Color tertiaryFixed = Color(0xFF70F8E8);
  static const Color tertiaryFixedDim = Color(0xFF4FDBCC);
  static const Color onTertiaryFixed = Color(0xFF00201D);
  static const Color onTertiaryFixedVariant = Color(0xFF005049);

  // Background
  static const Color background = Color(0xFFF7F9FC);
  static const Color onBackground = Color(0xFF191C1E);

  // Severity scale
  static const Color severityLow = Color(0xFF00B4A6);
  static const Color severityModerate = Color(0xFFF59E0B);
  static const Color severityHigh = Color(0xFFF97316);
  static const Color severityCritical = Color(0xFFEF4444);
  static const Color severityPulse = Color(0xFFFF6B35);

  // XP/Progress
  static const Color xpBarBackground = Color(0xFFE5E7EB);
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double containerMargin = 20;
  static const double gutter = 16;
}

class AppBorderRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 40;
  static const double full = 9999;
}

class AppShadows {
  static List<BoxShadow> level1 = [
    BoxShadow(
      color: const Color(0xFF1B1F3B).withValues(alpha: 0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> level2 = [
    BoxShadow(
      color: const Color(0xFF1B1F3B).withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}
