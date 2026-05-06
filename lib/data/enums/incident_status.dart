enum IncidentStatus {
  reported,
  inProgress,
  resolved;

  String get displayName {
    switch (this) {
      case IncidentStatus.reported:
        return 'Reported';
      case IncidentStatus.inProgress:
        return 'In Progress';
      case IncidentStatus.resolved:
        return 'Resolved';
    }
  }

  String get dbValue {
    switch (this) {
      case IncidentStatus.reported:
        return 'reported';
      case IncidentStatus.inProgress:
        return 'in_progress';
      case IncidentStatus.resolved:
        return 'resolved';
    }
  }

  static IncidentStatus fromDb(String value) {
    switch (value) {
      case 'in_progress':
        return IncidentStatus.inProgress;
      case 'resolved':
        return IncidentStatus.resolved;
      default:
        return IncidentStatus.reported;
    }
  }
}
