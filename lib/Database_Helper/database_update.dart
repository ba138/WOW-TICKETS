import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../assistant/Models/tickets_model.dart';

class DatabaseUpdater {
  late Database _database;

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'WOWTickets'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE orders(
            id TEXT PRIMARY KEY,
            totalAmount INTEGER,
            totalBookingFee INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE tickets(
            id TEXT PRIMARY KEY,
            user TEXT,
            status INTEGER,
            orderId TEXT,
            FOREIGN KEY (orderId) REFERENCES orders (id)
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> updateTicketStatus(String ticketId, bool newStatus) async {
    await _database.update(
      'tickets',
      {'status': newStatus ? 1 : 0},
      where: 'id = ?',
      whereArgs: [ticketId],
    );
  }

  Future<Ticket?> getTicketById(String ticketId) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'tickets',
      where: 'id = ?',
      whereArgs: [ticketId],
    );

    if (maps.isNotEmpty) {
      return Ticket(
        id: maps[0]['id'],
        user: maps[0]['user'],
        status: maps[0]['status'] == 1,
      );
    }
    return null; // Ticket not found
  }
}
