import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class ReportIssueFormScreen extends StatefulWidget {
  const ReportIssueFormScreen({super.key});

  @override
  State<ReportIssueFormScreen> createState() => _ReportIssueFormScreenState();
}

class _ReportIssueFormScreenState extends State<ReportIssueFormScreen> {
  String _selectedCategory = 'Infrastructure';
  int _selectedSeverity = 4;
  final _descriptionController = TextEditingController();

  final List<String> _categories = ['Infrastructure', 'Sanitation', 'Safety hazard', 'Other'];

  Color _severityColor(int level) {
    switch (level) {
      case 1: return AppColors.onTertiaryContainer;
      case 2: return AppColors.tertiaryFixedDim;
      case 3: return AppColors.secondaryFixedDim;
      case 4: return AppColors.secondaryContainer;
      case 5: return AppColors.error;
      default: return AppColors.secondaryFixedDim;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Report an Issue',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.primaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo Evidence
            Text(
              'Photo Evidence',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                border: Border.all(
                  color: AppColors.outlineVariant,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_photo_alternate,
                    size: 32,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Tap to upload photo',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Category
            Text(
              'Category',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(AppBorderRadius.full),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryContainer : AppColors.outlineVariant,
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Severity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Severity',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                  decoration: BoxDecoration(
                    color: _severityColor(_selectedSeverity).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  ),
                  child: Text(
                    'High ($_selectedSeverity)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _severityColor(_selectedSeverity),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: Row(
                children: List.generate(5, (index) {
                  final level = index + 1;
                  final isSelected = _selectedSeverity == level;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedSeverity = level),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: isSelected ? _severityColor(level) : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppBorderRadius.sm - 4),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Minor',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  'Critical',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            // Current Location
            Text(
              'Current Location',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                child: Stack(
                  children: [
                    Container(
                      color: const Color(0xFF8BA870),
                      child: CustomPaint(
                        size: const Size(double.infinity, 120),
                        painter: _MapPainter(),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          shape: BoxShape.circle,
                          boxShadow: AppShadows.level1,
                        ),
                        child: const Icon(
                          Icons.my_location,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.secondaryContainer),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '124 Main Street, Civic District',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'GPS Accuracy: 5m',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Edit',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryContainer,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Description
            Text(
              'Description',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Provide details about the issue to help responders...',
                hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                filled: true,
                fillColor: AppColors.surfaceContainerLowest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  borderSide: const BorderSide(color: AppColors.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  borderSide: const BorderSide(color: AppColors.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  borderSide: const BorderSide(color: AppColors.secondaryContainer, width: 2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Submit Button
            ElevatedButton(
              onPressed: () => context.go('/report-success'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryContainer,
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
                    'Submit Report',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.01,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.send, size: 18),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7A9A5E)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw some road-like lines
    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.5), paint);
    canvas.drawLine(Offset(size.width * 0.2, 0), Offset(size.width * 0.4, size.height), paint);
    canvas.drawLine(Offset(size.width * 0.6, 0), Offset(size.width * 0.8, size.height), paint);
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.6), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
