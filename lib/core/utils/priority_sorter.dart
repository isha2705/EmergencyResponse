import 'package:emergency_response/data/enums/incident_priority.dart';
import 'package:emergency_response/data/models/incident.dart';

class PrioritySorter {
  static List<Incident> sort(List<Incident> incidents) {
    final sorted = List<Incident>.from(incidents);
    sorted.sort((a, b) {
      final pc = b.priority.numericValue.compareTo(a.priority.numericValue);
      if (pc != 0) return pc;
      return a.timestamp.compareTo(b.timestamp);
    });
    return sorted;
  }
}
