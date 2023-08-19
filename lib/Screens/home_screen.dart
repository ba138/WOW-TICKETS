import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wowtickets/Screens/data_screen.dart';
import 'package:wowtickets/Screens/qrc_screen.dart';
// import 'package:wowtickets/assistant/data_assistant.dart';
import 'package:wowtickets/auth/auth_provider.dart';
import 'package:wowtickets/constants.dart';
import 'package:http/http.dart' as http;
import '../Database_Helper/database_helper.dart';
import '../assistant/Models/order_Model.dart';
import '../assistant/Models/tickets_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void insertDataFromJsonResponse() async {
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

      Fluttertoast.showToast(
        msg: "data has been import",
      );
    } catch (e) {
      debugPrint("this is function number 4 : $e");
    }
  }

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
                  debugPrint(
                    "This is sellerID = $sellerID",
                  );

                  insertDataFromJsonResponse();
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => DataScreen(),
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
