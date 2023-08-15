import 'package:barcode_scan3/model/scan_result.dart';
import 'package:barcode_scan3/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  String qrCodeResult = "Scan a QR code";

  Future<void> scanQRCode() async {
    try {
      ScanResult result = await BarcodeScanner.scan();
      setState(() {
        qrCodeResult = result as String;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          qrCodeResult = "Camera permission denied";
        });
      } else {
        setState(() {
          qrCodeResult = "Error: $ex";
        });
      }
    } on FormatException {
      setState(() {
        qrCodeResult = "Scan canceled";
      });
    } catch (ex) {
      setState(() {
        qrCodeResult = "Error: $ex";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code Scanner')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              qrCodeResult,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: scanQRCode,
              child: const Text('Scan QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
