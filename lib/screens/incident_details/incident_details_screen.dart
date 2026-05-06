import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emergency_response/core/constants/app_strings.dart';
import 'package:emergency_response/core/utils/date_formatter.dart';
import 'package:emergency_response/data/enums/incident_priority.dart';
import 'package:emergency_response/data/enums/incident_status.dart';
import 'package:emergency_response/providers/auth_provider.dart';
import 'package:emergency_response/providers/incident_provider.dart';
import 'package:emergency_response/widgets/incident/priority_badge.dart';
import 'package:emergency_response/widgets/incident/status_chip.dart';
import 'package:emergency_response/widgets/incident/category_icon.dart';

class IncidentDetailsScreen extends ConsumerWidget {
  final String incidentId;

  const IncidentDetailsScreen({super.key, required this.incidentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncIncident = ref.watch(incidentByIdProvider(incidentId));
    final isAdmin = ref.watch(authProvider.notifier).isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incident Details'),
      ),
      body: asyncIncident.when(
        data: (incident) {
          if (incident == null) {
             return const Center(child: Text('Incident not found.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryIcon(category: incident.category, size: 36),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          incident.title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            PriorityBadge(priority: incident.priority),
                            const SizedBox(width: 8),
                            StatusChip(status: incident.status),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              
              // Metadata
              _DetailRow(icon: Icons.tag, title: 'ID', value: incident.id),
              _DetailRow(icon: Icons.location_on, title: 'Location', value: incident.location),
              _DetailRow(icon: Icons.access_time, title: 'Reported', value: DateFormatter.formatFull(incident.timestamp)),
              if (incident.assignedResponder != null)
                _DetailRow(icon: Icons.person, title: 'Responder', value: incident.assignedResponder!),
              
              const Divider(height: 32),
              
              // Description
              const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                incident.description,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),

              const SizedBox(height: 32),
              
              // Admin Panel
              if (isAdmin) ...[
                const Text('Admin Controls', style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        DropdownButtonFormField<IncidentStatus>(
                          value: incident.status,
                          decoration: const InputDecoration(labelText: 'Status'),
                          items: IncidentStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.displayName))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              final updated = incident.copyWith(
                                status: val,
                                resolvedAt: val == IncidentStatus.resolved ? DateTime.now() : null,
                                clearResolved: val != IncidentStatus.resolved,
                              );
                              ref.read(incidentsProvider.notifier).updateIncident(updated);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<IncidentPriority>(
                          value: incident.priority,
                          decoration: const InputDecoration(labelText: 'Priority'),
                          items: IncidentPriority.values.map((p) => DropdownMenuItem(value: p, child: Text(p.displayName))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              ref.read(incidentsProvider.notifier).updateIncident(incident.copyWith(priority: val));
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: incident.assignedResponder,
                          decoration: const InputDecoration(labelText: 'Assign Responder'),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('Unassigned')),
                            ...AppStrings.responders.map((r) => DropdownMenuItem(value: r, child: Text(r))),
                          ],
                          onChanged: (val) {
                            ref.read(incidentsProvider.notifier).updateIncident(incident.copyWith(assignedResponder: val, clearResponder: val == null));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(title, style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
