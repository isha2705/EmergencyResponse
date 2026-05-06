import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:emergency_response/core/constants/app_colors.dart';
import 'package:emergency_response/providers/auth_provider.dart';
import 'package:emergency_response/providers/metrics_provider.dart';
import 'package:emergency_response/providers/sync_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final metrics = ref.watch(metricsProvider);
    final syncStatus = ref.watch(syncStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Response'),
        actions: [
          // Sync indicator
          syncStatus.when(
            data: (status) {
              if (status == SyncStatus.syncing) {
                return const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Center(
                    child: SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    ),
                  ),
                );
              } else if (status == SyncStatus.error) {
                return IconButton(
                  icon: const Icon(Icons.cloud_off),
                  onPressed: () => ref.read(syncStatusProvider.notifier).manualSync(),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          
          // Role Toggle
          Row(
            children: [
              Text(
                auth.displayName,
                style: const TextStyle(fontSize: 12),
              ),
              Switch(
                value: ref.read(authProvider.notifier).isAdmin,
                activeColor: AppColors.accent,
                onChanged: (_) {
                  ref.read(authProvider.notifier).toggleRole();
                },
              ),
            ],
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (ref.read(authProvider.notifier).isAdmin)
                    _buildAdminView(context, metrics)
                  else
                    _buildUserView(context),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/report'),
        icon: const Icon(Icons.add),
        label: const Text('Report Incident'),
        backgroundColor: AppColors.priorityCritical,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildUserView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          context,
          title: 'My Reports',
          icon: Icons.list_alt,
          color: AppColors.primary,
          route: '/incidents',
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          context,
          title: 'Search Incidents',
          icon: Icons.search,
          color: AppColors.priorityMedium,
          route: '/search',
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.priorityCriticalBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.priorityCritical.withOpacity(0.3)),
          ),
          child: Column(
            children: const [
              Icon(Icons.warning, color: AppColors.priorityCritical, size: 48),
              SizedBox(height: 8),
              Text(
                'In case of extreme emergency, please also call local emergency services immediately.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.priorityCritical, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdminView(BuildContext context, dynamic metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Admin Overview',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard('Active', metrics.active.toString(), AppColors.priorityHigh),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard('Resolved', metrics.resolved.toString(), AppColors.statusResolved),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          context,
          title: 'Full Dashboard',
          icon: Icons.dashboard,
          color: AppColors.primaryDark,
          route: '/dashboard',
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          context,
          title: 'Manage Incidents',
          icon: Icons.admin_panel_settings,
          color: AppColors.priorityMedium,
          route: '/incidents',
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {required String title, required IconData icon, required Color color, required String route}) {
    return InkWell(
      onTap: () => context.push(route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
