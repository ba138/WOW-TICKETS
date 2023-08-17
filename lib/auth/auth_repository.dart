import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
  Future<void> loginUser(String email, String password) async {
    final url =
        Uri.parse('https://wow-tickets-app-staging.up.railway.app/signin');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Successful login
      print('Login successful');
      print('Response: ${response.body}');
    } else {
      // Login failed
      print('Login failed');
      print('Response: ${response.body}');
    }
  }
}
