// import 'package:flutter/material.dart';

// import '../Database_Helper/database_data.dart';
// import '../assistant/Models/tickets_model.dart';

// class DataScreen extends StatefulWidget {
//   @override
//   // ignore: library_private_types_in_public_api
//   _DataScreenState createState() => _DataScreenState();
// }

// class _DataScreenState extends State<DataScreen> {
//   @override
//   void initState() {
//     super.initState();
//     dbHelper.initDatabase();
//   }

//   final DatabaseData dbHelper = DatabaseData();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('SQLite Demo'),
//       ),
//       body: FutureBuilder<List<Ticket>>(
//         future: dbHelper.getTickets(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No ticket data available.'));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 final ticket = snapshot.data![index];
//                 return ListTile(
//                   title: Text('Ticket ID: ${ticket.id}'),
//                   subtitle: Text('User: ${ticket.user}'),
//                   trailing:
//                       Text('Status: ${ticket.status ? 'Active' : 'Inactive'}'),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
