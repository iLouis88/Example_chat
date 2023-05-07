import 'package:flutter/material.dart';
import 'package:savia/constant/color_constant.dart';
import 'package:savia/constant/text_style_constant.dart';
import 'package:savia/widget/custom_border.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final double? width;
  final double? height;
  final VoidCallback? onPress;
  final Color? backgroundColor;
  final TextStyle textStyleText;
  const CustomButton(
      {super.key,
      required this.label,
      required this.onPress,
      required this.backgroundColor,
      required this.textStyleText,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    return CustomBorder(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shadowColor: Colors.grey,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(label, style: textStyleText),
        ),
      ),
    );
  }

  factory CustomButton.auth(
      {required VoidCallback? onPress,
      required double? width,
      required String label,
      required double? height}) {
    return CustomButton(
      label: label,
      onPress: onPress,
      width: width,
      height: height,
      backgroundColor: ColorConstant.backgroundButtonSignIn,
      textStyleText: TextStyleConstant.title,
    );
  }
}
