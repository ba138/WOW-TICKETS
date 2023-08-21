// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wowtickets/constants.dart';

import '../Database_Helper/database_update.dart';
import '../auth/auth_provider.dart';

class Alert extends StatefulWidget {
  const Alert({super.key});

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = AuthProvider();

    return Dialog(
      backgroundColor: backgroundColor,
      child: Card(
        child: Column(
          children: [
            const Text("Are you want to sync data"),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("No"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var connectivityResult =
                        await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.mobile ||
                        connectivityResult == ConnectivityResult.wifi) {
                      final dbUpdater = DatabaseUpdater();
                      await dbUpdater.initDatabase();
                      dbUpdater.performPatchAction(
                        context,
                      );
                      Navigator.pop(context);
                      // Connected to mobile data or Wi-Fi
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please check your internet connection",
                        backgroundColor: wrongColor,
                        textColor: backgroundColor,
                      ); // Not connected
                    }
                  },
                  child: const Text("Yes"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
