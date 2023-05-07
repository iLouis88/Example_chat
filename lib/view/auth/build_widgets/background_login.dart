import 'package:flutter/material.dart';

class BackgroundLogin extends StatelessWidget {
  final Size size;
  final String imagePath;
  const BackgroundLogin(
      {super.key, required this.size, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              opacity: 0.5, image: AssetImage(imagePath), fit: BoxFit.cover)),
    );
  }
}
