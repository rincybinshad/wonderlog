import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wanderlog/util/colors.dart';

Widget constRatingBar(double rating, {double? itemSize}) {
  return RatingBar.builder(
      initialRating: rating,
      ignoreGestures: true,
      allowHalfRating: true,
      // glow: false,
      unratedColor: BLACK,
      glowColor: YELLOW,
      itemSize: itemSize ?? 20,
      itemBuilder: (context, index) {
        return const Icon(
          Icons.star,
          color: YELLOW,
        );
      },
      onRatingUpdate: (index) {
        print(index);
      });
}
