import 'package:flutter/material.dart';
import 'package:wowtickets/Screens/qrc_screen.dart';
import 'package:wowtickets/auth/auth_provider.dart';
import 'package:wowtickets/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => const QrCodeScanScreen(),
                    ),
                  );
                },
                child: Container(
                  width: (MediaQuery.of(context).size.width / 4),
                  height: (MediaQuery.of(context).size.width / 4),
                  child: Card(
                    color: primaryColor,
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            size: 60,
                            color: Colors.white,
                          ),
                          Text(
                            "Scann",
                            style: TextStyle(
                                fontFamily: "Poppins", color: Colors.white),
                          )
                        ]),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => const QrCodeScanScreen(),
                    ),
                  );
                },
                child: Container(
                  width: (MediaQuery.of(context).size.width / 4),
                  height: (MediaQuery.of(context).size.width / 4),
                  child: Card(
                    color: primaryColor,
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.download,
                            size: 60,
                            color: Colors.white,
                          ),
                          Text(
                            "Import",
                            style: TextStyle(
                                fontFamily: "Poppins", color: Colors.white),
                          )
                        ]),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => const QrCodeScanScreen(),
                    ),
                  );
                },
                child: Container(
                  width: (MediaQuery.of(context).size.width / 4),
                  height: (MediaQuery.of(context).size.width / 4),
                  child: Card(
                    color: primaryColor,
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.import_export_outlined,
                            size: 60,
                            color: Colors.white,
                          ),
                          Text(
                            "Sync",
                            style: TextStyle(
                                fontFamily: "Poppins", color: Colors.white),
                          )
                        ]),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  AuthProvider authProvider = AuthProvider();
                  authProvider.logout(context);
                },
                child: Container(
                  width: (MediaQuery.of(context).size.width / 4),
                  height: (MediaQuery.of(context).size.width / 4),
                  child: Card(
                    color: primaryColor,
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            size: 60,
                            color: Colors.white,
                          ),
                          Text(
                            "Logout",
                            style: TextStyle(
                                fontFamily: "Poppins", color: Colors.white),
                          )
                        ]),
                  ),
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
