import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFFF27121),
              Color(0xFF654ea3),
              Color(0xFfeaafc8),
            ], begin: Alignment.topCenter)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 80,
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  Text(
                    "Welcome back",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                decoration:const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60)),
                ),
                child: Padding(
                  padding:const EdgeInsets.all(30),
                  child: Column(children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromRGBO(225, 95, 27, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10))
                        ],
                      ),
                      padding:const EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom:
                                    BorderSide(color: Color(0xFFEEEEEE)))),
                            child: TextField(
                              controller: emailController,
                              decoration:const  InputDecoration(
                                  hintText: "Email or Phone Number",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none),
                            ),
                          ),
                          Container(
                            padding:const EdgeInsets.all(10),
                            decoration:  const BoxDecoration(
                                border: Border(
                                    bottom:
                                    BorderSide(color: Color(0xFFEEEEEE)))),
                            child: TextField(
                              controller: passwordController,
                              decoration: const InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          //Text("Forgot Password?",style: TextStyle(color: Colors.grey),),
                          TextButton(
                            onPressed: () => print("forgot a lyam"),
                            child:const Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xFFF37A2B)),
                            child: Center(
                              // child: Text("Login",style: TextStyle(
                              //   color: Colors.white,
                              //   fontSize: 16,
                              //   fontWeight: FontWeight.bold
                              // ),
                              // ),
                              child: TextButton(
                                onPressed:() => null,

                                //     () {
                                //   loginUser(emailController.text,
                                //       passwordController.text, context);
                                // },
                                child:const  Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                          // Row(
                          //   children: <Widget>[
                          //     Expanded(
                          //       child: Container(
                          //         height:50,
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(50),
                          //               color: Colors.blueAccent
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(width: 30,),
                          //     Expanded(
                          //       child: Container(
                          //         height:50,
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(50),
                          //               color: Colors.blueAccent
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
//
// Future<void> loginUser(
//     String email, String password, BuildContext context) async {
//   try {
//     // Sign in the user with Firebase Authentication
//     UserCredential userCredential =
//         await FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//
//     // Retrieve the user's role from Firestore using their UID
//     DocumentSnapshot userDoc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userCredential.user!.uid)
//         .get();
//
//     String role = userDoc['role'];
//
//     // Navigate based on the user's role
//     if (role == 'admin') {
//       Navigator.push(context,
//           MaterialPageRoute(builder: (context) => const AdminScreen()));
//     } else if (role == 'receptionist') {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => const ReceptionistScreen()));
//     } else if (role == 'coach') {
//       Navigator.push(context,
//           MaterialPageRoute(builder: (context) => const CoachScreen()));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("No valid role assigned to this user")),
//       );
//     }
//   } catch (e) {
//     print("Error logging in: $e");
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Login Failed"),
//           content: Text(e.toString()),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
}


