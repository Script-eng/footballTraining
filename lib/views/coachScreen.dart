// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:footballtraining/loginPage.dart';
//
// class CoachScreen extends StatefulWidget {
//   const CoachScreen({super.key});
//
//   @override
//   _CoachScreenState createState() => _CoachScreenState();
// }
//
// class _CoachScreenState extends State<CoachScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Function to update player attendance
//   Future<void> _markAttendance(String playerId, bool isPresent) async {
//     await _firestore.collection('players').doc(playerId).update({
//       'attendance': isPresent,
//     });
//   }
//
//   // Logout function
//   void _logout(BuildContext context) async {
//     try {
//       await _auth.signOut();
//       // Navigate back to the login screen
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const Loginpage()),
//             (Route<dynamic> route) => false,
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Logout failed: $e")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.logout),
//           onPressed: () => _logout(context),
//         ),
//         title: const Text("Coach Screen"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: _firestore.collection('players').snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return const Center(child: Text("No players found"));
//             }
//
//             var players = snapshot.data!.docs;
//
//             return ListView.builder(
//               itemCount: players.length,
//               itemBuilder: (context, index) {
//                 var player = players[index];
//                 String playerId = player.id;
//                 String name = player['name'];
//                 bool isPresent = player['attendance'] ?? false;
//
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   child: ListTile(
//                     title: Text(name, style: const TextStyle(fontSize: 18)),
//                     trailing: Switch(
//                       value: isPresent,
//                       onChanged: (bool newValue) {
//                         _markAttendance(playerId, newValue);
//                       },
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

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

  // Maps to hold stats data
  Map<String, bool> attendance = {}; // Attendance state for each player
  Map<String, int> goals = {}; // Goals for each player
  Map<String, int> assists = {}; // Assists for each player
  Map<String, String> notes = {}; // Notes for each player

  // Function to update player attendance and stats
  Future<void> _saveSession(String playerId) async {
    await _firestore.collection('players').doc(playerId).update({
      'attendance': attendance[playerId],
      'goals': goals[playerId],
      'assists': assists[playerId],
      'notes': notes[playerId],
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

                // Initialize maps for each player
                if (!attendance.containsKey(playerId)) {
                  attendance[playerId] = isPresent;
                  goals[playerId] = 0;
                  assists[playerId] = 0;
                  notes[playerId] = '';
                }

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(name, style: const TextStyle(fontSize: 18)),
                          trailing: Switch(
                            value: attendance[playerId]!,
                            onChanged: (bool newValue) {
                              setState(() {
                                attendance[playerId] = newValue;
                              });
                            },
                          ),
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Goals',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              goals[playerId] = int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Assists',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              assists[playerId] = int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Notes',
                          ),
                          onChanged: (value) {
                            setState(() {
                              notes[playerId] = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            _saveSession(playerId);
                          },
                          child: const Text('Save Session'),
                        ),
                      ],
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
