import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RecordingDatabase {
  static final RecordingDatabase instance = RecordingDatabase._init();
  static Database? _database;

  RecordingDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recordings.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recordings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE speaker_paths(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        server_path TEXT NOT NULL,
        local_recording_path TEXT,
        uploaded_date TEXT NOT NULL,
        status TEXT DEFAULT 'active'
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS speaker_paths(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_path TEXT NOT NULL,
          local_recording_path TEXT,
          uploaded_date TEXT NOT NULL,
          status TEXT DEFAULT 'active'
        )
      ''');
    }
  }

  Future<int> insertRecording(String path) async {
    final db = await instance.database;
    return await db.insert('recordings', {
      'path': path,
      'date': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getAllRecordings() async {
    final db = await instance.database;
    return await db.query('recordings', orderBy: 'id DESC');
  }

  Future<int> insertSpeakerPath(String serverPath, {String? localPath}) async {
    final db = await instance.database;
    return await db.insert('speaker_paths', {
      'server_path': serverPath,
      'local_recording_path': localPath,
      'uploaded_date': DateTime.now().toIso8601String(),
      'status': 'active',
    });
  }

  Future<void> insertSpeakerPaths(List<String> serverPaths) async {
    final db = await instance.database;
    final batch = db.batch();
    
    for (var path in serverPaths) {
      batch.insert('speaker_paths', {
        'server_path': path,
        'uploaded_date': DateTime.now().toIso8601String(),
        'status': 'active',
      });
    }
    
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getAllSpeakerPaths() async {
    final db = await instance.database;
    return await db.query(
      'speaker_paths',
      where: 'status = ?',
      whereArgs: ['active'],
      orderBy: 'id DESC',
    );
  }

  Future<List<String>> getLatestSpeakerPaths() async {
    final db = await instance.database;
    final result = await db.query(
      'speaker_paths',
      columns: ['server_path'],
      where: 'status = ?',
      whereArgs: ['active'],
      orderBy: 'uploaded_date DESC',
      limit: 20,
    );
    
    return result.map((row) => row['server_path'] as String).toList();
  }

  Future<int> deleteSpeakerPath(int id) async {
    final db = await instance.database;
    return await db.update(
      'speaker_paths',
      {'status': 'deleted'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearAllSpeakerPaths() async {
    final db = await instance.database;
    return await db.delete('speaker_paths');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}