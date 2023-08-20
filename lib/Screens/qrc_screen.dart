// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:wowtickets/Database_Helper/database_update.dart';
import 'package:wowtickets/Screens/home_screen.dart';
import 'package:wowtickets/assistant/Models/compare_model.dart';
import 'package:wowtickets/constants.dart';

class QRScanScreen extends StatefulWidget {
  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(_processScannedQRCode);
  }

  void _processScannedQRCode(Barcode scannedBarcode) async {
    try {
      String scannedQRData = scannedBarcode.code!;
      Map<String, dynamic> qrData = jsonDecode(scannedQRData);
      String purchaseId = qrData['purchase'];
      bool newStatus = false;

      DatabaseUpdater dbHelper = DatabaseUpdater();
      await dbHelper.initDatabase();

      Compare? ticket = await dbHelper.getTicketByPurchaseId(purchaseId);

      if (ticket != null) {
        if (ticket.status != newStatus) {
          await dbHelper.updateTicketStatus(ticket.id, newStatus);

          if (purchaseId == ticket.id) {
            await dbHelper.storePurchaseId(purchaseId);
          }
          Fluttertoast.showToast(
              msg: "Status Verified", backgroundColor: Colors.green);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (c) => const HomeScreen()),
              (route) => false);
        } else {
          Fluttertoast.showToast(
            msg: "Status Expired",
            backgroundColor: Colors.green,
            textColor: backgroundColor,
          );
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Ticket not found',
            backgroundColor: Colors.red,
            textColor: backgroundColor);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Invalid QR Code',
          backgroundColor: Colors.red,
          textColor: backgroundColor);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }
}
