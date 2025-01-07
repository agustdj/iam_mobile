// import 'package:flutter/material.dart';
// import 'package:iam_mobile/services/InternshipService.dart';
// import 'package:iam_mobile/models/student.dart';

// class StudentInfoScreen extends StatefulWidget {
//   @override
//   _StudentInfoScreenState createState() => _StudentInfoScreenState();
// }

// class _StudentInfoScreenState extends State<StudentInfoScreen> {
//   late Future<Map<String, dynamic>> userDetails;

//   @override
//   void initState() {
//     super.initState();
//     userDetails = IntershipService().fetchUserDetails();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Student Information'),
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: userDetails,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             final userData = snapshot.data!;
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Name: ${userData['name']}',
//                       style: TextStyle(fontSize: 18)),
//                   Text('Class: ${userData['class']}',
//                       style: TextStyle(fontSize: 18)),
//                   Text('Department: ${userData['department']}',
//                       style: TextStyle(fontSize: 18)),
//                   Text('Major: ${userData['major']}',
//                       style: TextStyle(fontSize: 18)),
//                 ],
//               ),
//             );
//           } else {
//             return Center(child: Text('No data available.'));
//           }
//         },
//       ),
//     );
//   }
// }
