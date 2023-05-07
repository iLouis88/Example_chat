import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savia/blocs/sign_up/sign_up_bloc.dart';
import 'package:savia/constant/size_constant.dart';
import 'package:savia/lay_out/responsive_layout.dart';
import 'package:savia/view/auth/sign_in/sign_in.dart';
import 'package:savia/view/auth/build_widgets/row_or_sign_in_with.dart';
import 'package:savia/view/auth/build_widgets/row_sign_in_with_gg_sms.dart';
import 'package:savia/view/auth/build_widgets/row_text_have_account.dart';
import 'package:savia/widget/custom_button.dart';

import '../../../../constant/switch_screen_constant.dart';

class BuildButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const BuildButton(
      {super.key,
      required this.formKey,
      required this.emailController,
      required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton.auth(
            onPress: () {
              if (formKey.currentState?.validate() ?? false) {
                _createAccountWithEmailAndPassword(context);
              }
            },
            width: context.sizeWidth(SizeConstant.widthButton),
            height: context.sizeHeight(SizeConstant.heightButton),
            label: 'Sign Up'),
        context.smallDevice()
            ? context.sizedBox(
                height: SizeConstant.buttonWithRowSignInSmallDevice)
            : context.sizedBox(height: SizeConstant.buttonWithRowSignIn),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: RowSignInWith()),
        const SizedBox(height: 10),
        // sign in with goole and sms
        const RowSignInWithGoogleAndSms(),
        context.smallDevice()
            ? context.sizedBox(
                height: SizeConstant.rowSignInWithRowHaveAccountSmallDevice)
            : context.sizedBox(
                height: SizeConstant.rowSignInWithRowHaveAccount),
        RowTextHaveAccount(
            firstText: 'Already have an account? ',
            secondText: 'Sign In',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                SwitchScreenConstant.nextScreenReplace(context, SignInPage());
              }),
      ],
    );
  }

  void _createAccountWithEmailAndPassword(BuildContext context) {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<SignUpBloc>(context).add(
        SignUpWithEmailAndPasswordEvent(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );
    }
  }


}
