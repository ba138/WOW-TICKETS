// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wowtickets/constants.dart';

import '../Database_Helper/database_update.dart';

class Alert extends StatefulWidget {
  const Alert({super.key});

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
      child: Container(
        height: 150,
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                const Text(
                  "Are you want to sync data",
                  style: TextStyle(fontSize: 18, fontFamily: "Poppins"),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          child: const Text("No"),
                        ),
                      ),
                      Container(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () async {
                            var connectivityResult =
                                await (Connectivity().checkConnectivity());
                            if (connectivityResult ==
                                    ConnectivityResult.mobile ||
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          child: const Text("Yes"),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
