import 'package:flutter/material.dart';
import 'package:wowtickets/constants.dart';

class Alert extends StatelessWidget {
  const Alert({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
      child: Card(
        child: Column(
          children: [
            const Text("Are you want to sync data"),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("No"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Yes"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
