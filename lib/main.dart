import 'package:flutter/material.dart';
import 'package:footballtraining/firebaseConfig.dart';
// ✅ Ensure FirebaseAuth is imported

import 'loginPage.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // ✅ Ensures Flutter bindings are ready
  await FirebaseConfig.initializeFirebase(); // ✅ Firebase initializes only once
  runApp(const MyApp());
}

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
