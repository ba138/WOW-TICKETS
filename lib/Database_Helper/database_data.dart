import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
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

  Future<void> sendTicketsToAPI() async {
    DatabaseData databaseHelper = DatabaseData();
    List<Ticket> tickets = await databaseHelper.getTickets();
    List<Map<String, dynamic>> ticketsData = tickets.map((ticket) {
      return {
        'id': ticket.id,
        'status': ticket.status ? 1 : 0,
      };
    }).toList();

    final url = Uri.parse(
        'https://wow-tickets-app-staging.up.railway.app/api/purchasedTickets/status');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {'ticketData': ticketsData},
      ),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Data has been sync");
    } else {
      Fluttertoast.showToast(msg: "problem with sync");
    }
  }
}
