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
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Please Login into your account",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(
                          fontFamily: "Poppins", color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Please enter your email',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Password",
                      style: TextStyle(
                          fontFamily: "Poppins", color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 7 / 2,
                  child: TextFormField(
                    obscureText: isSecure,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: 'please enter your password',
                      suffix: IconButton(
                        onPressed: () {},
                        icon: Icon(
                            isSecure ? Icons.visibility_off : Icons.visibility),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 14,
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
                    height: 60,
                    width: double.infinity,
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
