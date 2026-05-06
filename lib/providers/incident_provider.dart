import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emergency_response/data/models/incident.dart';
import 'package:emergency_response/data/repositories/incident_repository.dart';
import 'package:emergency_response/core/utils/priority_sorter.dart';

final incidentRepositoryProvider = Provider<IncidentRepository>((ref) {
  return IncidentRepository();
});

final incidentsProvider =
    AsyncNotifierProvider<IncidentNotifier, List<Incident>>(() {
  return IncidentNotifier();
});

class IncidentNotifier extends AsyncNotifier<List<Incident>> {
  @override
  Future<List<Incident>> build() async {
    final repo = ref.read(incidentRepositoryProvider);
    final incidents = await repo.getAllIncidents();
    return PrioritySorter.sort(incidents);
  }

  Future<void> addIncident(Incident incident) async {
    final repo = ref.read(incidentRepositoryProvider);
    await repo.addIncident(incident);
    ref.invalidateSelf();
  }

  Future<void> updateIncident(Incident incident) async {
    final repo = ref.read(incidentRepositoryProvider);
    await repo.updateIncident(incident);
    ref.invalidateSelf();
  }

  Future<void> deleteIncident(String id) async {
    final repo = ref.read(incidentRepositoryProvider);
    await repo.deleteIncident(id);
    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

// Single incident provider
final incidentByIdProvider =
    FutureProvider.family<Incident?, String>((ref, id) async {
  // Watch the main list so details refresh when list updated
  ref.watch(incidentsProvider);
  final repo = ref.read(incidentRepositoryProvider);
  return repo.getIncidentById(id);
});
