import 'package:flutter/material.dart';

import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/core/widgets/common/flat_toolbar_surface.dart';

class TeamPerformanceScreen extends StatefulWidget {
  const TeamPerformanceScreen({super.key});

  @override
  State<TeamPerformanceScreen> createState() => _TeamPerformanceScreenState();
}

class _TeamPerformanceScreenState extends State<TeamPerformanceScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedDepartment = 'All Departments';
  final List<String> _departments = [
    'All Departments',
    'Customer Service',
    'Technical Support',
    'Sales Team',
    'Management',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.teamPerformance),
        actions: [
          IconButton(
            onPressed: () => _exportTeamReport(),
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'Export Team Report',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTeamHeader(),
          _buildTabBar(),
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildTeamHeader() {
    return FlatToolbarSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Team Performance Dashboard',
                  style: AppFonts.copyWith(
                    AppFonts.h6(color: AppColors.textPrimary),
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _selectedDepartment,
                  onChanged:
                      (value) => setState(() => _selectedDepartment = value!),
                  underline: const SizedBox(),
                  items:
                      _departments.map((department) {
                        return DropdownMenuItem(
                          value: department,
                          child: Text(
                            department,
                            style: AppFonts.copyWith(
                              AppFonts.bodySmall(),
                              fontWeight: AppFonts.medium,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Monitor agent performance, team efficiency, and departmental metrics',
            style: AppFonts.bodySmall(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.surface,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.accent,
        labelColor: AppColors.accent,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppFonts.copyWith(
          AppFonts.bodySmall(),
          fontWeight: AppFonts.semiBold,
        ),
        tabs: const [
          Tab(icon: Icon(Icons.groups), text: 'Team Overview'),
          Tab(icon: Icon(Icons.person), text: 'Agent Performance'),
          Tab(icon: Icon(Icons.business), text: 'Department Metrics'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Container(
      color: AppColors.background,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildTeamOverviewTab(),
          _buildAgentPerformanceTab(),
          _buildDepartmentMetricsTab(),
        ],
      ),
    );
  }

  Widget _buildTeamOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildTeamStatsCards(),
          const SizedBox(height: 24),
          _buildTeamPerformanceChart(),
          const SizedBox(height: 24),
          _buildTeamComparisonCard(),
        ],
      ),
    );
  }

  Widget _buildTeamStatsCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Team Performance Overview',
          style: AppFonts.copyWith(
            AppFonts.bodyLarge(color: AppColors.textPrimary),
            fontWeight: AppFonts.semiBold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTeamStatCard(
                'Active Agents',
                '42',
                Icons.people,
                AppColors.accent,
                '+3 from yesterday',
                true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTeamStatCard(
                'Avg. Resolution Time',
                '4.2h',
                Icons.timer,
                AppColors.success,
                '-0.8h from yesterday',
                true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTeamStatCard(
                'Resolution Rate',
                '94.2%',
                Icons.check_circle,
                AppColors.positive,
                '+1.8% from yesterday',
                true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTeamStatCard(
                'Customer Satisfaction',
                '4.6/5',
                Icons.star,
                AppColors.warning,
                '+0.2 from yesterday',
                true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTeamStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
    bool isPositive,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppFonts.copyWith(
                    AppFonts.caption(color: AppColors.textSecondary),
                    fontWeight: AppFonts.medium,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppFonts.copyWith(
              AppFonts.h6(color: AppColors.textPrimary),
              fontWeight: AppFonts.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            change,
            style: AppFonts.copyWith(
              AppFonts.caption(
                color: isPositive ? AppColors.success : AppColors.error,
              ),
              fontSize: 11,
              fontWeight: AppFonts.medium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamPerformanceChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team Performance Trend',
            style: AppFonts.copyWith(
              AppFonts.bodyMedium(color: AppColors.textPrimary),
              fontWeight: AppFonts.semiBold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Team Performance Chart\n(Line chart implementation would go here)',
                textAlign: TextAlign.center,
                style: AppFonts.bodySmall(color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamComparisonCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Department Comparison',
            style: AppFonts.copyWith(
              AppFonts.bodyMedium(color: AppColors.textPrimary),
              fontWeight: AppFonts.semiBold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDepartmentComparison(
            'Customer Service',
            96,
            AppColors.customerServiceTeam,
          ),
          const SizedBox(height: 12),
          _buildDepartmentComparison(
            'Technical Support',
            91,
            AppColors.supportTeam,
          ),
          const SizedBox(height: 12),
          _buildDepartmentComparison('Sales Team', 89, AppColors.salesTeam),
          const SizedBox(height: 12),
          _buildDepartmentComparison(
            'Management',
            94,
            AppColors.managementTeam,
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentComparison(String department, int score, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            department,
            style: AppFonts.copyWith(
              AppFonts.bodySmall(color: AppColors.textPrimary),
              fontWeight: AppFonts.medium,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              widthFactor: score / 100,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$score%',
          style: AppFonts.copyWith(
            AppFonts.bodySmall(color: AppColors.textPrimary),
            fontWeight: AppFonts.semiBold,
          ),
        ),
      ],
    );
  }

  Widget _buildAgentPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildTopPerformersCard(),
          const SizedBox(height: 24),
          _buildAgentListCard(),
        ],
      ),
    );
  }

  Widget _buildTopPerformersCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Performers This Week',
            style: AppFonts.copyWith(
              AppFonts.bodyMedium(color: AppColors.textPrimary),
              fontWeight: AppFonts.semiBold,
            ),
          ),
          const SizedBox(height: 16),
          _buildTopPerformerItem(
            'Sarah Johnson',
            'Customer Service',
            98,
            '4.9/5',
          ),
          const SizedBox(height: 12),
          _buildTopPerformerItem('Mike Chen', 'Technical Support', 96, '4.8/5'),
          const SizedBox(height: 12),
          _buildTopPerformerItem('Emily Davis', 'Sales Team', 94, '4.7/5'),
        ],
      ),
    );
  }

  Widget _buildTopPerformerItem(
    String name,
    String department,
    int score,
    String rating,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.accent,
            child: Text(
              name.substring(0, 1),
              style: AppFonts.copyWith(
                AppFonts.bodyMedium(color: AppColors.white),
                fontWeight: AppFonts.semiBold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppFonts.copyWith(
                    AppFonts.bodySmall(color: AppColors.textPrimary),
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
                Text(
                  department,
                  style: AppFonts.caption(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$score%',
                style: AppFonts.copyWith(
                  AppFonts.bodyMedium(color: AppColors.success),
                  fontWeight: AppFonts.bold,
                ),
              ),
              Text(
                rating,
                style: AppFonts.caption(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgentListCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'All Agents Performance',
                  style: AppFonts.copyWith(
                    AppFonts.bodyMedium(color: AppColors.textPrimary),
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _sortAgents(),
                icon: const Icon(Icons.sort),
                tooltip: 'Sort Agents',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAgentListHeader(),
          const Divider(),
          _buildAgentListItem(
            'Alex Rodriguez',
            'Customer Service',
            92,
            145,
            '3.2m',
          ),
          _buildAgentListItem(
            'Jessica Wong',
            'Technical Support',
            89,
            123,
            '2.8m',
          ),
          _buildAgentListItem('David Kim', 'Sales Team', 87, 167, '4.1m'),
          _buildAgentListItem(
            'Lisa Thompson',
            'Customer Service',
            95,
            134,
            '2.1m',
          ),
          _buildAgentListItem(
            'Mark Wilson',
            'Technical Support',
            91,
            156,
            '3.5m',
          ),
        ],
      ),
    );
  }

  Widget _buildAgentListHeader() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Agent',
            style: AppFonts.copyWith(
              AppFonts.caption(color: AppColors.textSecondary),
              fontWeight: AppFonts.semiBold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            'Score',
            textAlign: TextAlign.center,
            style: AppFonts.copyWith(
              AppFonts.caption(color: AppColors.textSecondary),
              fontWeight: AppFonts.semiBold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            'Cases',
            textAlign: TextAlign.center,
            style: AppFonts.copyWith(
              AppFonts.caption(color: AppColors.textSecondary),
              fontWeight: AppFonts.semiBold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            'Avg. Time',
            textAlign: TextAlign.center,
            style: AppFonts.copyWith(
              AppFonts.caption(color: AppColors.textSecondary),
              fontWeight: AppFonts.semiBold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgentListItem(
    String name,
    String department,
    int score,
    int cases,
    String avgTime,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppFonts.copyWith(
                    AppFonts.bodySmall(color: AppColors.textPrimary),
                    fontWeight: AppFonts.medium,
                  ),
                ),
                Text(
                  department,
                  style: AppFonts.caption(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              '$score%',
              textAlign: TextAlign.center,
              style: AppFonts.copyWith(
                AppFonts.bodySmall(
                  color:
                      score >= 90
                          ? AppColors.success
                          : score >= 80
                          ? AppColors.warning
                          : AppColors.error,
                ),
                fontWeight: AppFonts.semiBold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '$cases',
              textAlign: TextAlign.center,
              style: AppFonts.bodySmall(color: AppColors.textPrimary),
            ),
          ),
          Expanded(
            child: Text(
              avgTime,
              textAlign: TextAlign.center,
              style: AppFonts.bodySmall(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentMetricsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildDepartmentOverviewCard(),
          const SizedBox(height: 24),
          _buildDepartmentDetailCards(),
        ],
      ),
    );
  }

  Widget _buildDepartmentOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Department Performance Overview',
            style: AppFonts.copyWith(
              AppFonts.bodyMedium(color: AppColors.textPrimary),
              fontWeight: AppFonts.semiBold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Department Performance Chart\n(Bar chart implementation would go here)',
                textAlign: TextAlign.center,
                style: AppFonts.bodySmall(color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentDetailCards() {
    return Column(
      children: [
        _buildDepartmentDetailCard(
          'Customer Service',
          AppColors.customerServiceTeam,
          '24 agents',
          '96% satisfaction',
          '2.1m avg response',
        ),
        const SizedBox(height: 16),
        _buildDepartmentDetailCard(
          'Technical Support',
          AppColors.supportTeam,
          '18 agents',
          '91% satisfaction',
          '3.2m avg response',
        ),
        const SizedBox(height: 16),
        _buildDepartmentDetailCard(
          'Sales Team',
          AppColors.salesTeam,
          '12 agents',
          '89% satisfaction',
          '4.1m avg response',
        ),
      ],
    );
  }

  Widget _buildDepartmentDetailCard(
    String department,
    Color color,
    String agents,
    String satisfaction,
    String responseTime,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  department,
                  style: AppFonts.copyWith(
                    AppFonts.bodyMedium(color: AppColors.textPrimary),
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _viewDepartmentDetails(department),
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                tooltip: 'View Details',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildDepartmentMetric('Active Agents', agents)),
              Expanded(
                child: _buildDepartmentMetric('Satisfaction', satisfaction),
              ),
              Expanded(
                child: _buildDepartmentMetric('Avg Response', responseTime),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.caption(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppFonts.copyWith(
            AppFonts.bodyMedium(color: AppColors.textPrimary),
            fontWeight: AppFonts.semiBold,
          ),
        ),
      ],
    );
  }

  void _exportTeamReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Team report export feature coming soon')),
    );
  }

  void _sortAgents() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Agent sorting feature coming soon')),
    );
  }

  void _viewDepartmentDetails(String department) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View $department details feature coming soon')),
    );
  }
}
