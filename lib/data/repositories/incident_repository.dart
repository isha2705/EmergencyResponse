import 'package:emergency_response/data/database/database_helper.dart';
import 'package:emergency_response/data/database/incident_dao.dart';
import 'package:emergency_response/data/enums/incident_category.dart';
import 'package:emergency_response/data/enums/incident_priority.dart';
import 'package:emergency_response/data/enums/incident_status.dart';
import 'package:emergency_response/data/models/incident.dart';

class IncidentRepository {
  final IncidentDao _dao;

  IncidentRepository() : _dao = IncidentDao(DatabaseHelper());

  Future<List<Incident>> getAllIncidents() => _dao.getAll();

  Future<Incident?> getIncidentById(String id) => _dao.getById(id);

  Future<void> addIncident(Incident incident) => _dao.insert(incident);

  Future<void> updateIncident(Incident incident) => _dao.update(incident);

  Future<void> deleteIncident(String id) => _dao.delete(id);

  Future<List<Incident>> getUnsyncedIncidents() => _dao.getUnsynced();

  Future<void> markAsSynced(String id) => _dao.markSynced(id);

  Future<List<Incident>> searchIncidents({
    String? query,
    IncidentStatus? status,
    IncidentPriority? priority,
    IncidentCategory? category,
  }) =>
      _dao.search(
        query: query,
        status: status,
        priority: priority,
        category: category,
      );
}
