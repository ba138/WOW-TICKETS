import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Screens/qrc_screen.dart';

class AuthRepository {
  Future<void> loginUser(
      String email, String password, BuildContext context) async {
    final url = Uri.parse(
        'https://wow-tickets-app-staging.up.railway.app/api/users/signin?');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Successful login
      debugPrint('Login successful');
      debugPrint('Response: ${response.body}');
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => const QrCodeScanScreen(),
        ),
      );
    } else {
      // Login failed
      debugPrint('Login failed');
      debugPrint('Response: ${response.body}');
    }
  }
}
