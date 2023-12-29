import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categories_new_model.dart';
import 'package:news_app/screens/news_detail_screen.dart';
import 'package:news_app/utils/constants.dart';
import 'package:news_app/view_model/news_view_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String selected = 'business';
  final format = DateFormat('dd/MM/yyyy');

  List<String> items = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology'
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    NewsViewModel newsViewModel = NewsViewModel();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Category News"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: width,
                height: 60,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selected = items[index];
                            print(selected);
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(10),
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kBlueDark),
                          child: Center(
                              child: Text(
                            items[index],
                            style: const TextStyle(
                              color: kwhite,
                            ),
                          )),
                        ),
                      );
                    })),
              ),
            ),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoryNewsApi(selected),
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
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.articles!.length,
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Card(
                              color: kwhite,
                              elevation: 4,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                height: height * 0.15,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 80, // Adjust the width as needed
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        placeholder: (context, url) =>
                                            Container(
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
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot
                                                .data!.articles![index].title
                                                .toString(),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: kdark,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!.articles![index]
                                                            .author
                                                            .toString()
                                                            .length <
                                                        15
                                                    ? snapshot.data!
                                                        .articles![index].author
                                                        .toString()
                                                    : snapshot.data!
                                                        .articles![index].author
                                                        .toString()
                                                        .substring(0, 15),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: kdark,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
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
            ),
          ],
        ),
      ),
    );
  }
}

const spinkit = SpinKitFadingCube(
  color: Colors.white,
  size: 50,
);
