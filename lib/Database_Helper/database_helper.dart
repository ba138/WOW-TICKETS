import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wowtickets/Database_Helper/database_data.dart';
import '../assistant/Models/order_Model.dart';
import '../assistant/Models/tickets_model.dart';
import '../constants.dart';

class DatabaseHelper {
  late Database _database;

  Future<void> initDatabase() async {
    try {
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
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Problem in storing data",
        backgroundColor: wrongColor,
        textColor: backgroundColor,
      );
    }
  }

  Future<void> insertOrder(Order order) async {
    try {
      await _database.insert(
        'orders',
        {'id': order.id},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint("this is function number 2 : $e");
    }
  }

  Future<void> insertTicket(Ticket ticket, String orderId) async {
    try {
      await _database.insert(
        'tickets',
        {
          'id': ticket.id,
          'user': ticket.user,
          'status': ticket.status ? 1 : 0,
          'orderId': orderId,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint("this is function number 3:$e ");
    }
  }

  Future<List<Ticket>> getTickets() async {
    DatabaseData dbData = DatabaseData();
    final Database db = await dbData.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('tickets');

    return List.generate(maps.length, (i) {
      return Ticket(
        id: maps[i]['id'],
        user: maps[i]['user'],
        status: maps[i]['status'] == 1,
      );
    });
  }
}
