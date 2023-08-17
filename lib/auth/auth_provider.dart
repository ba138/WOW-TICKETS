import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wowtickets/auth/session_manager.dart';

class AuthProvider with ChangeNotifier {
  final SessionManager _sessionManager = SessionManager();

  bool get isLoggedIn => _sessionManager.getToken() != null;

  Future<void> initAuthProvider() async {
    await _sessionManager.init();
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse(
        'https://wow-tickets-app-staging.up.railway.app/api/users/signin?');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'] as String;
      _sessionManager.saveToken(token);
      notifyListeners();
    } else {
      throw Exception('Login failed');
    }
  }

  Future<void> logout() async {
    _sessionManager.clearSession();
    notifyListeners();
  }
}
