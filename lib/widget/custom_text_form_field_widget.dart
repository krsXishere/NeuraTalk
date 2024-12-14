import 'package:flutter/material.dart';
import '../common/constant.dart';

class CustomTextFormFieldWidget extends StatelessWidget {
  final String hintText;
  final bool expands, showLabel, isNumber, isObsecure;
  final TextEditingController controller;
  final Function() onTap;
  final Function(String onChanged)? onChanged;
  final TextInputType type;
  final Widget suffixIcon;

  const CustomTextFormFieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    required this.type,
    this.isObsecure = false,
    required this.onTap,
    this.onChanged,
    this.isNumber = false,
    this.showLabel = true,
    this.expands = false,
    this.suffixIcon = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: expands ? 5 : 1,
      maxLength: expands ? 500 : null,
      style: primaryTextStyle.copyWith(
        fontSize: 14,
      ),
      cursorColor: primaryColor,
      controller: controller,
      keyboardType: type,
      onChanged: onChanged,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        filled: true,
        fillColor: darkColor,
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: primaryTextStyle.copyWith(
          fontWeight: regular,
          color: grey400,
          fontSize: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
