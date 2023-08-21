// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wowtickets/Screens/home_screen.dart';
import 'package:wowtickets/Screens/login_screen.dart';
import 'package:wowtickets/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (authProvider.isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
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
      // Connected to mobile data or Wi-Fi
    } else {
      Fluttertoast.showToast(
        msg: "Please check your internet connection",
        backgroundColor: wrongColor,
        textColor: backgroundColor,
      );
      Navigator.pop(context);
      // Not connected
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
            SvgPicture.asset(
              'images/logo.svg',
              color: primaryColor,
              height: 120,
            ),
            Center(
              child: Text(
                "Scann",
                style: TextStyle(
                    fontFamily: "Poppins", fontSize: 24, color: primaryColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
