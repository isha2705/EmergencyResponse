import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emergency_response/widgets/incident/incident_card.dart';
import 'package:emergency_response/providers/incident_provider.dart';

class IncidentListScreen extends ConsumerWidget {
  const IncidentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncIncidents = ref.watch(incidentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incidents'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(incidentsProvider.notifier).refresh(),
        child: asyncIncidents.when(
          data: (incidents) {
            if (incidents.isEmpty) {
              return ListView(
                children: const [
                   SizedBox(height: 100),
                   Center(child: Text('No incidents found.', style: TextStyle(fontSize: 16))),
                ],
              );
            }
            return ListView.builder(
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                return IncidentCard(incident: incidents[index]);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
