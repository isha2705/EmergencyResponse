import 'package:flutter/material.dart';
import 'package:emergency_response/data/enums/incident_priority.dart';

class PriorityBadge extends StatelessWidget {
  final IncidentPriority priority;

  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: priority.lightColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: priority.color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(priority.icon, size: 14, color: priority.color),
          const SizedBox(width: 4),
          Text(
            priority.displayName.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: priority.color,
            ),
          ),
        ],
      ),
    );
  }
}
