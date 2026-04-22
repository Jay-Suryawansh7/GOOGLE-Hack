import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension SafeNavigation on BuildContext {
  /// Pops if possible, otherwise navigates to the fallback route.
  void safePop(String fallbackRoute) {
    if (Navigator.of(this).canPop()) {
      GoRouter.of(this).pop();
    } else {
      go(fallbackRoute);
    }
  }
}
