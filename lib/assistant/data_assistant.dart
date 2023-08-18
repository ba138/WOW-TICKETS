import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:http/http.dart' as http;

class DataAssistant {
  Future<void> fetchDataAndStore(String sellerID) async {
    try {
      final url = Uri.parse(
          'https://wow-tickets-app-staging.up.railway.app/api/orders/sales?seller_id=$sellerID');
      final response = await http.get(
        url,
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        debugPrint(
          'Response Body: $jsonData',
        );
        final databasesPath = await getDatabasesPath();
        final path = join(
          databasesPath,
          'WOWOTICKETSSCANN',
        );

        final db = await openDatabase(path);
        await db.insert('Events', jsonData);
        Fluttertoast.showToast(
          msg: "your data has been added",
        );
      }
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    }
  }
}
