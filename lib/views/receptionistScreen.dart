import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footballtraining/loginPage.dart';
import 'package:footballtraining/views/addEntryDialog.dart';
import 'package:google_fonts/google_fonts.dart';

class ReceptionistScreen extends StatefulWidget {
  const ReceptionistScreen({super.key});

  @override
  State<ReceptionistScreen> createState() => _ReceptionistScreenState();
}

class _ReceptionistScreenState extends State<ReceptionistScreen> {
  int currentTab = 0;
  String searchQuery = "";

  List<String> tabs = ["Coaches", "Players", "Teams"];

  // Function to get stream based on tab selection
  Stream<QuerySnapshot> getStreamForCurrentTab() {
    String role = currentTab == 0
        ? "coach"
        : currentTab == 1
            ? "player"
            : "team";

    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: role)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => _logout(context),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF27121), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: const Text("Receptionist Screen"),
      ),
      body: Column(
        children: <Widget>[
          // 🔹 Tab Selection (Coaches, Players, Teams)
          SizedBox(
            width: size.width,
            height: size.height * 0.05,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentTab = index;
                      searchQuery = ""; // Reset search when changing tabs
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      tabs[index],
                      style: GoogleFonts.ubuntu(
                        fontSize: currentTab == index ? 17 : 15,
                        fontWeight: currentTab == index
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: currentTab == index ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(thickness: 2, color: Color(0xFFF27121)),

          // 🔹 Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search ${tabs[currentTab]}...",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),

          // 🔹 Fetch Users from Firestore based on role
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getStreamForCurrentTab(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No ${tabs[currentTab]} found"));
                }

                var users = snapshot.data!.docs.where((doc) {
                  return doc['name']
                      .toString()
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user['picture'] != null &&
                                  user['picture'].isNotEmpty
                              ? NetworkImage(user['picture'])
                              : AssetImage("assets/default_profile.png")
                                  as ImageProvider,
                          radius: 25,
                        ),
                        title: Text(user['name'],
                            style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Text(user['role_description'] ?? "",
                            style: GoogleFonts.ubuntu(
                                color: Colors.grey, fontSize: 13)),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == "delete") {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.id)
                                  .delete();
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                                value: "delete",
                                child: Text("Delete",
                                    style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 🔹 Add Button (Dynamically Changes for Coach/Player/Team)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF27121),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddEntryDialog(
                    role: currentTab == 0
                        ? "coach"
                        : currentTab == 1
                            ? "player"
                            : "team",
                  ),
                );
              },
              child: Text(
                "Add ${tabs[currentTab]}",
                style: GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Logout function
  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Loginpage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: $e")),
      );
    }
  }
}
