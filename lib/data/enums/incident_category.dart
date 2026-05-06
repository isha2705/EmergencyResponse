import 'package:flutter/material.dart';

enum IncidentCategory {
  medical,
  fire,
  security,
  maintenance,
  safety,
  other;

  String get displayName {
    switch (this) {
      case IncidentCategory.medical:
        return 'Medical';
      case IncidentCategory.fire:
        return 'Fire';
      case IncidentCategory.security:
        return 'Security';
      case IncidentCategory.maintenance:
        return 'Maintenance';
      case IncidentCategory.safety:
        return 'Safety';
      case IncidentCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case IncidentCategory.medical:
        return Icons.local_hospital_rounded;
      case IncidentCategory.fire:
        return Icons.local_fire_department_rounded;
      case IncidentCategory.security:
        return Icons.security_rounded;
      case IncidentCategory.maintenance:
        return Icons.build_rounded;
      case IncidentCategory.safety:
        return Icons.health_and_safety_rounded;
      case IncidentCategory.other:
        return Icons.report_rounded;
    }
  }

  Color get color {
    switch (this) {
      case IncidentCategory.medical:
        return const Color(0xFFE91E63);
      case IncidentCategory.fire:
        return const Color(0xFFFF5722);
      case IncidentCategory.security:
        return const Color(0xFF3F51B5);
      case IncidentCategory.maintenance:
        return const Color(0xFF795548);
      case IncidentCategory.safety:
        return const Color(0xFF009688);
      case IncidentCategory.other:
        return const Color(0xFF607D8B);
    }
  }

  static IncidentCategory fromDb(String value) {
    switch (value) {
      case 'medical':
        return IncidentCategory.medical;
      case 'fire':
        return IncidentCategory.fire;
      case 'security':
        return IncidentCategory.security;
      case 'maintenance':
        return IncidentCategory.maintenance;
      case 'safety':
        return IncidentCategory.safety;
      default:
        return IncidentCategory.other;
    }
  }
}
