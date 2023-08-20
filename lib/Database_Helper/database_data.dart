import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

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

  Future<List<String>> getStoredTicketIds() async {
    try {
      final List<Map<String, dynamic>>? results =
          await _database?.query('comparestatusids');
      debugPrint("this is list of ids: $results");
      if (results != null) {
        return results.map((map) => map['id'] as String).toList();
      } else {
        debugPrint("Database instance is null");
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching stored ticket IDs: $e");
      return [];
    }
  }

  Future<void> patchTicketIds(List<String> ticketIds) async {
    final url = Uri.parse(
        'https://wow-tickets-app-staging.up.railway.app/api/purchasedTickets/use');

    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ticketIds': ticketIds}),
      );

      if (response.statusCode == 200) {
        debugPrint('PATCH request successful');
      } else {
        debugPrint(
            'PATCH request failed with status code: ${response.statusCode}');
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
      debugPrint('No stored ticket IDs found.');
    }
  }
}
