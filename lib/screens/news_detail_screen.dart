import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatefulWidget {
  String newsUrl;
  String newsImage;
  String? newsTitle;
  String? newsDate;
  String? newsAuthor;
  String? newsDesc;
  String? newsContent;

  NewsDetailScreen(this.newsUrl, this.newsImage, this.newsTitle, this.newsDate,
      this.newsAuthor, this.newsDesc, this.newsContent);

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final format = new DateFormat('MMMM dd,yyyy');
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    // Check if the current article is in favourites and update isFavourite accordingly
    checkFavouriteStatus();
  }

  void checkFavouriteStatus() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('favourites')
          .doc(uid)
          .collection('articles')
          .doc(
              widget.newsTitle) // Assuming newsTitle is unique for each article
          .get();

      setState(() {
        isFavourite = snapshot.exists;
      });
    }
  }

  void toggleFavourite() {
    setState(() {
      isFavourite = !isFavourite;
    });

    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      if (isFavourite) {
        storeFavouriteArticle(uid);
      } else {
        removeFavouriteArticle(uid);
      }
    }
  }

  void storeFavouriteArticle(String uid) {
    FirebaseFirestore.instance
        .collection('favourites')
        .doc(uid)
        .collection('articles')
        .doc(widget.newsTitle) // Assuming newsTitle is unique for each article
        .set({
      'url': widget.newsUrl,
      'newsImage': widget.newsImage,
      'newsDesc': widget.newsDesc,
      'newsContent': widget.newsContent,
      'title': widget.newsTitle,
      'date': widget.newsDate,
      'author': widget.newsAuthor, // Add other properties as needed
    });
  }

  void removeFavouriteArticle(String uid) {
    FirebaseFirestore.instance
        .collection('favourites')
        .doc(uid)
        .collection('articles')
        .doc(widget.newsTitle) // Assuming newsTitle is unique for each article
        .delete();
  }

  _launchURL() async {
    final Uri url = Uri.parse(widget.newsUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    double Kwidth = MediaQuery.of(context).size.width;
    double Kheight = MediaQuery.of(context).size.height;
    DateTime dateTime = widget.newsDate != null
        ? DateTime.parse(widget.newsDate!)
        : DateTime.now();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "News",
          style: TextStyle(color: kwhite),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: toggleFavourite,
              icon: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_outline,
              ))
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: kwhite,
            )),
      ),
      body: Stack(
        children: [
          SizedBox(
            // padding: EdgeInsets.symmetric(horizontal: Kheight * 0.02),
            height: Kheight * 0.45,
            width: Kwidth,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              child: CachedNetworkImage(
                imageUrl: widget.newsImage,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) {
                  return Image.asset(
                    'assets/error.png',
                    width: 80, // Adjust the width as needed
                  );
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: Kheight * 0.4),
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            height: Kheight * 0.6,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: ListView(
              children: [
                Text('${widget.newsTitle}',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: Kheight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      format.format(dateTime),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: Kheight * 0.03,
                ),
                Text('${widget.newsDesc}',
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500)),
                SizedBox(
                  height: Kheight * 0.03,
                ),
                Text('${widget.newsContent}',
                    maxLines: 20,
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "For more details click on : ",
                      style: TextStyle(color: kdark, fontSize: 18),
                    ),
                    GestureDetector(
                        onTap: _launchURL,
                        child: Text("here",
                            style: GoogleFonts.poppins().copyWith(
                                color: Colors.deepPurple, fontSize: 18))),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
