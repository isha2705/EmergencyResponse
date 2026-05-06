import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static const _dbName = 'emergency_response.db';
  static const _dbVersion = 1;
  static const tableIncidents = 'incidents';

  static DatabaseHelper? _instance;
  Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    if (kIsWeb) {
      // Use web FFI factory
      databaseFactory = databaseFactoryFfiWeb;
      final path = _dbName;
      return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
    } else if (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS) {
      // Use FFI on desktop
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    
    final path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableIncidents (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        priority TEXT NOT NULL,
        status TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        location TEXT NOT NULL,
        latitude REAL,
        longitude REAL,
        assigned_responder TEXT,
        is_synced INTEGER DEFAULT 0,
        updated_at INTEGER,
        resolved_at INTEGER
      )
    ''');

    await db.execute(
        'CREATE INDEX idx_status ON $tableIncidents(status)');
    await db.execute(
        'CREATE INDEX idx_priority ON $tableIncidents(priority)');
    await db.execute(
        'CREATE INDEX idx_timestamp ON $tableIncidents(timestamp)');
    await db.execute(
        'CREATE INDEX idx_synced ON $tableIncidents(is_synced)');
  }
}
