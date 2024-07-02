import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/util/style.dart';

Widget customeTextField(
    {required width,
    required height,
     TextCapitalization textCapitalization=TextCapitalization.none,
    required String hintText,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    TextEditingController? controller}) {
  return TextFormField(
    textCapitalization: textCapitalization,
    validator: validator,
    controller: controller,
    obscureText: obscureText,
    decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: normalStyle(letterSpacing: 1),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(13))),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(13))),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(13))),
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(13))),
        fillColor: WHITE,
        filled: true),
  );
}
