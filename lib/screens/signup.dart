// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/repository/auth_services.dart';
import 'package:news_app/repository/storage_methods.dart';
import 'package:news_app/screens/login_screen.dart';
import 'package:news_app/utils/constants.dart';
import 'package:news_app/utils/flutter_news.dart';
import 'package:news_app/utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  var _email = "";
  var _password = "";
  var _username = "";
  var authService = AuthService();
  var isLoader = false;
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _email = '';
    _password = '';
    _username = '';
  }

  selectImage() async {
    Uint8List? im = await pickImage(ImageSource.gallery);
    if (im != null) {
      setState(() {
        _image = im;
      });
    }
  }

  startauthentication() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      submitForm(_email, _password, _username);
    }
  }

  submitForm(String email, String password, String username) async {
    UserCredential? authResult;

    var data = {
      'email': _email,
      'password': _password,
    };

    try {
      authResult = await authService.createUser(context, data);
      String uid = authResult!.user!.uid;

      String photoUrl = await StorageMethods()
          .uploadImageToStorage('profilePics', _image, false);

      print(photoUrl);

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'password': password,
        'image': photoUrl
      });
      showSnackBar(context, "User Registered Successfully");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Header(),
              SizedBox(height: 20),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                          backgroundColor: Colors.red,
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://i.stack.imgur.com/l60Hf.png'),
                          backgroundColor: Colors.red,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),

              TextFormField(
                style: TextStyle(color: kwhite),
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: ValueKey('email'),
                onSaved: (value) {
                  _email = value!;
                },
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: mainColor),
                  prefixIcon: Icon(Icons.email),
                  hintText: "Email Address",
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kwhite, width: 2)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: mainColor, width: 3)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kwhite)),
                ),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Please Enter a Valid Email';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              // Username text field
              TextFormField(
                key: const ValueKey('username'),
                style: TextStyle(color: kwhite),
                onSaved: (value) {
                  _username = value!;
                },
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: mainColor),
                  prefixIcon: Icon(Icons.person),
                  hintText: "Username",
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kwhite, width: 2)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: mainColor, width: 3)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kwhite)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter a Valid Username';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),
              // Password text field
              TextFormField(
                style: TextStyle(color: kwhite),
                keyboardType: TextInputType.visiblePassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: true,
                onSaved: (value) {
                  _password = value!;
                },
                key: ValueKey('password'),
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: mainColor),
                  prefixIcon: Icon(Icons.password),
                  hintText: "Password",
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: mainColor, width: 3)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kwhite, width: 2)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kwhite)),
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Please Enter a Valid Password';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              // Signup button
              ElevatedButton(
                onPressed: () {
                  startauthentication();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 30),
                  primary: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Sign up',
                  style: TextStyle(fontSize: 18, color: kwhite),
                ),
              ),
              SizedBox(height: 16),
              // Login link
              TextButton(
                onPressed: () {
                  // Navigate back to the LoginScreen
                  Navigator.pop(context);
                },
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
