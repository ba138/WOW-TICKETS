// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:wowtickets/Database_Helper/database_update.dart';

// class QrCodeScanScreen extends StatefulWidget {
//   const QrCodeScanScreen({super.key});

//   @override
//   State<QrCodeScanScreen> createState() => _QrCodeScanScreenState();
// }

// class _QrCodeScanScreenState extends State<QrCodeScanScreen> {
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
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:wowtickets/Database_Helper/database_update.dart';

import '../assistant/Models/tickets_model.dart';

class QRScanScreen extends StatefulWidget {
  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  late DatabaseUpdater dbHelper;
  late QRViewController controller;
  bool scanning = false;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseUpdater();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!scanning) {
        setState(() {
          scanning = true;
        });
        processScannedQRCode(scanData.code!);
      }
    });
  }

  Future<void> processScannedQRCode(String scannedTicketId) async {
    await dbHelper.initDatabase();
    debugPrint("this is scannedTicketID: $scannedTicketId ");

    Ticket? ticket = await dbHelper.getTicketById(scannedTicketId);

    if (ticket != null) {
      bool newStatus = !ticket.status;
      await dbHelper.updateTicketStatus(scannedTicketId, newStatus);

      String message =
          newStatus ? 'Ticket marked as used' : 'Ticket status reverted';
      Fluttertoast.showToast(msg: message);
    } else {
      Fluttertoast.showToast(msg: 'Ticket not found');
    }

    setState(() {
      scanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: QRView(
        key: GlobalKey(debugLabel: 'QR'),
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }
}
