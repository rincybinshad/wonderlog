import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

poppinStyle(
    {Color? color,
    double? fontsize,
    FontWeight? fontWeight,
    double? letterSpacing}) {
  return GoogleFonts.poppins(
      letterSpacing: letterSpacing ?? 0,
      color: color ?? Colors.black,
      fontSize: fontsize ?? 16,
      fontWeight: fontWeight ?? FontWeight.normal);
}
normalStyle({Color? color,
    double? fontsize,
    FontWeight? fontWeight,
    double? letterSpacing}){

  return TextStyle(
      letterSpacing: letterSpacing ?? 0,
      color: color ?? Colors.black,
      fontSize: fontsize ?? 16,
      fontWeight: fontWeight ?? FontWeight.normal);

}

nunitoStyle(
    {Color? color,
    double? fontsize,
    FontWeight? fontWeight,
    double? letterSpacing}) {
  return GoogleFonts.nunito(
   
      letterSpacing: letterSpacing ?? 0,
      color: color ?? Colors.black,
      fontSize: fontsize ?? 16,
      fontWeight: fontWeight ?? FontWeight.normal);
}