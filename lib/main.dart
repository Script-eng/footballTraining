import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footballtraining/firebaseConfig.dart';
// ✅ Ensure FirebaseAuth is imported

import 'loginPage.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // ✅ Ensures Flutter bindings are ready
  await FirebaseConfig.initializeFirebase(); // ✅ Firebase initializes only once
// ✅ Run this once, then comment it out to prevent duplicate entries
  //await addSamplePlayers();
  runApp(const MyApp());
}

// ***********************************************************//
// ✅ Function to add sample players to Firestore
// Future<void> addSamplePlayers() async {
//   var players = [
//     {"name": "John Doe", "age": 22, "position": "Forward"},
//     {"name": "David Smith", "age": 24, "position": "Midfielder"},
//     {"name": "Mike Johnson", "age": 21, "position": "Defender"},
//   ];
//
//   for (var player in players) {
//     await FirebaseFirestore.instance.collection('players').add({
//       'name': player['name'],
//       'age': player['age'],
//       'position': player['position'],
//       'attendance': false, // Default attendance
//       'stats': {'goals': 0, 'assists': 0},
//       'injuries': [],
//     });
//   }
//   print("✅ Sample players added successfully!");
// }
// ***********************************************************//

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Loginpage(),
    );
  }
}
