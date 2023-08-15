import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  // void initState() {
  //   super.initState();
  //   delay();
  // }

  // void delay() async {
  //   await Future.delayed(const Duration(seconds: 7));
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => const Login()));
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   height: MediaQuery.of(context).size.height / 10,
            //   width: MediaQuery.of(context).size.width / 8,
            //   decoration: const BoxDecoration(
            //       image: DecorationImage(
            //     image: AssetImage('images/splash.png'),
            //   )),
            // ),
            Center(
              child: TextLiquidFill(
                boxHeight: MediaQuery.of(context).size.height / 8,
                text: 'WOW\nTICKETS',
                textStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 30,
                ),
                waveColor: const Color(0xffEF5464),
                waveDuration: const Duration(seconds: 4),
                boxBackgroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
