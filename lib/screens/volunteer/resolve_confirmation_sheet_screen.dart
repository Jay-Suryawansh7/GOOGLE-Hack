import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_client.dart';
import '../../core/constants.dart';

class ResolveConfirmationSheetScreen extends StatefulWidget {
  const ResolveConfirmationSheetScreen({super.key});

  @override
  State<ResolveConfirmationSheetScreen> createState() => _ResolveConfirmationSheetScreenState();
}

class _ResolveConfirmationSheetScreenState extends State<ResolveConfirmationSheetScreen> {
  final _notesController = TextEditingController();
  bool _isLoading = false;

  Future<void> _confirmResolution() async {
    setState(() => _isLoading = true);
    try {
      await ApiClient.dio.patch('/issues/sample-id/resolve', data: {
        'resolution_notes': _notesController.text.isEmpty ? 'Resolved on ground' : _notesController.text,
      });
      if (mounted) {
        context.go('/volunteer-feed');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to resolve: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Confirm Resolution'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure?',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Please confirm that the issue has been resolved. This will notify the reporter.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add resolution notes (optional)...',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: const Icon(Icons.camera_alt, color: AppColors.onSurfaceVariant),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isLoading ? null : _confirmResolution,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Confirm Resolution'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
