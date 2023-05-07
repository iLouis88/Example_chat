import 'package:flutter/material.dart';
import 'package:savia/constant/text_style_constant.dart';

class Slogan extends StatelessWidget {
  final String bigText;
  final String smallText;

  const Slogan({super.key, required this.bigText, required this.smallText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(bigText, style: TextStyleConstant.bigSlogan),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(smallText,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyleConstant.smallSlogan),
          )
        ],
      ),
    );
  }
}
