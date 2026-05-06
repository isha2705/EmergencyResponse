import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emergency_response/data/enums/incident_priority.dart';
import 'package:emergency_response/data/enums/incident_status.dart';
import 'package:emergency_response/data/enums/incident_category.dart';
import 'package:emergency_response/data/models/incident_metrics.dart';
import 'package:emergency_response/providers/incident_provider.dart';

final metricsProvider = Provider<IncidentMetrics>((ref) {
  final asyncIncidents = ref.watch(incidentsProvider);
  return asyncIncidents.when(
    data: (incidents) {
      final total = incidents.length;
      final resolved = incidents
          .where((i) => i.status == IncidentStatus.resolved)
          .length;
      final active = total - resolved;

      final byPriority = <IncidentPriority, int>{};
      for (final p in IncidentPriority.values) {
        byPriority[p] = incidents.where((i) => i.priority == p).length;
      }

      final byCategory = <IncidentCategory, int>{};
      for (final c in IncidentCategory.values) {
        byCategory[c] = incidents.where((i) => i.category == c).length;
      }

      return IncidentMetrics(
        total: total,
        active: active,
        resolved: resolved,
        byPriority: byPriority,
        byCategory: byCategory,
        criticalCount: byPriority[IncidentPriority.critical] ?? 0,
      );
    },
    loading: () => IncidentMetrics.empty(),
    error: (_, __) => IncidentMetrics.empty(),
  );
});
