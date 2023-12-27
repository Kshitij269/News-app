import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text("About Developer"),
        centerTitle: true,
      ),
      body: Container(
        height: height,
        width: width,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(top: 40)),
            CircleAvatar(
              backgroundImage: AssetImage('assets/kshitij.jpg'),
              radius: 100,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Kshitij Singh",
              style: TextStyle(fontSize: 24),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                  "Hello, my name is Kshitij Singh,a passionate App developer and Machine learning engineer.Currently i am in 2nd Year and just trying to learn new new technologies",
                  style: TextStyle(fontSize: 20),),
            ),
          ],
        ),
      ),
    );
  }
}
