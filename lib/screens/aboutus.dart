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
        title: Text("About Developer"),
        centerTitle: true,
      ),
      body: Container(
        height: height,
        width: width,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(top:40)),
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider('assets/kshitij.jpg'),
              radius: 60,
            )
          ],
        ),
      ),
    );
  }
}
