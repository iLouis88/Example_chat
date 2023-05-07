import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:page_transition/page_transition.dart';
import 'package:savia/view/dashboard.dart';
import 'package:savia/view/auth/sign_in/sign_in.dart';

class SplashScreen extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final String _name = 'FChat';
  final TextStyle _logoTextStyle = const TextStyle(
      fontSize: 60,
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontFamily: 'ShantellSans-Regular');

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        duration: 300,
        splash: Text(_name, style: _logoTextStyle),
        animationDuration: const Duration(milliseconds: 300),
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: const Color(0xff0E77CB),
        nextScreen: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const DashBoard();
            }
            return SignInPage();
          },
        ));
  }
}
