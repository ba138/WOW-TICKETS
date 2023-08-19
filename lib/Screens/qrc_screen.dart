// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:wowtickets/Database_Helper/database_update.dart';

// class QRScanScreen extends StatefulWidget {
//   const QRScanScreen({super.key});

//   @override
//   State<QRScanScreen> createState() => _QRScanScreenState();
// }

// class _QRScanScreenState extends State<QRScanScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   DatabaseUpdater dbHelper = DatabaseUpdater();
//   bool scanning = false;
//   String scannedTicketId = '';

//   Barcode? result;
//   QRViewController? controller;

//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     } else if (Platform.isIOS) {
//       controller!.resumeCamera();
//     }
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//       });
//     });
//   }

//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             flex: 5,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Center(
//               child: (result != null)
//                   ? Text(
//                       'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
//                   : const Text('Scan a code'),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:wowtickets/Database_Helper/database_update.dart';
import 'package:wowtickets/assistant/Models/compare_model.dart';

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

          String message = 'Ticket ID: ${ticket.id} - Status updated';
          Fluttertoast.showToast(msg: message);
        } else {
          String message =
              'Ticket ID: ${ticket.id} - Status already up to date';
          Fluttertoast.showToast(msg: message);
        }
      } else {
        Fluttertoast.showToast(msg: 'Ticket not found');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Invalid QR Code');
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
