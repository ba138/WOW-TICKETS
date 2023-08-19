import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../assistant/Models/tickets_model.dart';

class DatabaseData {
  late Database _database;

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

  Future<List<Ticket>> getTickets() async {
    final List<Map<String, dynamic>> maps = await _database.query('tickets');

    return List.generate(maps.length, (i) {
      return Ticket(
        id: maps[i]['id'],
        user: maps[i]['user'],
        status: maps[i]['status'] == 1,
      );
    });
  }
}
