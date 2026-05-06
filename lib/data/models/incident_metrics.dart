import 'package:emergency_response/data/enums/incident_category.dart';
import 'package:emergency_response/data/enums/incident_priority.dart';

class IncidentMetrics {
  final int total;
  final int active;
  final int resolved;
  final Map<IncidentPriority, int> byPriority;
  final Map<IncidentCategory, int> byCategory;
  final int criticalCount;

  const IncidentMetrics({
    required this.total,
    required this.active,
    required this.resolved,
    required this.byPriority,
    required this.byCategory,
    required this.criticalCount,
  });

  factory IncidentMetrics.empty() {
    return IncidentMetrics(
      total: 0,
      active: 0,
      resolved: 0,
      byPriority: {
        for (final p in IncidentPriority.values) p: 0,
      },
      byCategory: {
        for (final c in IncidentCategory.values) c: 0,
      },
      criticalCount: 0,
    );
  }
}
