import 'package:savia/blocs/sign_up/sign_up_bloc.dart';
import 'package:savia/constant/dialog_constant.dart';
import 'package:savia/constant/size_constant.dart';
import 'package:savia/constant/switch_screen_constant.dart';
import 'package:savia/constant/text_constant.dart';
import 'package:savia/lay_out/responsive_layout.dart';
import 'package:savia/repositories/sign_up_repository.dart';
import 'package:savia/view/auth/signUp/build_widgets/button.dart';
import 'package:savia/view/auth/signUp/build_widgets/text_form_field.dart';
import 'package:savia/view/auth/build_widgets/background_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savia/view/auth/sign_in/sign_in.dart';
import 'package:savia/view/auth/build_widgets/slogan.dart';

import '../../../constant/image_constant.dart';
import '../../../repositories/dashboard_repo.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordValController = TextEditingController();
  //
  final String _bigText = TextConstant.bigSloganSignUp;
  final String _smallText = TextConstant.smallSloganSignUp;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocProvider(
        create: (context) => SignUpBloc(
            signUpRepository: SignUpRepository(),
            dashboardRepository: DashboardRepository()),
        child: BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignedUp) {
              SwitchScreenConstant.nextScreenReplace(context, SignInPage());
            }
            if (state is SignUpError) {
              DialogConstant.showException(
                  context: context,
                  onPressedOK: () {},
                  title: 'Registration failed',
                  message: state.error);
            }
          },
          builder: (context, state) {
            if (state is SignUpLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UnSignedUp) {
              return SingleChildScrollView(
                child: Stack(children: [
                  BackgroundLogin(
                      size: size, imagePath: ImageConstant.backGroundOfLogin),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // height top - slogan
                      context.smallDevice()
                          ? context.sizedBox(
                              height: SizeConstant.topWithSloganSmallDevice)
                          : context.sizedBox(
                              height: SizeConstant.topWithSlogan),
                      Slogan(bigText: _bigText, smallText: _smallText),
                      // height sloan - textformfield
                      context.sizedBox(
                          height: SizeConstant.sloganWithTextFormField),

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConstant
                                        .horizontalOfTextFormFieldSignIn),
                                child:
                                    // constain email, password, passwordVal input
                                    BuildTextFormField(
                                  emailController: _emailController,
                                  passwordValController: _passwordValController,
                                  passwordController: _passwordController,
                                )),
                          ],
                        ),
                      ),
                      context.sizedBox(
                          height: SizeConstant.textFormFieldWithButton),
                      // column button
                      BuildButton(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        formKey: _formKey,
                      )
                    ],
                  ),
                ]),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
