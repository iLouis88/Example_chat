import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:savia/blocs/phone_sign_in/phone_sign_in_bloc.dart';
import 'package:savia/constant/dialog_constant.dart';
import 'package:savia/constant/size_constant.dart';
import 'package:savia/constant/switch_screen_constant.dart';
import 'package:savia/constant/text_style_constant.dart';
import 'package:savia/lay_out/responsive_layout.dart';
import 'package:savia/repositories/dashboard_repo.dart';
import 'package:savia/repositories/phone_sign_in_repository.dart';

import 'package:savia/view/auth/build_widgets/background_login.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savia/view/auth/sign_in/sign_in.dart';
import 'package:savia/widget/custom_button.dart';

import '../../../constant/image_constant.dart';
import '../../dashboard.dart';

class OTPPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const OTPPage(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final _pinController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  String smsCode = '';
  String _notificationOtp = '';
  final String _title = 'OTP Verification';

  @override
  void initState() {
    super.initState();
    _notificationOtp =
        'Verification code has been sent to phone number: ${widget.phoneNumber}. This code will take effect within 90 seconds.';
  }

  // TODO: tach bloc => state
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
          if (state is VerifiedOTPSuccess) {
            SwitchScreenConstant.nextScreenReplace(context, const DashBoard());
          }
        }, child: BlocBuilder<PhoneSignInBloc, PhoneSignInState>(
                builder: (context, state) {
          if (state is PhoneSignInLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      context.sizedBox(height: SizeConstant.topWithSlogan * 2),
                      Center(
                          child:
                              Text(_title, style: TextStyleConstant.bigSlogan)),
                      const SizedBox(height: 5),
                      Center(
                          child: Text(_notificationOtp,
                              textAlign: TextAlign.center,
                              style: TextStyleConstant.dontHavaAccount)),
                      const SizedBox(height: 20),
                      Center(
                          child: Pinput(
                        onChanged: ((value) {
                          smsCode = value;
                        }),
                        errorPinTheme: defaultPinTheme.copyBorderWith(
                          border: Border.all(color: Colors.redAccent),
                        ),
                        submittedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            color: const Color.fromRGBO(243, 246, 249, 0),
                            borderRadius: BorderRadius.circular(19),
                            // ignore: prefer_const_constructors
                            border: Border.all(
                                color: const Color.fromRGBO(23, 171, 144, 1)),
                          ),
                        ),
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: const Color.fromRGBO(23, 171, 144, 1)),
                          ),
                        ),
                        cursor: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 9),
                              width: 22,
                              height: 1,
                              color: const Color.fromRGBO(23, 171, 144, 1),
                            ),
                          ],
                        ),
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsUserConsentApi,
                        listenForMultipleSmsOnAndroid: true,
                        defaultPinTheme: defaultPinTheme,
                        length: 6,
                        focusNode: _pinPutFocusNode,
                        controller: _pinController,
                        pinAnimationType: PinAnimationType.fade,
                      )),
                      context.sizedBox(
                          height: SizeConstant.textFormFieldWithButton),
                      Center(
                        child: CustomButton.auth(
                            label: 'Xác nhận',
                            width: context.sizeWidth(150),
                            height: context.sizeHeight(60),
                            onPress: () {
                              if (smsCode.length == 6) {
                                _verifyOtp(
                                    context: context,
                                    verificationId: widget.verificationId);
                              } else {}
                            }),
                      ),
                    ],
                  ),
                ),
              ]),
            );
          }
        })),
      ),
    );
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: const Color.fromRGBO(23, 171, 144, 0.4)),
    ),
  );

  void _verifyOtp(
      {required BuildContext context, required String verificationId}) {
    context.read<PhoneSignInBloc>().add(PhoneSignInVerifyOTPEvent(
        smsCode: smsCode,
        verificationId: widget.verificationId,
        onError: () {
          _showFaildDialog(context);
        }));
  }

  void _showFaildDialog(BuildContext context) {
    DialogConstant.showDiaLog(
        title: 'Verification failed',
        context: context,
        onPressedOK: () {},
        message: 'The verification code is incorrect',
        colorOkButton: Colors.red,
        dialogType: DialogType.error,
        iconData: Icons.cancel);
  }
}
