import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savia/blocs/sign_in/sign_in_bloc.dart';
import 'package:savia/constant/size_constant.dart';
import 'package:savia/constant/switch_screen_constant.dart';
import 'package:savia/lay_out/responsive_layout.dart';
import 'package:savia/view/auth/build_widgets/row_or_sign_in_with.dart';
import 'package:savia/view/auth/build_widgets/row_sign_in_with_gg_sms.dart';
import 'package:savia/view/auth/build_widgets/row_text_have_account.dart';
import 'package:savia/widget/custom_button.dart';

import '../../signUp/sign_up.dart';

class BuildButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  const BuildButton(
      {super.key,
      required this.emailController,
      required this.passwordController,
      required this.formKey});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // signIn button
        CustomButton.auth(
            onPress: () {
              _signInWithEmailAndPassword(context);
            },
            width: context.sizeWidth(SizeConstant.widthButton),
            height: context.sizeHeight(SizeConstant.heightButton),
            label: 'Sign In'),

        // hieght button- rowSignIn
        context.sizedBox(height: SizeConstant.buttonWithRowSignIn),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: RowSignInWith()),
        const SizedBox(height: 10),
        //
        const RowSignInWithGoogleAndSms(),
        context.smallDevice()
            ? context.sizedBox(
                height: SizeConstant.rowSignInWithRowHaveAccountSmallDevice)
            : context.sizedBox(
                height: SizeConstant.rowSignInWithRowHaveAccount),
        // have a account?
        RowTextHaveAccount(
            firstText: "Don't have an account? ",
            secondText: 'Sign Up',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                SwitchScreenConstant.nextScreenReplace(context, const SignUp());
              })
      ],
    );
  }

  void _signInWithEmailAndPassword(BuildContext context) {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<SignInBloc>(context).add(
        SignInWithEmailAndPasswordEvent(
            email: emailController.text.trim(),
            password: passwordController.text.trim()),
      );
    }
  }
}
