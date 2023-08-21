// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:wowtickets/auth/auth_provider.dart';
import 'package:wowtickets/constants.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool isSecure = false;
  @override
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = AuthProvider();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                SvgPicture.asset(
                  'images/logo.svg',
                  color: primaryColor,
                  height: 80,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    hintText: 'please enter your email',
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 7 / 2,
                  child: TextFormField(
                    obscureText: isSecure,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(),
                      hintText: 'please enter your password',
                      labelText: 'Password',
                      suffix: IconButton(
                        onPressed: () {},
                        icon: Icon(
                            isSecure ? Icons.visibility_off : Icons.visibility),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                ),
                GestureDetector(
                  onTap: () async {
                    var connectivityResult =
                        await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.mobile ||
                        connectivityResult == ConnectivityResult.wifi) {
                      authProvider.login(
                        _emailController.text,
                        _passwordController.text,
                        context,
                      );
                      // Connected to mobile data or Wi-Fi
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please check your internet connection",
                        backgroundColor: wrongColor,
                        textColor: backgroundColor,
                      ); // Not connected
                    }
                  },
                  child: Container(
                    height: 64,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      border: Border.all(
                        width: 1,
                        color: primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: "poppins",
                            color: backgroundColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
