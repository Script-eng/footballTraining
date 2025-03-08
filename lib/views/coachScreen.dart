import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footballtraining/loginPage.dart';

class CoachScreen extends StatefulWidget {
  const CoachScreen({super.key});

  @override
  _CoachScreenState createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to update player attendance
  Future<void> _markAttendance(String playerId, bool isPresent) async {
    await _firestore.collection('players').doc(playerId).update({
      'attendance': isPresent,
    });
  }

  // Logout function
  void _logout(BuildContext context) async {
    try {
      await _auth.signOut();
      // Navigate back to the login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Loginpage()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => _logout(context),
        ),
        title: const Text("Coach Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('players').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No players found"));
            }

            var players = snapshot.data!.docs;

            return ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                var player = players[index];
                String playerId = player.id;
                String name = player['name'];
                bool isPresent = player['attendance'] ?? false;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(name, style: const TextStyle(fontSize: 18)),
                    trailing: Switch(
                      value: isPresent,
                      onChanged: (bool newValue) {
                        _markAttendance(playerId, newValue);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
