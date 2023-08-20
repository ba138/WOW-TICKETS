import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseData {
  Database? _database;

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'WOWTickets'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tickets(
            id TEXT PRIMARY KEY,
            user TEXT,
            status INTEGER
          )
        ''');
      },
      version: 1,
    );
  }

  Future<Database> getDatabase() async {
    if (_database == null) {
      await initDatabase();
    }
    return _database!;
  }
}
