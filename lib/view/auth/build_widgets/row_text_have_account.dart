import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:savia/constant/text_style_constant.dart';

class RowTextHaveAccount extends StatelessWidget {
  final String firstText;
  final String secondText;
  final TapGestureRecognizer recognizer;
  const RowTextHaveAccount({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.recognizer,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
        textScaleFactor: 1.2,
        text: TextSpan(children: [
          TextSpan(text: firstText, style: TextStyleConstant.dontHavaAccount),
          TextSpan(
              text: secondText,
              style: TextStyleConstant.signUpInSignInPage,
              recognizer: recognizer),
        ]));
  }
}
