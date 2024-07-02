import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanderlog/controller/controller.dart';
import 'package:wanderlog/controller/fire_controller.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/util/snack_bar.dart';
import 'package:wanderlog/util/style.dart';
import 'package:wanderlog/view/navigation_bar.dart';
import 'package:wanderlog/view/statrt_screen.dart';
import 'package:wanderlog/view/widgets/app_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      if (FirebaseAuth.instance.currentUser == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const GetStartScreen(),
            ),
            (route) => false);
      } else {
        Provider.of<FireController>(context, listen: false)
            .fechSelectedUserData(
          FirebaseAuth.instance.currentUser!.uid,
        )
            .then((value) {
          if (value == true) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => Navigation(),
                ),
                (route) => false);
          } else {
            FirebaseAuth.instance.signOut();
             Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const GetStartScreen(),
            ),
            (route) => false);

            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Login is expired")));
            // showDeleteCredentialmessage(context);
          }
        });
      }
    });

    final width = MediaQuery.of(context).size.width;
    

    return Scaffold(
        backgroundColor: APP_THEME_COLOR,
        body: SizedBox(width: width, child: appLogo()));
  }
}
