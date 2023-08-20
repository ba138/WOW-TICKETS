import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:wowtickets/Screens/home_screen.dart';
import 'package:wowtickets/Screens/splash_screen.dart';
import 'dart:convert';
import 'package:wowtickets/auth/session_manager.dart';
import 'package:wowtickets/constants.dart';

import '../utills/utills.dart';

class AuthProvider with ChangeNotifier {
  final SessionManager _sessionManager = SessionManager();

  bool get isLoggedIn => _sessionManager.getToken() != null;

  Future<void> initAuthProvider() async {
    await _sessionManager.init();
    notifyListeners();
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    final url = Uri.parse(
        'https://wow-tickets-app-staging.up.railway.app/api/users/signin?');
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          PrograssDialog(message: "Login please wait..."),
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    Navigator.pop(context);
    bool isSeller = jsonDecode(response.body)["isSeller"];
    sellerID = jsonDecode(response.body)["_id"] as String;

    if (response.statusCode == 200 && isSeller == true) {
      final responseData = json.decode(response.body);
      final token = jsonDecode(response.body)['token'] as String;

      _sessionManager.saveToken(token);
      _sessionManager.saveSellerID(sellerID);

      notifyListeners();

      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (c) => const HomeScreen()),
          (route) => false);
    } else {
      Fluttertoast.showToast(msg: "Unable to Login");
    }
  }

  Future<void> logout(BuildContext context) async {
    _sessionManager.clearSession();
    notifyListeners();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (c) => const SplashScreen()),
        (route) => false);
  }
}
