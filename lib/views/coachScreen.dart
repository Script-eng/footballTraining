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

  Map<String, bool> attendance = {};
  Map<String, String> trainingType = {};
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(const Duration(hours: 2));

  String? selectedTeamName;
  String? coachUid;

  @override
  void initState() {
    super.initState();
    coachUid = _auth.currentUser?.uid;
  }

  void _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Loginpage()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _saveAttendance(String playerId) async {
    await _firestore.collection('players').doc(playerId).update({
      'Attendance.Presence': attendance[playerId] ?? false,
      'Attendance.Start_training': Timestamp.fromDate(startTime),
      'Attendance.Finish_training': Timestamp.fromDate(endTime),
      'Attendance.Training_type': trainingType[playerId] ?? 'Not specified',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Attendance saved')),
    );
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
      body: Column(
        children: [
          // 🔽 Team Selector Dropdown
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('teams')
                  .where('coach', isEqualTo: coachUid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                List<DropdownMenuItem<String>> teamItems =
                    snapshot.data!.docs.map((doc) {
                  final teamName = doc['team_name'];
                  return DropdownMenuItem<String>(
                    value: teamName,
                    child: Text(teamName),
                  );
                }).toList();

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Select a Team"),
                  items: teamItems,
                  value: selectedTeamName,
                  onChanged: (value) {
                    setState(() {
                      selectedTeamName = value;
                      attendance.clear();
                      trainingType.clear();
                    });
                  },
                );
              },
            ),
          ),

          // 👇 Show player list after selecting team
          Expanded(
            child: selectedTeamName == null
                ? const Center(child: Text("Please select a team"))
                : StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('players')
                        .where('team', isEqualTo: selectedTeamName)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const Center(child: CircularProgressIndicator());

                      final players = snapshot.data!.docs;

                      if (players.isEmpty) {
                        return const Center(
                            child: Text("No players in this team."));
                      }

                      return ListView.builder(
                        itemCount: players.length,
                        itemBuilder: (context, index) {
                          final player = players[index];
                          final playerId = player.id;
                          final data = player.data() as Map<String, dynamic>;
                          final name = data['name'];

                          final attendanceData =
                              data['Attendance'] as Map<String, dynamic>?;

                          // Initialize if not yet set
                          attendance[playerId] = attendance[playerId] ??
                              (attendanceData?['Presence'] ?? false);
                          trainingType[playerId] = trainingType[playerId] ??
                              (attendanceData?['Training_type'] ?? '');

                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  SwitchListTile(
                                    title: const Text("Present"),
                                    value: attendance[playerId]!,
                                    onChanged: (val) {
                                      setState(
                                          () => attendance[playerId] = val);
                                    },
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                      labelText: "Training Type",
                                      hintText: "e.g. Tactical, Physical...",
                                    ),
                                    onChanged: (val) =>
                                        trainingType[playerId] = val,
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () => _saveAttendance(playerId),
                                    child: const Text("Save Attendance"),
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
        ],
      ),
    );
  }
}
