import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:emergency_response/data/models/incident.dart';
import 'package:emergency_response/core/utils/date_formatter.dart';
import 'package:emergency_response/widgets/incident/priority_badge.dart';
import 'package:emergency_response/widgets/incident/status_chip.dart';
import 'package:emergency_response/widgets/incident/category_icon.dart';
import 'package:flutter_animate/flutter_animate.dart';

class IncidentCard extends StatelessWidget {
  final Incident incident;
  final VoidCallback? onTap;

  const IncidentCard({
    super.key,
    required this.incident,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () => context.push('/incidents/${incident.id}'),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Priority Color Strip
              Container(
                width: 6,
                color: incident.priority.color,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Priority & Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PriorityBadge(priority: incident.priority),
                          StatusChip(status: incident.status),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Title
                      Text(
                        incident.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      
                      // ID
                      Text(
                        '#${incident.id.split('-').first.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Details row (Location & Time)
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              incident.location,
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            DateFormatter.timeAgo(incident.timestamp),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      
                      // Assignee (if any)
                      if (incident.assignedResponder != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.person, size: 14, color: Colors.blue[700]),
                            const SizedBox(width: 4),
                            Text(
                              'Assigned: ${incident.assignedResponder}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                      
                      // Sync indicator
                      if (!incident.isSynced) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.cloud_off, size: 12, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              'Pending Sync',
                              style: TextStyle(fontSize: 10, color: Colors.orange[800], fontStyle: FontStyle.italic),
                            ),
                          ],
                        )
                      ]
                    ],
                  ),
                ),
              ),
              // Category Icon
              Padding(
                padding: const EdgeInsets.only(right: 16, top: 16),
                child: CategoryIcon(category: incident.category),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }
}
