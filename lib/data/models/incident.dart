import 'package:emergency_response/data/enums/incident_category.dart';
import 'package:emergency_response/data/enums/incident_priority.dart';
import 'package:emergency_response/data/enums/incident_status.dart';

class Incident {
  final String id;
  final String title;
  final String description;
  final IncidentCategory category;
  final IncidentPriority priority;
  final IncidentStatus status;
  final DateTime timestamp;
  final String location;
  final double? latitude;
  final double? longitude;
  final String? assignedResponder;
  final bool isSynced;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;

  const Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.timestamp,
    required this.location,
    this.latitude,
    this.longitude,
    this.assignedResponder,
    this.isSynced = false,
    this.updatedAt,
    this.resolvedAt,
  });

  Incident copyWith({
    String? id,
    String? title,
    String? description,
    IncidentCategory? category,
    IncidentPriority? priority,
    IncidentStatus? status,
    DateTime? timestamp,
    String? location,
    double? latitude,
    double? longitude,
    String? assignedResponder,
    bool? isSynced,
    DateTime? updatedAt,
    DateTime? resolvedAt,
    bool clearResponder = false,
    bool clearResolved = false,
  }) {
    return Incident(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      assignedResponder: clearResponder ? null : (assignedResponder ?? this.assignedResponder),
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: clearResolved ? null : (resolvedAt ?? this.resolvedAt),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'priority': priority.name,
      'status': status.dbValue,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'assigned_responder': assignedResponder,
      'is_synced': isSynced ? 1 : 0,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
      'resolved_at': resolvedAt?.millisecondsSinceEpoch,
    };
  }

  factory Incident.fromMap(Map<String, dynamic> map) {
    return Incident(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: IncidentCategory.fromDb(map['category'] as String),
      priority: IncidentPriority.fromDb(map['priority'] as String),
      status: IncidentStatus.fromDb(map['status'] as String),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      location: map['location'] as String,
      latitude: map['latitude'] as double?,
      longitude: map['longitude'] as double?,
      assignedResponder: map['assigned_responder'] as String?,
      isSynced: (map['is_synced'] as int) == 1,
      updatedAt: map['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int)
          : null,
      resolvedAt: map['resolved_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['resolved_at'] as int)
          : null,
    );
  }
}
