import 'package:flutter/material.dart';
import 'package:emergency_response/data/enums/incident_status.dart';
import 'package:emergency_response/core/constants/app_colors.dart';

class StatusChip extends StatelessWidget {
  final IncidentStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor = Colors.white;

    switch (status) {
      case IncidentStatus.reported:
        bgColor = AppColors.statusReported;
        break;
      case IncidentStatus.inProgress:
        bgColor = AppColors.statusInProgress;
        break;
      case IncidentStatus.resolved:
        bgColor = AppColors.statusResolved;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
