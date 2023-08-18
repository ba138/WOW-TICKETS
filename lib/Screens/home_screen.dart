import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wowtickets/Screens/qrc_screen.dart';
// import 'package:wowtickets/assistant/data_assistant.dart';
import 'package:wowtickets/auth/auth_provider.dart';
import 'package:wowtickets/constants.dart';

import '../Database_Helper/database_helper.dart';
import '../assistant/Models/order_Model.dart';
import '../assistant/Models/tickets_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void insertDataFromJsonResponse(String jsonResponse) async {
    try {
      List<Map<String, dynamic>> orderList = jsonDecode(jsonResponse);

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

      debugPrint('Data inserted successfully');
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
                  String jsonResponse =
                      'https://wow-tickets-app-staging.up.railway.app/api/orders/sales?seller_id=$sellerID';
                  insertDataFromJsonResponse(jsonResponse);
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
                onTap: () {},
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
