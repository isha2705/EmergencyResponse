import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emergency_response/data/enums/incident_priority.dart';
import 'package:emergency_response/data/enums/incident_status.dart';
import 'package:emergency_response/providers/filter_provider.dart';
import 'package:emergency_response/widgets/incident/incident_card.dart';

class SearchFilterScreen extends ConsumerWidget {
  const SearchFilterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterStateProvider);
    final results = ref.watch(filteredIncidentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search by ID or keywords...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
          ),
          onChanged: (val) => ref.read(filterStateProvider.notifier).updateQuery(val),
        ),
        actions: [
          if (filterState.hasActiveFilters)
            TextButton(
              onPressed: () => ref.read(filterStateProvider.notifier).clearAll(),
              child: const Text('CLEAR', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...IncidentStatus.values.map((s) => _buildFilterChip(
                        label: s.displayName,
                        selected: filterState.status == s,
                        onSelected: (val) => ref.read(filterStateProvider.notifier).updateStatus(val ? s : null),
                      )),
                  const SizedBox(width: 16),
                  const Text('Priority: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...IncidentPriority.values.map((p) => _buildFilterChip(
                        label: p.displayName,
                        selected: filterState.priority == p,
                        activeColor: p.lightColor,
                        onSelected: (val) => ref.read(filterStateProvider.notifier).updatePriority(val ? p : null),
                      )),
                ],
              ),
            ),
          ),
          
          const Divider(height: 1),

          // Results
          Expanded(
            child: results.when(
              data: (incidents) {
                if (incidents.isEmpty) return const Center(child: Text('No results found.'));
                return ListView.builder(
                  itemCount: incidents.length,
                  itemBuilder: (context, i) => IncidentCard(incident: incidents[i]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required ValueChanged<bool> onSelected,
    Color? activeColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: selected,
        onSelected: onSelected,
        selectedColor: activeColor,
      ),
    );
  }
}
