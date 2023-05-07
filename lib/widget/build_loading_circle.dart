import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:savia/constant/image_constant.dart';

class BuildLoadingCircle extends StatelessWidget {
  final double width;
  final double height;
  const BuildLoadingCircle(
      {super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(ImageConstant.imageLoading,
        width: width, height: height);
  }
}
