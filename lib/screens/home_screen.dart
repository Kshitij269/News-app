import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/repository/auth_services.dart';
import 'package:news_app/screens/aboutus.dart';
import 'package:news_app/utils/constants.dart';
import 'package:news_app/utils/flutter_news.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var authService = AuthService();
  String uid = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  logOut(BuildContext context) {
    authService.logOut(context);
  }

  @override
  void initState() {
    super.initState();
    getuid();
  }

  getuid() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

  Stream<Map<String, dynamic>> getUserDataStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        return {}; // Return an empty map if the document doesn't exist
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Header(),
        elevation: 2,
      ),
      drawer: Drawer(
        child: StreamBuilder<Map<String, dynamic>>(
          stream: getUserDataStream(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              final userData = snapshot.data ?? {};
              final String username = userData['username'] ?? '';
              final String photoUrl =
                  userData['image'] ?? 'https://i.stack.imgur.com/l60Hf.png';
              print(photoUrl);
              return Column(
                children: [
                  DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(photoUrl),
                        ),
                        SizedBox(height: 10),
                        Text(
                          username,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.book),
                    title: Text('Favourite News'),
                    onTap: () {
                      // Handle onTap for favourite news
                    },
                  ),
                  Divider(
                    height: 2,
                  ),
                  ListTile(
                    leading: Icon(Icons.category),
                    title: Text('Category News'),
                    onTap: () {
                      // Handle onTap for favourite news
                    },
                  ),
                  Divider(
                    height: 2,
                  ),

                  ListTile(
                    leading: Icon(Icons.info_rounded),
                    title: Text('About'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AboutUs()));
                    },
                  ),
                  Divider(
                    height: 2,
                  ),

                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                    onTap: () {
                      logOut(context);
                    },
                  ),

                  // Add more drawer items as needed
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
