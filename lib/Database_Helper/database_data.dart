import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:wowtickets/Database_Helper/database_helper.dart';
import '../assistant/Models/tickets_model.dart';

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

  Future<void> sendTicketsToAPI() async {
    try {
      DatabaseHelper databaseHelper = DatabaseHelper();

      await databaseHelper.initDatabase();

      List<Ticket> tickets = await databaseHelper.getTickets();
      List<Map<String, dynamic>> ticketsData = tickets.map((ticket) {
        return {
          'id': ticket.id,
          'status': ticket.status ? true : false,
        };
      }).toList();
      debugPrint(
        ticketsData.toString(),
      );

      final url = Uri.parse(
        'https://wow-tickets-app-staging.up.railway.app/api/purchasedTickets/status',
      );

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
        Fluttertoast.showToast(msg: "Problem with sync");
      }
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    }
  }
}
