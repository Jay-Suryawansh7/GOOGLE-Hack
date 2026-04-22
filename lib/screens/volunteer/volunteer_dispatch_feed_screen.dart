import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_client.dart';
import '../../core/constants.dart';
import '../../widgets/custom_bottom_nav.dart';

class VolunteerDispatchFeedScreen extends StatefulWidget {
  const VolunteerDispatchFeedScreen({super.key});

  @override
  State<VolunteerDispatchFeedScreen> createState() => _VolunteerDispatchFeedScreenState();
}

class _VolunteerDispatchFeedScreenState extends State<VolunteerDispatchFeedScreen> {
  int _selectedIndex = 0;
  List<dynamic> _issues = [];
  bool _isLoading = true;
  bool _isOnline = false;

  @override
  void initState() {
    super.initState();
    _fetchIssues();
  }

  Future<void> _fetchIssues() async {
    try {
      final response = await ApiClient.dio.get('/issues/nearby', queryParameters: {
        'lat': 23.2599,
        'lng': 77.4126,
        'radius_m': 5000,
      });
      setState(() {
        _issues = response.data as List<dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Color _severityColor(int severity) {
    switch (severity) {
      case 1: return AppColors.onTertiaryContainer;
      case 2: return AppColors.secondaryFixedDim;
      case 3: return AppColors.severityHigh;
      case 4: return AppColors.secondaryContainer;
      case 5: return AppColors.error;
      default: return AppColors.secondaryFixedDim;
    }
  }

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
                  IconButton(
                    icon: const Icon(Icons.menu, color: AppColors.primary),
                    onPressed: () {},
                  ),
                  Row(
                    children: [
                      Text(
                        'Sudarshan',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.secondaryContainer,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                        ),
                        child: const Text(
                          'Volunteer',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _isOnline,
                    onChanged: (v) => setState(() => _isOnline = v),
                    activeColor: AppColors.secondaryContainer,
                  ),
                ],
              ),
            ),
            // Location services banner
            if (!_isOnline)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  border: Border(
                    top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                    bottom: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_off, color: AppColors.onSurfaceVariant, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location Services Disabled',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Toggle your status to 'Online' to receive active dispatch requests in your immediate vicinity.",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            // Content
            Expanded(
              child: _selectedIndex == 0
                  ? _buildFeed()
                  : _selectedIndex == 1
                      ? const _SafetyMapView()
                      : _selectedIndex == 2
                          ? const _HistoryView()
                          : const _ProfileView(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: VolunteerBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _buildFeed() {
    return RefreshIndicator(
      onRefresh: _fetchIssues,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.containerMargin),
              child: Row(
                children: [
                  Text(
                    'Dispatch Feed',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.primaryContainer,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppBorderRadius.full),
                      border: Border.all(color: AppColors.outlineVariant),
                    ),
                    child: Text(
                      '3 Nearby',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_issues.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.inbox, size: 64, color: AppColors.onSurfaceVariant),
                    const SizedBox(height: AppSpacing.md),
                    const Text('No tasks available'),
                    TextButton(onPressed: _fetchIssues, child: const Text('Refresh')),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
              sliver: SliverList.builder(
                itemCount: _issues.length,
                itemBuilder: (context, index) {
                  final issue = _issues[index] as Map<String, dynamic>;
                  final severity = (issue['severity'] as num?)?.toInt() ?? 2;
                  final color = _severityColor(severity);
                  final categories = ['MEDICAL', 'INFRASTRUCTURE', 'ANIMAL'];
                  final category = categories[index % categories.length];

                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                      border: Border.all(color: AppColors.outlineVariant),
                      boxShadow: AppShadows.level1,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left severity bar
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(AppBorderRadius.lg),
                              topRight: Radius.circular(AppBorderRadius.lg),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.warning, size: 12, color: color),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Lvl $severity',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    category,
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.directions_walk, size: 14, color: AppColors.onSurfaceVariant),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${(index + 1) * 0.2} mi',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                issue['description'] ?? 'Untitled Issue',
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontSize: 20,
                                  color: AppColors.primaryContainer,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                issue['details'] ?? 'No details provided...',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 16, color: AppColors.onSurfaceVariant),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Reported ${(index + 1) * 2}m ago',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                      onPressed: () => context.go('/task-detail-pre-accept'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.secondaryContainer,
                                        foregroundColor: AppColors.onPrimary,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Text(
                                        'Claim',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _SafetyMapView extends StatelessWidget {
  const _SafetyMapView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.map, size: 64, color: AppColors.onSurfaceVariant),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Safety Map',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'View safety zones and active issues on the map.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.containerMargin),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            border: Border.all(color: AppColors.outlineVariant),
            boxShadow: AppShadows.level1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                index == 0 ? 'Park bench broken' : 'Street light repaired',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 18,
                  color: AppColors.primaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Resolved',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.onTertiaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '+${(index + 1) * 20} XP earned',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.secondaryContainer,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.containerMargin),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.surfaceContainer,
            child: Icon(Icons.person, size: 48, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Volunteer Rajesh',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Trust Score: 85',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.secondaryContainer,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified, color: AppColors.onTertiaryContainer),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'KYC Verified',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton(
            onPressed: () => context.go('/settings'),
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}
