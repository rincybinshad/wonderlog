import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/util/style.dart';
import 'package:wanderlog/view/splash_screen.dart';

errorSnackBar(context, message) {
  return showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.error(
      message: message,
    ),
  );
}

successSnackBar(context, message) {
  return showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.success(
      message: message,
    ),
  );
}

showLoadingIndicator(context, String data) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      elevation: 0,
      backgroundColor: TRANSPERENT,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            data,
            style: normalStyle(
                color: WHITE, fontWeight: FontWeight.w600, fontsize: 22),
          ),
          const SizedBox(
            width: 20,
          ),
          const CircularProgressIndicator(
            color: APP_THEME_COLOR,
          ),
        ],
      ),
    ),
  );
}

showDeleteCredentialmessage(context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: ContinuousRectangleBorder(),
      backgroundColor: WHITE,
      content: Text(
        "Your account is deleted by some reason.Please contact with admin for further information\nif delete your old credential by your self you can create a new account with the same email (${FirebaseAuth.instance.currentUser!.email}).",
        style: nunitoStyle(),
      ),
      actions: [
        TextButton(
            onPressed: ()  {
               FirebaseAuth.instance.currentUser!.delete().then((value) {
              return  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SplashScreen()),
                    (route) => false);
              });
            },
            child: Text(
              "Delete credential",
              style: nunitoStyle(color: Colors.red),
            ))
      ],
    ),
  );
}
