import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:savia/blocs/sign_in/sign_in_bloc.dart';
import 'package:savia/constant/dialog_constant.dart';
import 'package:savia/constant/size_constant.dart';
import 'package:savia/constant/switch_screen_constant.dart';
import 'package:savia/constant/text_constant.dart';
import 'package:savia/constant/text_style_constant.dart';
import 'package:savia/lay_out/responsive_layout.dart';
import 'package:savia/repositories/dashboard_repo.dart';
import 'package:savia/repositories/sign_in_repository.dart';
import 'package:savia/view/auth/sign_in/build_widgets/button.dart';

import 'package:savia/view/auth/sign_in/build_widgets/text_form_fields.dart';
import 'package:savia/view/auth/build_widgets/background_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savia/constant/image_constant.dart';
import 'package:savia/view/dashboard.dart';
import 'package:savia/view/auth/build_widgets/slogan.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  //
  final String _bigText = TextConstant.bigSloganSignIn;
  final String _smallText = TextConstant.smallSloganSignIn;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocProvider(
        create: (context) => SignInBloc(
            signInRepository: SignInRepository(),
            dashboardRepository: DashboardRepository()),
        child: BlocListener<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is SignedIn) {
              SwitchScreenConstant.nextScreenReplace(
                  context, const DashBoard());
            }
            if (state is SignInError) {
              DialogConstant.showException(
                  context: context,
                  onPressedOK: () {},
                  title: 'Login failed',
                  message: state.error);
            }
          },
          child: BlocBuilder<SignInBloc, SignInState>(
            builder: (context, state) {
              if (state is SignInLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is UnSignedIn) {
                return SingleChildScrollView(
                  child: Stack(children: [
                    // background
                    BackgroundLogin(
                        size: size, imagePath: ImageConstant.backGroundOfLogin),
                    Column(
                      children: [
                        // height top with slogan
                        context.smallDevice()
                            ? context.sizedBox(
                                height: SizeConstant.topWithSloganSmallDevice)
                            : context.sizedBox(
                                height: SizeConstant.topWithSlogan),

                        // slogan
                        Slogan(smallText: _smallText, bigText: _bigText),
                        context.sizedBox(
                            height: SizeConstant.sloganWithTextFormField),
                        Form(
                          key: _formKey,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConstant
                                      .horizontalOfTextFormFieldSignIn),
                              child:
                                  // constain email and password input, forgot password
                                  ColumnTextFormField(
                                emailController: _emailController,
                                passwordController: _passwordController,
                              )),
                        ),
                        // forgot password
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [_forgotPassword(context: context)]),
                        ),
                        // constain signIn button, signIn with google and sms
                        BuildButton(
                            emailController: _emailController,
                            passwordController: _passwordController,
                            formKey: _formKey)
                      ],
                    ),
                  ]),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _forgotPassword({
    required BuildContext context,
  }) {
    return TextButton(
        child: Text('Forgot password', style: TextStyleConstant.forgotPassword),
        onPressed: () {
          _emailController.text.isNotEmpty ? _ressetPassword(context) : null;
          DialogConstant.showDiaLog(
              onPressedOK: () {},
              colorOkButton:
                  _emailController.text.isNotEmpty ? Colors.blue : Colors.red,
              context: context,
              dialogType: _emailController.text.isNotEmpty
                  ? DialogType.success
                  : DialogType.error,
              iconData:
                  _emailController.text.isNotEmpty ? Icons.check : Icons.cancel,
              message: _emailController.text.isNotEmpty
                  ? 'We just sent an email to ${_emailController.text}. Please click on the link in the email and change your password.'
                  : 'Enter your email in the Email box first.',
              title: 'Reset Password');
        });
  }

  void _ressetPassword(context) {
    BlocProvider.of<SignInBloc>(context).add(
      SignInResetPasswordEvent(email: _emailController.text),
    );
  }
}
