import 'package:barcode_scan3/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wowtickets/constants.dart';

class QRCodeScreen extends StatefulWidget {
  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  String qrCodeResult = "Scan a QR code";

  Future<void> scanQRCode() async {
    try {
      String result = (await BarcodeScanner.scan()) as String;
      setState(() {
        qrCodeResult = result;
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
      appBar: AppBar(
        title: const Text(
          'WOW TICKETS',
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
          ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      primaryColor, // Background color of the button
                  // Text (foreground) color of the button
                ),
                child: Text('Scan QR Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
