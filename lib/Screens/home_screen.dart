// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wowtickets/Database_Helper/database_data.dart';
import 'package:wowtickets/Database_Helper/database_update.dart';
import 'package:wowtickets/Screens/qrc_screen.dart';
import 'package:wowtickets/auth/auth_provider.dart';
import 'package:wowtickets/constants.dart';
import 'package:http/http.dart' as http;
import '../Database_Helper/database_helper.dart';
import '../assistant/Models/order_Model.dart';
import '../assistant/Models/tickets_model.dart';
import '../auth/session_manager.dart';
import '../utills/utills.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void insertDataFromJsonResponse(String sellerID) async {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          PrograssDialog(message: "Importing please wait..."),
    );
    try {
      final url = Uri.parse(
          'https://wow-tickets-app-staging.up.railway.app/api/orders/sales?seller_id=$sellerID');

      final respone = await http.get(url);
      debugPrint(respone.body);
      List<Map<String, dynamic>> orderList = List<Map<String, dynamic>>.from(
        jsonDecode(respone.body),
      );

      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.initDatabase();

      for (var orderMap in orderList) {
        Order order = Order(
          id: orderMap['_id'],
          purchasedTickets: [],
        );

        List<dynamic> ticketList = orderMap['purchasedTickets'];
        for (var ticketMap in ticketList) {
          Ticket ticket = Ticket(
            id: ticketMap['_id'],
            user: ticketMap['user'],
            status: ticketMap['status'],
          );
          order.purchasedTickets.add(ticket);
        }

        await dbHelper.insertOrder(order);
        for (var ticket in order.purchasedTickets) {
          await dbHelper.insertTicket(ticket, order.id);
        }
      }
      Navigator.pop(context);

      Fluttertoast.showToast(
        msg: "Data has been import",
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Unable to import data");
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = AuthProvider();
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 40,
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              'images/logo.svg',
              color: primaryColor,
              height: 120,
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
                        builder: (c) => QRScanScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 2.5),
                    height: (MediaQuery.of(context).size.width / 2.5),
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
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    String? sellerID =
                        Provider.of<SessionManager>(context, listen: false)
                            .getSellerID();
                    if (sellerID != null) {
                      insertDataFromJsonResponse(sellerID);
                    } else {
                      Fluttertoast.showToast(msg: "Seller ID is empty");
                    }
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 2.5),
                    height: (MediaQuery.of(context).size.width / 2.5),
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
                                fontFamily: "Poppins",
                                color: Colors.white,
                              ),
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
                  onTap: () async {
                    final dbUpdater = DatabaseUpdater();
                    await dbUpdater.initDatabase();
                    dbUpdater.performPatchAction(
                      context,
                    );
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 2.5),
                    height: (MediaQuery.of(context).size.width / 2.5),
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
                              fontFamily: "Poppins",
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    authProvider.logout(context);
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 2.5),
                    height: (MediaQuery.of(context).size.width / 2.5),
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
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      )),
    );
  }
}
