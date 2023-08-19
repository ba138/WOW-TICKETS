import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wowtickets/assistant/Models/compare_model.dart';

class DatabaseUpdater {
  late Database _database;

  Future<void> initDatabase() async {
    try {
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
    } catch (e) {
      debugPrint("Error initializing database: $e");
    }
  }

  Future<Compare?> getTicketByPurchaseId(String purchaseId) async {
    try {
      List<Map<String, dynamic>> maps = await _database.query(
        'tickets',
        where: 'id = ?',
        whereArgs: [purchaseId],
      );

      if (maps.isNotEmpty) {
        return Compare.fromMap(maps.first);
      }
    } catch (e) {
      debugPrint("Error getting ticket by ID: $e");
    }
    return null;
  }

  Future<void> updateTicketStatus(String ticketId, bool newStatus) async {
    try {
      await _database.update(
        'tickets',
        {'status': newStatus ? 1 : 0},
        where: 'id = ?',
        whereArgs: [ticketId],
      );
    } catch (e) {
      debugPrint("Error updating ticket status: $e");
    }
  }
}
