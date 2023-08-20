import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wowtickets/assistant/Models/compare_model.dart';
import 'package:http/http.dart' as http;

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

  Future<void> storePurchaseId(String testID) async {
    try {
      debugPrint("this is testId : $testID");
      await _database.execute('''
      CREATE TABLE IF NOT EXISTS compare_status_ids (
        id TEXT PRIMARY KEY
      )
    ''');

      await _database.insert(
        'compare_status_ids',
        {'id': testID},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint("Error storing purchase ID: $e");
    }
  }

  Future<List<String>> getStoredTicketIds() async {
    try {
      final List<Map<String, dynamic>> results =
          await _database.query('compare_status_ids');
      debugPrint("this is list of ids: $results");

      return results.map((map) => map['id'] as String).toList();
    } catch (e) {
      debugPrint("Error fetching stored ticket IDs: $e");
      return [];
    }
  }

  Future<void> patchTicketIds(List<String> ticketIds) async {
    try {
      final url = Uri.parse(
          'https://wow-tickets-app-staging.up.railway.app/api/purchasedTickets/use');
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ticketIds': ticketIds}),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Data has been sync");
      } else {
        Fluttertoast.showToast(msg: "Problem with connection");
      }
    } catch (e) {
      debugPrint('Error sending PATCH request: $e');
    }
  }

  Future<void> performPatchAction() async {
    // Fetch stored ticket IDs from the database
    List<String> storedTicketIds = await getStoredTicketIds();

    if (storedTicketIds.isNotEmpty) {
      // Send a PATCH request with the fetched ticket IDs
      await patchTicketIds(storedTicketIds);
    } else {
      Fluttertoast.showToast(
        msg: "No data Found",
      );
    }
  }
}
