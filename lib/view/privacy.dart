import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanderlog/controller/controller.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/util/snack_bar.dart';
import 'package:wanderlog/util/style.dart';

class Privacy extends StatelessWidget {
  Privacy({super.key});
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * .1,
        leadingWidth: 70,
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                if (emailController.text.isNotEmpty) {
                  if (FirebaseAuth.instance.currentUser != null) {
                    if (emailController.text.trim() ==
                        FirebaseAuth.instance.currentUser!.email) {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: emailController.text)
                          .then((value) {
                        successSnackBar(context,
                            "Password reset mail send to : ${emailController.text}");
                        emailController.clear();
                        Navigator.of(context).pop();
                      });
                    } else {
                      errorSnackBar(
                          context, "The email is not registerd email address");
                    }
                  } else {
                    try {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: emailController.text)
                          .then((value) {
                        successSnackBar(context,
                            "Password reset mail send to : ${emailController.text}");
                        emailController.clear();
                        Navigator.of(context).pop();
                      });
                    } catch (e) {
                      errorSnackBar(context, e.toString());
                    }
                  }
                  // Navigator.of(context).pop();
                } else {
                  errorSnackBar(context, "Oops,enter the email and proceed");
                }
              },
              child: Text(
                "Reset",
                style: poppinStyle(color: BLACK, fontsize: 19),
              ))
        ],
        title: Text(
          "Privacy",
          style: normalStyle(fontsize: 27, fontWeight: FontWeight.w500),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: GREY.withOpacity(.6),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: const Offset(0, 2))
                  ],
                  color: WHITE,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: BLACK,
                )),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * .1,
            ),
            Text(
              "Reset Password",
              style: poppinStyle(),
            ),
            SizedBox(
              height: height * .02,
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: normalStyle(letterSpacing: 1),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(20)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(20))),
            ),
          ],
        ),
      ),
    );
  }
}
