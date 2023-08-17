// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:wowtickets/Screens/login_screen.dart';
import 'package:wowtickets/Screens/qrc_screen.dart';
import 'package:wowtickets/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../auth/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    delay();
  }

  void delay() async {
    AuthProvider authProvider = AuthProvider();
    await authProvider.initAuthProvider();

    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (authProvider.isLoggedIn) {
      debugPrint("loged in user");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const QrCodeScanScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LogInScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: TextLiquidFill(
                boxHeight: MediaQuery.of(context).size.height / 8,
                text: 'WOW\nTICKETS',
                textStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: backgroundColor,
                  fontSize: 30,
                ),
                waveColor: primaryColor,
                waveDuration: const Duration(seconds: 4),
                boxBackgroundColor: backgroundColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
