import 'package:savia/constant/text_style_constant.dart';
import 'package:flutter/material.dart';

class RowSignInWith extends StatelessWidget {
  const RowSignInWith({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Divider(color: Colors.black, thickness: 0.5),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('Or sign in with',
                style: TextStyleConstant.dontHavaAccount),
          ),
          const Expanded(child: Divider(color: Colors.black, thickness: 0.5)),
        ],
      ),
    );
  }
}
