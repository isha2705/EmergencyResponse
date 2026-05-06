import 'package:emergency_response/data/models/incident.dart';
import 'package:emergency_response/data/enums/incident_category.dart';
import 'package:emergency_response/data/enums/incident_priority.dart';
import 'package:emergency_response/data/enums/incident_status.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class IncidentDao {
  final DatabaseHelper _dbHelper;

  IncidentDao(this._dbHelper);

  Future<Database> get _db async => await _dbHelper.database;

  Future<void> insert(Incident incident) async {
    final db = await _db;
    await db.insert(
      DatabaseHelper.tableIncidents,
      incident.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Incident>> getAll() async {
    final db = await _db;
    final maps = await db.query(
      DatabaseHelper.tableIncidents,
      orderBy: 'timestamp DESC',
    );
    return maps.map((m) => Incident.fromMap(m)).toList();
  }

  Future<Incident?> getById(String id) async {
    final db = await _db;
    final maps = await db.query(
      DatabaseHelper.tableIncidents,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Incident.fromMap(maps.first);
  }

  Future<void> update(Incident incident) async {
    final db = await _db;
    await db.update(
      DatabaseHelper.tableIncidents,
      incident.toMap(),
      where: 'id = ?',
      whereArgs: [incident.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _db;
    await db.delete(
      DatabaseHelper.tableIncidents,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Incident>> getUnsynced() async {
    final db = await _db;
    final maps = await db.query(
      DatabaseHelper.tableIncidents,
      where: 'is_synced = 0',
    );
    return maps.map((m) => Incident.fromMap(m)).toList();
  }

  Future<void> markSynced(String id) async {
    final db = await _db;
    await db.update(
      DatabaseHelper.tableIncidents,
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Incident>> search({
    String? query,
    IncidentStatus? status,
    IncidentPriority? priority,
    IncidentCategory? category,
  }) async {
    final db = await _db;
    final conditions = <String>[];
    final args = <dynamic>[];

    if (query != null && query.isNotEmpty) {
      conditions.add('(title LIKE ? OR description LIKE ? OR id LIKE ?)');
      args.addAll(['%$query%', '%$query%', '%$query%']);
    }
    if (status != null) {
      conditions.add('status = ?');
      args.add(status.dbValue);
    }
    if (priority != null) {
      conditions.add('priority = ?');
      args.add(priority.name);
    }
    if (category != null) {
      conditions.add('category = ?');
      args.add(category.name);
    }

    final maps = await db.query(
      DatabaseHelper.tableIncidents,
      where: conditions.isEmpty ? null : conditions.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'timestamp DESC',
    );
    return maps.map((m) => Incident.fromMap(m)).toList();
  }
}
