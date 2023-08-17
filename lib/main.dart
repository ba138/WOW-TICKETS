import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wowtickets/Screens/splash_screen.dart';

import 'auth/auth_provider.dart';
import 'auth/session_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize SessionManager
    final sessionManager = SessionManager();
    sessionManager.init();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
