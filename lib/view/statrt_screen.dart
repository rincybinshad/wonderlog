import 'package:flutter/material.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/util/style.dart';
import 'package:wanderlog/view/sign_in_screen.dart';
import 'package:wanderlog/view/widgets/button.dart';

class GetStartScreen extends StatelessWidget {
  const GetStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/start.png",
              width: width,
            ),
            Text(
              "EXPLORE YOUR THOUGHTS",
              style: poppinStyle(
                  color: DARK_BLUE_COLOR,
                  fontWeight: FontWeight.w500,
                  fontsize: width * .07),
            ),
            SizedBox(
              height: height * .1,
            ),
            SizedBox(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                      left: 3,
                      child: Image.asset(
                        "assets/logolayer1.png",
                      )),
                  Positioned(
                      child: Image.asset(
                    "assets/logolayer2.png",
                  )),
                ],
              ),
            ),
            Text(
              "Wander  Log",
              style: poppinStyle(
                  color: DARK_BLUE_COLOR,
                  letterSpacing: 7,
                  fontsize: 22,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: height * .1,
            ),
            Container(
              width: 50,
              height: 7,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: LIGHT_BLUE_COLOR),
            ),
            SizedBox(
              height: height * .010,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: customeElevtedButton(
                  height: height,
                  width: width,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SignInScreen(),
                    ));
                  },
                  bgColor: LIGHT_BLUE_COLOR,
                  text: "Get Started",
                  textColor: WHITE),
            )
          ],
        ),
      ),
    );
  }
}
