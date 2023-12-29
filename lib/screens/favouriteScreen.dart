import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:news_app/screens/news_detail_screen.dart';
import 'package:news_app/utils/constants.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  String uid = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final format = DateFormat('dd/MM/yyyy');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourite Articles"),
        centerTitle: true,
      ),
      body: Expanded(
        child: StreamBuilder(
            stream: _firestore
                .collection('favourites')
                .doc(uid)
                .collection('articles')
                .snapshots(), // Add your favourites articles stream here
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: spinkit,
                );
              }
              List<Map<String, dynamic>> data = snapshot.data!.docs
                  .map((DocumentSnapshot document) =>
                      document.data() as Map<String, dynamic>)
                  .toList();
              print(data);

              return ListView.builder(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  DateTime dateTime = DateTime.parse(
                      data[index]['date']);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => NewsDetailScreen(
                                    data[index]['url'],
                                    data[index]['newsImage'] ?? '',
                                    data[index]['title'],
                                    data[index]['date'] ?? 'NULL',
                                    data[index]['author'],
                                    data[index]['newsDesc'],
                                    data[index]['newsContent'],
                                  ))));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        color: kwhite,
                        elevation: 4,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 80, // Adjust the width as needed
                                child: CachedNetworkImage(
                                  imageUrl: data[index]['newsImage']
                                      .toString(),
                                  placeholder: (context, url) => Container(
                                    child: spinkit,
                                  ),
                                  errorWidget: (context, url, error) {
                                    return Image.asset(
                                      'assets/error.png',
                                      width: 80, // Adjust the width as needed
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data[index]['title'],
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kdark,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          data[index]['author']
                                                      .toString()
                                                      .length <
                                                  10
                                              ? data[index]['author'].toString()
                                              : data[index]['author']
                                                  .toString()
                                                  .substring(0, 10),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: kdark,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          format.format(dateTime),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: kdark,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}

const spinkit = SpinKitFadingCube(
  color: Colors.white,
  size: 50,
);
