import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:wanderlog/util/colors.dart';

Widget customeElevtedButton(
    {required width,
    required height,
    Color? bgColor,
    Color? textColor,
    String? text,
    required void Function()? onPressed}) {
  return SizedBox(
      width: width,
      height: height * .06,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Text(
            text!,
            style: TextStyle(color: textColor, fontSize: 18),
          )));
}

Widget customeTextButton(
    {Color? bgColor,
    Color? textColor,
    String? text,
    required void Function()? onPressed}) {
  return TextButton(
      onPressed: onPressed,
      child: Text(
        text!,
        style: TextStyle(color: textColor, fontSize: 18),
      ));
}
 Widget navButton({ double? iconSize,required  icon,required double hight,required double width,required void Function()? onTap}) {
  return InkWell(
    onTap:onTap,
    child: Container(
      height: hight,
      width: width,
      decoration: const BoxDecoration(
          color: DARK_BLUE_COLOR,
          borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(40, 50),
              bottomRight: Radius.elliptical(69, 90),
              topRight: Radius.elliptical(60, 30),
              bottomLeft: Radius.elliptical(60, 50))),
      child:  Icon(
        icon,
        size: iconSize,
        color: WHITE,
      ),
    ),
  );
}