import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_client.dart';
import '../../core/constants.dart';
import '../../widgets/custom_bottom_nav.dart';

class CitizenHomeFeedScreen extends StatefulWidget {
  const CitizenHomeFeedScreen({super.key});

  @override
  State<CitizenHomeFeedScreen> createState() => _CitizenHomeFeedScreenState();
}

class _CitizenHomeFeedScreenState extends State<CitizenHomeFeedScreen> {
  int _selectedIndex = 0;
  List<dynamic> _issues = [];
  bool _isLoading = true;
  String _selectedFilter = 'All Reports';

  final List<String> _filters = ['All Reports', 'Safety', 'Infrastructure'];

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

  IconData _severityIcon(int severity) {
    switch (severity) {
      case 1: return Icons.delete_outline;
      case 2: return Icons.lightbulb_outline;
      case 3: return Icons.warning_amber;
      case 4: return Icons.warning;
      case 5: return Icons.medical_services;
      default: return Icons.info_outline;
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
                  Text(
                    'Sudarshan',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondaryContainer,
                      letterSpacing: -0.5,
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
              child: _selectedIndex == 0
                  ? _buildFeed()
                  : _selectedIndex == 1
                      ? const _SafetyMapView()
                      : _selectedIndex == 2
                          ? const _MyReportsView()
                          : const _ProfileView(),
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () => context.push('/report-issue'),
              backgroundColor: AppColors.secondaryContainer,
              foregroundColor: AppColors.onPrimary,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, size: 28),
            )
          : null,
      bottomNavigationBar: CitizenBottomNav(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Neighborhood Pulse',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.primaryContainer,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Stay updated on recent reports and activities in your area.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Filter chips
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final filter = _filters[index];
                        final isSelected = _selectedFilter == filter;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFilter = filter),
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
                              filter,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
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
                    const Text('No issues nearby'),
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
                  final status = issue['status'] ?? 'Open';

                  return GestureDetector(
                    onTap: () => context.go('/issue-detail-active'),
                    child: Container(
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
                          // Top section with severity and status
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
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
                                      Icon(_severityIcon(severity), size: 14, color: color),
                                      const SizedBox(width: 4),
                                      Text(
                                        'LEVEL $severity SEVERITY',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: status == 'Active'
                                        ? AppColors.tertiaryContainer
                                        : AppColors.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: status == 'Active'
                                          ? AppColors.onTertiaryContainer
                                          : AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Title and description
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Location and time
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(AppBorderRadius.lg),
                                bottomRight: Radius.circular(AppBorderRadius.lg),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: AppColors.onSurfaceVariant),
                                const SizedBox(width: 4),
                                Text(
                                  '${(index + 1) * 0.2} miles away',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.access_time, size: 16, color: AppColors.onSurfaceVariant),
                                const SizedBox(width: 4),
                                Text(
                                  issue['created_at'] != null
                                      ? '${DateTime.now().difference(DateTime.parse(issue['created_at'])).inHours}h ago'
                                      : '2h ago',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

class _MyReportsView extends StatelessWidget {
  const _MyReportsView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
              border: Border.all(color: AppColors.outlineVariant),
              boxShadow: AppShadows.level1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: index == 0 ? AppColors.error.withValues(alpha: 0.1) : AppColors.onTertiaryContainer.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      ),
                      child: Text(
                        index == 0 ? 'LEVEL 4 SEVERITY' : 'LEVEL 1 SEVERITY',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: index == 0 ? AppColors.error : AppColors.onTertiaryContainer,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: index == 0 ? AppColors.surfaceContainerLow : AppColors.tertiaryContainer,
                        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      ),
                      child: Text(
                        index == 0 ? 'Open' : 'Resolved',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: index == 0 ? AppColors.onSurfaceVariant : AppColors.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  index == 0 ? 'Deep Pothole on Main St.' : 'Streetlight Out in Park',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: 18,
                    color: AppColors.primaryContainer,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  index == 0
                      ? 'Large pothole forming near the intersection, causing vehicles to swerve...'
                      : 'Three consecutive streetlights are out along the eastern path of the community...',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      index == 0 ? '0.2 miles away' : '0.5 miles away',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.access_time, size: 16, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      index == 0 ? '2h ago' : '5h ago',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
          // Profile card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              border: Border.all(color: AppColors.outlineVariant),
              boxShadow: AppShadows.level1,
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    const CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.surfaceContainer,
                      child: Icon(Icons.person, size: 48, color: AppColors.onSurfaceVariant),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(AppBorderRadius.full),
                        border: Border.all(color: AppColors.surfaceContainerLowest, width: 2),
                      ),
                      child: const Text(
                        'Lvl 12',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Alex Mercer',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.primaryContainer,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Level 12 Guardian',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.secondaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // XP Progress
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.bolt, size: 14, color: AppColors.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Text(
                                'Next Rank: Sentinel',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '12,450 / 15,000 XP',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.secondaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppBorderRadius.full),
                        child: LinearProgressIndicator(
                          value: 0.83,
                          backgroundColor: AppColors.surfaceContainer,
                          valueColor: const AlwaysStoppedAnimation(AppColors.secondaryContainer),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.campaign,
                  iconBg: AppColors.secondaryFixed,
                  iconColor: AppColors.secondary,
                  value: '42',
                  label: 'Reports Filed',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.verified,
                  iconBg: AppColors.tertiaryFixed,
                  iconColor: AppColors.onTertiaryFixedVariant,
                  value: '38',
                  label: 'Issues Resolved',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          // Achievements
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievements',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 20,
                  color: AppColors.primaryContainer,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onTertiaryContainer,
                      ),
                    ),
                    const Icon(Icons.arrow_forward, size: 16, color: AppColors.onTertiaryContainer),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _buildAchievementBadge(
                icon: Icons.shield,
                label: 'First\nResponder',
                color: AppColors.secondaryFixedDim,
              ),
              const SizedBox(width: AppSpacing.md),
              _buildAchievementBadge(
                icon: Icons.eco,
                label: 'Green\nCity',
                color: AppColors.onTertiaryContainer,
              ),
              const SizedBox(width: AppSpacing.md),
              _buildAchievementBadge(
                icon: Icons.people,
                label: 'Community\nPillar',
                color: AppColors.secondaryContainer,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          // Recent Reports
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'My Recent Reports',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: 20,
                color: AppColors.primaryContainer,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildRecentReportCard(
            context,
            title: 'Deep Pothole on Elm Street',
            location: 'Downtown District',
            time: '2d ago',
            status: 'In Progress',
            statusColor: AppColors.secondaryContainer,
            severityColor: AppColors.error,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildRecentReportCard(
            context,
            title: 'Broken Streetlight',
            location: 'Oak Avenue',
            time: '1w ago',
            status: 'Resolved',
            statusColor: AppColors.onTertiaryContainer,
            severityColor: AppColors.onTertiaryContainer,
          ),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              side: const BorderSide(color: AppColors.outlineVariant),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
            ),
            child: const Text('View Complete History'),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.level1,
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryContainer,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentReportCard(
    BuildContext context, {
    required String title,
    required String location,
    required String time,
    required String status,
    required Color statusColor,
    required Color severityColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.level1,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: severityColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.warning, color: severityColor, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      '$location \u2022 $time',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
