import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe

class DialogConstant {
  static void showDiaLog({
    required BuildContext context,
    required String title,
    required DialogType dialogType,
    required String message,
    required void Function() onPressedOK,
    required IconData iconData,
    required Color colorOkButton,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.topSlide,
      headerAnimationLoop: true,
      title: title,
      desc: message,
      btnOkOnPress: () {
        onPressedOK();
      },
      btnOkIcon: iconData,
      btnOkColor: colorOkButton,
    ).show();
  }

  static void showException(
      {required BuildContext context,
      required String title,
      required String message,
      required void Function() onPressedOK}) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.topSlide,
      headerAnimationLoop: true,
      title: title,
      desc: message.replaceAll('Exception', 'Lỗi'),
      btnOkOnPress: () {
        onPressedOK();
      },
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,
    ).show();
  }

  static void showBothOkAndCancel(
      {required String okText,
      required String cancelText,
      required String body,
      required IconData okIcon,
      required IconData cancelIcon,
      required BuildContext context,
      void Function()? okOnPress,
      void Function()? cancelOnPress}) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.question,
            animType: AnimType.topSlide,
            headerAnimationLoop: true,
            body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(body)),
            btnOkIcon: okIcon,
            btnOkColor: Colors.blue,
            btnOkText: okText,
            btnCancelText: cancelText,
            btnCancelColor: const Color.fromARGB(255, 23, 190, 149),
            btnCancelIcon: cancelIcon,
            btnOkOnPress: okOnPress,
            btnCancelOnPress: cancelOnPress)
        .show();
  }
}
