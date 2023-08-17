import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:wowtickets/Screens/login_screen.dart';
import 'package:wowtickets/constants.dart';

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
    await Future.delayed(
      const Duration(seconds: 7),
    );
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LogInScreen(),
      ),
    );
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
