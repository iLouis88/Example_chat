import 'package:flutter/material.dart';

class SwitchScreenConstant {
  static void nextScreen(context, screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  static void nextScreenReplace(context, screen) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screen));
  }

  
}
