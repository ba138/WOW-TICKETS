// ignore_for_file: file_names

import 'tickets_model.dart';

class Order {
  final String id;
  final List<Ticket> purchasedTickets;

  Order({required this.id, required this.purchasedTickets});
}
