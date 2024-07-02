import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanderlog/controller/controller.dart';
import 'package:wanderlog/controller/fire_controller.dart';
import 'package:wanderlog/model/user_model.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/util/snack_bar.dart';
import 'package:wanderlog/util/style.dart';
import 'package:wanderlog/view/home.dart';
import 'package:wanderlog/view/navigation_bar.dart';
import 'package:wanderlog/view/splash_screen.dart';

class AuthController with ChangeNotifier {
  bool obscureText = true;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  TextEditingController confirmPasswordcontroller = TextEditingController();
  TextEditingController nameController = TextEditingController();

  clearController() {
    emailcontroller.clear();
    passwordcontroller.clear();
    confirmPasswordcontroller.clear();
    nameController.clear();
    print("--------Clear controller");
    // notifyListeners();
  }

  isTextVisible() {
    obscureText = !obscureText;
    notifyListeners();
  }

  final auth = FirebaseAuth.instance;

  Future signUp(
    String email,
    String password,
    String name,
    context,
  ) async {
    try {
      showLoadingIndicator(context, "Pleas wait a moment");

      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((credential) {
        Provider.of<FireController>(context, listen: false)
            .addUser(
                credential.user!.uid,
                UserModel(
                    bio: "",
                    email: email,
                    imageUrl: "",
                    name: name,
                    description: ""))
            .then((value) {
          clearController();
          successSnackBar(context, "Registration successful");
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Navigation()),
              (route) => false);
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorSnackBar(context, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        errorSnackBar(context, "The account already exists for that email.");
      } else {
        errorSnackBar(context, e.code);
      }
    }
  }

  Future signIn(String email, String password, context) async {
    try {
      final credential = await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((cred) {
        Provider.of<FireController>(context, listen: false)
            .fechSelectedUserData(
          cred.user!.uid,
        )
            .then((value) {
          if (value == true) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => Navigation(),
                ),
                (route) => false);
          } else {
            showDeleteCredentialmessage(context);
          }
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorSnackBar(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        errorSnackBar(context, 'Wrong password provided for that user.');
      } else {
        errorSnackBar(context, e.code);
      }
    }
  }

  // showCustomeDiologeu(context, error) {
  //   return showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       backgroundColor: WHITE,
  //       shape: const ContinuousRectangleBorder(),
  //       content: Text(
  //         error,
  //         style: nunitoStyle(
  //             letterSpacing: 1, fontsize: 17, fontWeight: FontWeight.w300),
  //       ),
  //     ),
  //   );
  // }
}
