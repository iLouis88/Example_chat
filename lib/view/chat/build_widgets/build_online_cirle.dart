import 'package:flutter/material.dart';

class BuildOnlineCircle extends StatelessWidget {
  const BuildOnlineCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(255, 75, 165, 238),
        boxShadow: [
          BoxShadow(
            color: Colors.lightBlueAccent,
            blurRadius: 5.0,
            spreadRadius: 2.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
    );
  }
}
