import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:savia/blocs/phone_sign_in/phone_sign_in_bloc.dart';
import 'package:savia/constant/dialog_constant.dart';
import 'package:savia/constant/image_constant.dart';
import 'package:savia/constant/size_constant.dart';
import 'package:savia/constant/text_style_constant.dart';
import 'package:savia/lay_out/responsive_layout.dart';
import 'package:savia/repositories/phone_sign_in_repository.dart';
import 'package:savia/view/auth/sign_in/sign_in.dart';
import 'package:savia/view/auth/build_widgets/background_login.dart';
import 'package:savia/view/auth/phone/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savia/widget/custom_button.dart';
import 'package:savia/widget/custom_text_form_field.dart';

import '../../../constant/switch_screen_constant.dart';
import '../../../repositories/dashboard_repo.dart';

class SendOtpPage extends StatelessWidget {
  SendOtpPage({super.key});

  final _phoneNumberController = TextEditingController();
  final _messageOfError = 'Invalid phone number';
  final _privacyText =
      'Once submitted, we will verify the phone number quickly and securely. Please wait a moment!';
  final _title = 'Get OTP ';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocProvider(
        create: (context) => PhoneSignInBloc(
            phoneSignInRepository: PhoneSignInRepository(),
            dashboardRepository: DashboardRepository()),
        child: BlocListener<PhoneSignInBloc, PhoneSignInState>(
            listener: (context, state) {
          if (state is UnSentOTP) {
            SwitchScreenConstant.nextScreenReplace(context, SignInPage());
          }
          if (state is PhoneSignInError) {
            DialogConstant.showException(
                onPressedOK: () {
                  SwitchScreenConstant.nextScreenReplace(context, SignInPage());
                },
                context: context,
                title: 'Login failed',
                message: state.error);
          }
        }, child: BlocBuilder<PhoneSignInBloc, PhoneSignInState>(
                builder: (context, state) {
          if (state is PhoneSignInLoading) {
            return const Center(child: CircularProgressIndicator());
          } //AI
          if (state is Init) {
            return SingleChildScrollView(
              child: Stack(children: [
                BackgroundLogin(
                    imagePath: ImageConstant.backGroundOfLogin, size: size),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.black, size: 50),
                    onPressed: () {
                      SwitchScreenConstant.nextScreenReplace(
                          context, SignInPage());
                    },
                  ),
                ),
                Column(
                  children: [
                    // height top -  title
                    context.sizedBox(height: SizeConstant.topWithSlogan * 2),
                    Center(
                        child: Text(_title,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyleConstant.bigSlogan)),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        _privacyText,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyleConstant.dontHavaAccount,
                      ),
                    ),
                    SizedBox(height: SizeConstant.textFormFieldWithButton),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(children: [
                        Expanded(
                          child: CustomTextFormField(
                              autoFocus: true,
                              controller: _phoneNumberController,
                              prefixIcon: const Icon(Icons.phone),
                              validator: (value) {
                                return value != null && !_checkString(value)
                                    ? _messageOfError
                                    : null;
                              },
                              keyboardType: TextInputType.number,
                              hintText: 'Phone number'),
                        ),
                      ]),
                    ),
                    context.sizedBox(
                        height: SizeConstant.textFormFieldWithButton),
                    // send button
                    Center(
                      child: CustomButton.auth(
                          label: 'Send',
                          width: context.sizeWidth(SizeConstant.widthButton),
                          height: context.sizeHeight(SizeConstant.heightButton),
                          onPress: () {
                            if (_checkString(_phoneNumberController.text)) {
                              _sentOTP(context: context);
                            } else {
                              DialogConstant.showDiaLog(
                                  onPressedOK: () {},
                                  title: 'Send failed',
                                  context: context,
                                  message: _messageOfError,
                                  colorOkButton: Colors.red,
                                  dialogType: DialogType.error,
                                  iconData: Icons.cancel);
                            }
                          }),
                    ),
                  ],
                ),
              ]),
            );
          }
          return Container();
        })),
      ),
    );
  }

  void _sentOTP({required BuildContext context}) {
    context.read<PhoneSignInBloc>().add(PhoneSignInSendOTPPhoneNumberEvent(
        phoneNumber: _phoneNumberController.text.substring(1),
        pushToOtp: (String verificationId) {
          SwitchScreenConstant.nextScreenReplace(
              context,
              OTPPage(
                phoneNumber: _phoneNumberController.text.trim(),
                verificationId: verificationId,
              ));
        }));
  }

  bool _checkString(String str) {
    RegExp regex = RegExp(r'^\d+$');
    return (regex.hasMatch(str) &&
        _phoneNumberController.text.trim().toString().length > 8 &&
        _phoneNumberController.text.trim().toString().length < 11);
  }
}
