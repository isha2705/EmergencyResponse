import 'package:flutter/material.dart';

enum IncidentPriority {
  low,
  medium,
  high,
  critical;

  String get displayName {
    switch (this) {
      case IncidentPriority.low:
        return 'Low';
      case IncidentPriority.medium:
        return 'Medium';
      case IncidentPriority.high:
        return 'High';
      case IncidentPriority.critical:
        return 'Critical';
    }
  }

  int get numericValue {
    switch (this) {
      case IncidentPriority.low:
        return 1;
      case IncidentPriority.medium:
        return 2;
      case IncidentPriority.high:
        return 3;
      case IncidentPriority.critical:
        return 4;
    }
  }

  Color get color {
    switch (this) {
      case IncidentPriority.low:
        return const Color(0xFF2E7D32);
      case IncidentPriority.medium:
        return const Color(0xFFF57F17);
      case IncidentPriority.high:
        return const Color(0xFFE65100);
      case IncidentPriority.critical:
        return const Color(0xFFC62828);
    }
  }

  Color get lightColor {
    switch (this) {
      case IncidentPriority.low:
        return const Color(0xFFE8F5E9);
      case IncidentPriority.medium:
        return const Color(0xFFFFF9C4);
      case IncidentPriority.high:
        return const Color(0xFFFFE0B2);
      case IncidentPriority.critical:
        return const Color(0xFFFFEBEE);
    }
  }

  IconData get icon {
    switch (this) {
      case IncidentPriority.low:
        return Icons.arrow_downward_rounded;
      case IncidentPriority.medium:
        return Icons.remove_rounded;
      case IncidentPriority.high:
        return Icons.arrow_upward_rounded;
      case IncidentPriority.critical:
        return Icons.priority_high_rounded;
    }
  }

  static IncidentPriority fromDb(String value) {
    switch (value) {
      case 'medium':
        return IncidentPriority.medium;
      case 'high':
        return IncidentPriority.high;
      case 'critical':
        return IncidentPriority.critical;
      default:
        return IncidentPriority.low;
    }
  }
}
