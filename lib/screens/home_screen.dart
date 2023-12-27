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

  logOut(BuildContext context) {
    authService.logOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Header(),
        elevation: 2,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    // You can replace the placeholder image with the user's profile image
                    backgroundImage: NetworkImage(
                      'https://i.stack.imgur.com/l60Hf.png',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'User Name', // Replace with the actual user's name
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorites'),
              onTap: () {
                // Handle the Favorites action
              },
            ),
            Divider(thickness: 2,),
            
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle the Settings action
              },
            ),
            Divider(thickness: 2,),
            
            ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutUs()));
                }),
            Divider(thickness: 2,),
            
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                logOut(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
