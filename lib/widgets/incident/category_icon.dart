import 'package:flutter/material.dart';
import 'package:emergency_response/data/enums/incident_category.dart';

class CategoryIcon extends StatelessWidget {
  final IncidentCategory category;
  final double size;

  const CategoryIcon({
    super.key,
    required this.category,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size * 1.8,
      height: size * 1.8,
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          category.icon,
          color: category.color,
          size: size,
        ),
      ),
    );
  }
}
