import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() => _instance;

  SessionManager._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void saveToken(String token) {
    _prefs?.setString('token', token);
  }

  String? getToken() {
    return _prefs?.getString('token');
  }

  void clearSession() {
    _prefs?.remove('token');
  }
}
