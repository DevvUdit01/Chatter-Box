
import 'dart:async';
import 'package:chatter_box/features/HomePage.dart';
import 'package:chatter_box/features/user_handling/signin.dart';
import 'package:chatter_box/helper/FirebaseHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/models/UserModal.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});  

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Show splash screen for 5 seconds
    Timer(const Duration(seconds: 3), () {
      // Check user login status after the splash screen timer
      checkLoginStatus();
    });
  }

  Future<void> checkLoginStatus() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Logged in
      UserModel? thisUserModel = await FirebaseHelper.getUserModelById(currentUser.uid);
      if (thisUserModel != null) {
        // Navigate to home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyAppLoggedIn(userModel: thisUserModel, firebaseUser: currentUser)),
        );
      } else {
        // If user data not found, navigate to sign-in page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      }
    } else {
      // Not logged in, navigate to sign-in page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child:  Text('Splash Screen', style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    );
  }
}

// Already Logged In
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn({super.key, required this.userModel, required this.firebaseUser});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(userModel: userModel, firebaseUser: firebaseUser),
      debugShowCheckedModeBanner: false,
    );
  }
}
