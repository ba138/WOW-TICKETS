import 'package:flutter/material.dart';

import '../constants.dart';

// ignore: must_be_immutable
class PrograssDialog extends StatelessWidget {
  PrograssDialog({super.key, this.message});
  String? message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 6.0,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
            const SizedBox(
              width: 26.0,
            ),
            Text(
              message!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
