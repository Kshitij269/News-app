import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app/models/country_data_model.dart';
import 'package:news_app/repository/auth_services.dart';
import 'package:news_app/screens/aboutus.dart';
import 'package:news_app/screens/category_screen.dart';
import 'package:news_app/screens/favouriteScreen.dart';
import 'package:news_app/screens/news_detail_screen.dart';
import 'package:news_app/screens/searchScreen.dart';
import 'package:news_app/utils/constants.dart';
import 'package:news_app/utils/flutter_news.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var authService = AuthService();
  String uid = '';
  final format = DateFormat('dd/MM/yyyy');
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    NewsViewModel newsViewModel = NewsViewModel();

    return Scaffold(
      appBar: AppBar(
        title: const Header(),
        elevation: 2,
      ),
      drawer: Drawer(
        child: StreamBuilder<Map<String, dynamic>>(
          stream: getUserDataStream(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
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
                        const SizedBox(height: 10),
                        Text(
                          username,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.book),
                    title: const Text('Favourite News'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FavouriteScreen()));
                    },
                  ),
                  const Divider(
                    height: 2,
                  ),
                  ListTile(
                    leading: const Icon(Icons.category),
                    title: const Text('Category News'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryScreen()));
                    },
                  ),
                  const Divider(
                    height: 2,
                  ),
                  ListTile(
                    leading: const Icon(Icons.search),
                    title: const Text('Search News'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreen()));
                    },
                  ),
                  const Divider(
                    height: 2,
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_rounded),
                    title: const Text('About'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AboutUs()));
                    },
                  ),
                  const Divider(
                    height: 2,
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text("Logout"),
                    onTap: () {
                      logOut(context);
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
      body: Column(children: [
        Container(
          height: height * .55,
          width: width,
          child: FutureBuilder<CountryHeadlinesModel>(
              future: newsViewModel.fetchCountryNewsApi(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitFadingCube(
                      size: 50,
                      color: kwhite,
                    ),
                  );
                } else {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data!.articles!.length > 10
                          ? 10
                          : snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => NewsDetailScreen(
                                          snapshot.data!.articles![index].url!,
                                          snapshot.data!.articles![index]
                                                  .urlToImage ??
                                              '',
                                          snapshot.data!.articles![index].title,
                                          snapshot.data!.articles![index]
                                                  .publishedAt ??
                                              'NULL',
                                          snapshot
                                              .data!.articles![index].author,
                                          snapshot.data!.articles![index]
                                              .description,
                                          snapshot
                                              .data!.articles![index].content,
                                        ))));
                          },
                          child: Container(
                            child:
                                Stack(alignment: Alignment.center, children: [
                              Container(
                                height: height * 0.5,
                                width: width * 0.9,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      child: spinkit,
                                    ),
                                    errorWidget: (context, url, error) {
                                      return Image.asset(
                                        'assets/error.png',
                                        // Adjust the width as needed
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 30,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  color: kwhite,
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    height: height * 0.22,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Container(
                                            width: width * 0.7,
                                            child: Text(
                                              snapshot
                                                  .data!.articles![index].title
                                                  .toString(),
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kdark,
                                                  fontSize: 14),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: width * 0.7,
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!.articles![index]
                                                            .author
                                                            .toString()
                                                            .length <
                                                        21
                                                    ? snapshot.data!
                                                        .articles![index].author
                                                        .toString()
                                                    : snapshot.data!
                                                        .articles![index].author
                                                        .toString()
                                                        .substring(0, 21),
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: kdark,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                format.format(dateTime),
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: kdark,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ]),
                          ),
                        );
                      });
                }
              }),
        ),
        Expanded(
          child: FutureBuilder<CountryHeadlinesModel>(
            future: newsViewModel.fetchCountryNewsApi(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SpinKitFadingCube(
                    size: 50,
                    color: kwhite,
                  ),
                );
              } else {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.articles!.length > 10
                      ? snapshot.data!.articles!.length - 10
                      : 0,
                  itemBuilder: (context, index) {
                    DateTime dateTime = DateTime.parse(snapshot
                        .data!.articles![index + 10].publishedAt
                        .toString());
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => NewsDetailScreen(
                                      snapshot.data!.articles![index + 10].url!,
                                      snapshot.data!.articles![index + 10]
                                              .urlToImage ??
                                          '',
                                      snapshot
                                          .data!.articles![index + 10].title,
                                      snapshot.data!.articles![index + 10]
                                              .publishedAt ??
                                          'NULL',
                                      snapshot
                                          .data!.articles![index + 10].author,
                                      snapshot.data!.articles![index + 10]
                                          .description,
                                      snapshot
                                          .data!.articles![index + 10].content,
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
                                    imageUrl: snapshot
                                        .data!.articles![index + 10].urlToImage
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot
                                            .data!.articles![index + 10].title
                                            .toString(),
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
                                            snapshot.data!.articles![index + 10]
                                                        .author
                                                        .toString()
                                                        .length <
                                                    10
                                                ? snapshot
                                                    .data!
                                                    .articles![index + 10]
                                                    .author
                                                    .toString()
                                                : snapshot
                                                    .data!
                                                    .articles![index + 10]
                                                    .author
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
              }
            },
          ),
        )
      ]),
    );
  }
}

const spinkit = SpinKitFadingCube(
  color: Colors.white,
  size: 50,
);
