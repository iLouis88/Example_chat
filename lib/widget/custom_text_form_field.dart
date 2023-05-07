import 'package:flutter/material.dart';
import 'package:savia/constant/color_constant.dart';
import 'package:savia/constant/text_style_constant.dart';
import 'package:savia/widget/custom_border.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final Color backGroundColor = const Color(0xffeaeaea);
  final String? Function(String?)? validator;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final int? maxLines;
  final TextInputType keyboardType;
  final AutovalidateMode? autovalidateMode;
  final void Function(String)? onChanged;
  final String hintText;

  const CustomTextFormField(
      {super.key,
      required this.controller,
      this.validator,
      this.prefixIcon,
      this.suffixIcon,
      this.maxLines,
      required this.keyboardType,
      this.autovalidateMode,
      required this.hintText,
      this.onChanged,
      this.focusNode,
      this.autoFocus});

  factory CustomTextFormField.email({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    required AutovalidateMode autovalidateMode,
    String? Function(String?)? validator,
  }) {
    return CustomTextFormField(
        maxLines: 1,
        controller: controller,
        hintText: hintText,
        keyboardType: keyboardType,
        autovalidateMode: autovalidateMode,
        validator: validator,
        suffixIcon: null,
        prefixIcon: const Icon(Icons.email));
  }

  factory CustomTextFormField.password({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required TextInputType keyboardType,
    required AutovalidateMode autovalidateMode,
    String? Function(String?)? validator,
  }) {
    return CustomTextFormField(
        maxLines: 1,
        controller: controller,
        hintText: hintText,
        keyboardType: keyboardType,
        autovalidateMode: autovalidateMode,
        validator: validator,
        prefixIcon: const Icon(Icons.password));
  }

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscuteText = false;
  Icon? prefixIcon;

  @override
  initState() {
    super.initState();
    prefixIcon = widget.prefixIcon;
  }

  _onPressed() {
    setState(() {
      _obscuteText = !_obscuteText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomBorder(
      width: 350,
      height: null,
      child: TextFormField(
        controller: widget.controller,
        maxLines: widget.maxLines,
        focusNode: widget.focusNode,
        obscureText: _obscuteText,
        validator: widget.validator,
        style: TextStyleConstant.textOfTextFormField,
        autovalidateMode: widget.autovalidateMode,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            suffixIcon: (prefixIcon == const Icon(Icons.password))
                ? (_obscuteText
                    ? IconButton(
                        onPressed: () {
                          _onPressed();
                        },
                        icon: const Icon(Icons.visibility))
                    : IconButton(
                        onPressed: () {
                          _onPressed();
                        },
                        icon: const Icon(Icons.visibility_off)))
                : widget.suffixIcon,
            fillColor: ColorConstant.fillColorOfTextFormField,
            filled: true,
            hintText: widget.hintText,
            hintStyle: TextStyleConstant.hintTextOfTextFormField,
            border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(15)))),
      ),
    );
  }
}
