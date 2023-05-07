import 'package:flutter/material.dart';

class CustomBorder extends StatelessWidget {
  final double? width, height;
  final Widget child;
  final Color? color;
  const CustomBorder(
      {super.key, this.width, this.height, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}
