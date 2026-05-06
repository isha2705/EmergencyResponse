import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:emergency_response/core/constants/app_colors.dart';
import 'package:emergency_response/data/enums/incident_priority.dart';
import 'package:emergency_response/data/enums/incident_category.dart';
import 'package:emergency_response/providers/metrics_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = ref.watch(metricsProvider);

    return Scaffold(
      backgroundColor: AppColors.dashBg,
      appBar: AppBar(
        backgroundColor: AppColors.dashBg,
        title: const Text('Admin Dashboard', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (metrics.criticalCount > 0)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      '${metrics.criticalCount} CRITICAL INCIDENTS REQUIRE ATTENTION',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            
          Row(
            children: [
              Expanded(child: _MetricCard(title: 'Total', value: metrics.total.toString(), color: Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _MetricCard(title: 'Active', value: metrics.active.toString(), color: Colors.orange)),
              const SizedBox(width: 12),
              Expanded(child: _MetricCard(title: 'Resolved', value: metrics.resolved.toString(), color: Colors.green)),
            ],
          ),
          
          const SizedBox(height: 24),
          const Text('Priority Distribution', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildPriorityChart(metrics.byPriority),
          
          const SizedBox(height: 32),
          const Text('Category Overview', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildCategoryChart(metrics.byCategory),
        ],
      ),
    );
  }

  Widget _buildPriorityChart(Map<IncidentPriority, int> data) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dashCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (data.values.fold<int>(0, (m, v) => v > m ? v : m) + 5).toDouble(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final priority = IncidentPriority.values[value.toInt()];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(priority.displayName, style: TextStyle(color: priority.lightColor, fontSize: 10)),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: IncidentPriority.values.map((p) {
            return BarChartGroupData(
              x: p.index,
              barRods: [
                BarChartRodData(
                  toY: (data[p] ?? 0).toDouble(),
                  color: p.color,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryChart(Map<IncidentCategory, int> data) {
    // Collect non-zero categories
    final validData = data.entries.where((e) => e.value > 0).toList();
    if (validData.isEmpty) {
      return const Center(child: Text('No data yet', style: TextStyle(color: Colors.white54)));
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dashCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: validData.map((e) {
            return PieChartSectionData(
              color: e.key.color,
              value: e.value.toDouble(),
              title: '${e.value}',
              radius: 50,
              titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _MetricCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.dashCard,
        borderRadius: BorderRadius.circular(12),
        border: Border(bottom: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
