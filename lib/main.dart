import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/splash_screen.dart';
import 'auth/auth_provider.dart';
import 'auth/session_manager.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => SessionManager()),
        // Other providers if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize SessionManager
      future: Provider.of<SessionManager>(context, listen: false).init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
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
        } else {
          return const CircularProgressIndicator(); // Show loading indicator while initializing SessionManager
        }
      },
    );
  }
}
