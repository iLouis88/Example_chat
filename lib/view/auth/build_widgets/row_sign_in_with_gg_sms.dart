import 'package:savia/blocs/sign_in/sign_in_bloc.dart';
import 'package:savia/constant/image_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savia/view/auth/phone/phone_number_sign_in.dart';

class RowSignInWithGoogleAndSms extends StatelessWidget {
  const RowSignInWithGoogleAndSms({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      IconButton(
          iconSize: 60,
          onPressed: () {
            _authenticateWithGoogle(context);
          },
          icon: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 15,
                    offset: const Offset(1, 5),
                  ),
                ],
              ),
              child: _setLogo(Image(image: AssetImage(ImageConstant.ggLogo))))),
      const SizedBox(width: 20),
      IconButton(
          iconSize: 60,
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SendOtpPage())),
          icon: _setLogo(Image(image: AssetImage(ImageConstant.smsLogo))))
    ]);
  }

  void _authenticateWithGoogle(BuildContext context) {
    BlocProvider.of<SignInBloc>(context).add(
      SignInWithGoogleEvent(),
    );
  }

  Widget _setLogo(Image image) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 15,
              // ignore: prefer_const_constructors
              offset: Offset(1, 5),
            ),
          ],
        ),
        child: image);
  }
}
