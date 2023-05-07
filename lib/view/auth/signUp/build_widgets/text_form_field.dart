import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:savia/constant/size_constant.dart';
import 'package:savia/constant/text_constant.dart';
import 'package:savia/lay_out/responsive_layout.dart';
import 'package:savia/widget/custom_text_form_field.dart';

class BuildTextFormField extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordValController;
  BuildTextFormField(
      {super.key,
      required this.emailController,
      required this.passwordController,
      required this.passwordValController});

  //
  final String _hintTextOfEmail = TextConstant.hintTextEmail;
  final String _hintTextOfPassword = TextConstant.hintTextPassword;
  final String _hintTextOfPasswordAgain = TextConstant.hintTextPasswordAgain;

  final String _emailError = TextConstant.emailError;
  final String _passwordError = TextConstant.passwordError;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // gmail input
        CustomTextFormField.email(
          controller: emailController,
          hintText: _hintTextOfEmail,
          keyboardType: TextInputType.emailAddress,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            return value != null && !EmailValidator.validate(value)
                ? _emailError
                : null;
          },
        ),
        context.sizedBox(height: SizeConstant.textFormFileWithTextFormFiled),
        // password input
        CustomTextFormField.password(
          obscureText: true,
          controller: passwordController,
          hintText: _hintTextOfPassword,
          keyboardType: TextInputType.text,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            return value != null && value.length < 6 ? _passwordError : null;
          },
        ),
        context.sizedBox(height: SizeConstant.textFormFileWithTextFormFiled),
        // password verify
        CustomTextFormField.password(
          obscureText: true,
          controller: passwordValController,
          hintText: _hintTextOfPasswordAgain,
          keyboardType: TextInputType.text,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value != null && value.length < 6) {
              return "Passwords must be at least 6 characters";
            } else if (value != passwordController.text) {
              return "Confirm password does not match";
            }
            return null;
          },
        ),
      ],
    );
  }
}
