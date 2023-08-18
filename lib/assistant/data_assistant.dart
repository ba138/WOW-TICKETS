import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:http/http.dart' as http;

class DataAssistant {
  Future<void> fetchDataAndStore() async {
    final url = Uri.parse(
        'https://wow-tickets-app-staging.up.railway.app/api/users/signin?');
    final response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'your_database_name.db');

      final db = await openDatabase(path); // Pass the path as an argument
      await db.insert('Events', jsonData);
    }
  }
}
