import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emergency_response/data/enums/incident_category.dart';
import 'package:emergency_response/data/enums/incident_priority.dart';
import 'package:emergency_response/data/enums/incident_status.dart';
import 'package:emergency_response/data/models/incident.dart';
import 'package:emergency_response/data/repositories/incident_repository.dart';
import 'package:emergency_response/providers/incident_provider.dart';

class FilterState {
  final String query;
  final IncidentStatus? status;
  final IncidentPriority? priority;
  final IncidentCategory? category;

  const FilterState({
    this.query = '',
    this.status,
    this.priority,
    this.category,
  });

  FilterState copyWith({
    String? query,
    IncidentStatus? status,
    IncidentPriority? priority,
    IncidentCategory? category,
    bool clearStatus = false,
    bool clearPriority = false,
    bool clearCategory = false,
  }) {
    return FilterState(
      query: query ?? this.query,
      status: clearStatus ? null : (status ?? this.status),
      priority: clearPriority ? null : (priority ?? this.priority),
      category: clearCategory ? null : (category ?? this.category),
    );
  }

  bool get hasActiveFilters =>
      query.isNotEmpty || status != null || priority != null || category != null;
}

final filterStateProvider =
    StateNotifierProvider<FilterNotifier, FilterState>((ref) {
  return FilterNotifier();
});

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(const FilterState());

  void updateQuery(String q) => state = state.copyWith(query: q);
  void updateStatus(IncidentStatus? s) =>
      state = state.copyWith(status: s, clearStatus: s == null);
  void updatePriority(IncidentPriority? p) =>
      state = state.copyWith(priority: p, clearPriority: p == null);
  void updateCategory(IncidentCategory? c) =>
      state = state.copyWith(category: c, clearCategory: c == null);
  void clearAll() => state = const FilterState();
}

final filteredIncidentsProvider =
    FutureProvider<List<Incident>>((ref) async {
  final filter = ref.watch(filterStateProvider);
  // watch the main list so reloads on new data
  ref.watch(incidentsProvider);
  final repo = ref.read(incidentRepositoryProvider);
  return repo.searchIncidents(
    query: filter.query.isEmpty ? null : filter.query,
    status: filter.status,
    priority: filter.priority,
    category: filter.category,
  );
});
