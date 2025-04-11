// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:footballtraining/loginPage.dart';
import 'package:google_fonts/google_fonts.dart'; // Replace with your actual login screen import

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  //*******************************************************************************/
  String searchQuery = "";
  int currentTab = 0;
  List<String> tabs = ["Attendances", "Players", "Teams"];
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void initState() {
    super.initState();
    _getUserName();
    _getMail();
  }

  String? userName;
  String? email;
  Future<void> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        userName = doc['name']; // 👈 assuming the field is called 'name'
      });
    }
  }

  Future<void> _getMail() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      setState(() {
        email = doc['email']; // 👈 assuming the field is called 'name'
      });
    }
  }

  //*******************************************************************************/

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.logout),
          //     onPressed: () => _logout(context),
          //     // _logout(context), // Call the logout function
          //   ),
          // ],
          // ignore: prefer_interpolation_to_compose_strings
          title: Text(userName != null ? "Hi $userName" : "Loading..."),
        ),
        drawer: Drawer(
          // 🔶 Drawer starts here
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF27121), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/admin.jpeg'),
                          radius: 45,
                          backgroundColor: Colors.white),
                      const SizedBox(height: 10),
                      Text(email != null ? "$email" : "Loading...",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18)),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.black87),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context); // 🔴 This closes the drawer
                    // Navigate to Profile
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.black87),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context); // 🔴 Close drawer
                    // Navigate to Settings
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.black87),
                  title: const Text('Logout'),
                  onTap: () => _logout(context),
                  //     // _logout(context), // Call the logout function
                  //   ),
                ),
              ],
            ),
          ),
        ), // 🔶 Drawer ends here
        body: Column(
          children: <Widget>[
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(
                        tabs[index],
                        style: GoogleFonts.ubuntu(
                          fontSize: currentTab == index ? 17 : 15,
                          fontWeight: currentTab == index
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color:
                              currentTab == index ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }

  // Logout function
  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to the login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const Loginpage()), // Replace with your login screen widget
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      // Handle errors if any
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: $e")),
      );
    }
  }
}
