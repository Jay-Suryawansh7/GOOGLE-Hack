import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('My Reports'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => context.go('/issue-detail-active'),
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                border: Border(
                  left: BorderSide(
                    color: index == 0 ? AppColors.severityCritical : AppColors.severityLow,
                    width: 4,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    index == 0 ? 'Water logging on Main Road' : 'Park bench broken',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    index == 0 ? 'Active' : 'Resolved',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: index == 0 ? AppColors.severityCritical : AppColors.severityLow,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
