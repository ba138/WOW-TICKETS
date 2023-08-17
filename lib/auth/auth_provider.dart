import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> initAuthProvider() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _isLoggedIn = _token != null;
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
      debugPrint(token);
      _token = token;
      _isLoggedIn = true;
      await _saveTokenToPrefs(token);
      notifyListeners();
    } else {
      throw Exception('Login failed');
    }
  }

  Future<void> _saveTokenToPrefs(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    _token = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
