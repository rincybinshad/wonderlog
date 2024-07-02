import 'package:flutter/material.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/util/style.dart';

Column appLogo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              left: 3,
              child: Image.asset(
                scale: 0.8,
                "assets/logolayer1.png",
              )),
          Positioned(
              child: Image.asset(
            scale: 0.8,
            "assets/logolayer2.png",
            color: WHITE,
          )),
        ],
      ),
      Text(
        "Wander  Log",
        style: poppinStyle(
            color: WHITE,
            letterSpacing: 9,
            fontsize: 24,
            fontWeight: FontWeight.w500),
      )
    ],
  );
}

Column appSmallLogo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              left: 3,
              child: Image.asset(
                scale: 2  ,
                "assets/logolayer1.png",
              )),
          Positioned(
              child: Image.asset(
            "assets/logolayer2.png",
            scale: 2  ,
            color: WHITE,
          )),
        ],
      ),
      Text(
        "Wander Log",
        style: poppinStyle(
            color: WHITE,
            letterSpacing: 6,
            fontsize: 5,
            fontWeight: FontWeight.w500),
      )
    ],
  );
}
