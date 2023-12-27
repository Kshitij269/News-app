// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:news_app/repository/auth_services.dart';
import 'package:news_app/screens/signup.dart';
import 'package:news_app/utils/constants.dart';
import 'package:news_app/utils/flutter_news.dart';
import 'package:news_app/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

  startauthentication() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      _submitForm();
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var data = {
        "email": _emailController.text,
        "password": _passwordController.text,
      };
      try {
        await authService.loginUser(data);
      } catch (e) {
        showSnackBar(context, e.toString());
      }
    }
  }

  String? _validatePassword(value) {
    if (value!.isEmpty) {
      return 'Please Enter a Password';
    }
    if (value.length < 5) {
      return 'Please Enter a Strong Password';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App title
              Header(),
              SizedBox(height: 20),
              TextFormField(
                style: TextStyle(color: kwhite),
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                key: ValueKey('email'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
              SizedBox(height: 16),
              TextFormField(
                style: TextStyle(color: kwhite),
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordController,
                key: ValueKey('password'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: true,
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
                validator: _validatePassword,
              ),
              SizedBox(height: 20),
              // Login button
              ElevatedButton(
                onPressed: () {
                  startauthentication();
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: kwhite),
                ),
              ),
              SizedBox(height: 16),
              // Sign up link
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupScreen()));
                },
                child: Text(
                  'Don\'t have an account? Sign up',
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
