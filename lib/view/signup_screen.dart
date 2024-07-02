import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanderlog/controller/auth_controller.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/util/const.dart';
import 'package:wanderlog/util/style.dart';
import 'package:wanderlog/view/sign_in_screen.dart';
import 'package:wanderlog/view/widgets/app_logo.dart';
import 'package:wanderlog/view/widgets/button.dart';
import 'package:wanderlog/view/widgets/text_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: APP_THEME_COLOR,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Form(
              key: _formKey,
              child: Consumer<AuthController>(
                  builder: (context, authController, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * .15,
                    ),
                    appSmallLogo(),
                    SizedBox(
                      height: height * .15,
                    ),
                    Text(
                      "Sign Up Now",
                      style: normalStyle(
                          fontWeight: FontWeight.w700, fontsize: 34),
                    ),
                    Text(
                      "Please fill the details and create account",
                      style: normalStyle(
                          fontWeight: FontWeight.w400, fontsize: 20),
                    ),
                    SizedBox(
                      height: height * .08,
                    ),
                    customeTextField(
                      textCapitalization: TextCapitalization.words,
                        controller: authController.nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter the required field";
                          } else {
                            return null;
                          }
                        },
                        height: height,
                        width: width,
                        hintText: "Name"),
                    SizedBox(
                      height: height * .02,
                    ),
                    customeTextField(
                        controller: authController.emailcontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter the required field";
                          } else if (!(regEx.hasMatch(value))) {
                            return "The Email is not valid";
                          } else {
                            return null;
                          }
                        },
                        height: height,
                        width: width,
                        hintText: "Email"),
                    SizedBox(
                      height: height * .02,
                    ),
                    Consumer<AuthController>(builder: (context, controller, _) {
                      return customeTextField(
                        controller: authController.passwordcontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter the required field";
                          } else if (value.length < 8) {
                            return "Password required minimum 8 digit";
                          } else {
                            return null;
                          }
                        },
                        obscureText: controller.obscureText,
                        height: height,
                        width: width,
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.isTextVisible();
                          },
                          icon: Icon(controller.obscureText
                              ? Icons.remove_red_eye_sharp
                              : CupertinoIcons.eye_slash_fill),
                          color: GREY,
                        ),
                      );
                    }),
                    SizedBox(
                      height: height * .02,
                    ),
                    Consumer<AuthController>(builder: (context, controller, _) {
                      return customeTextField(
                        controller: authController.confirmPasswordcontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter the required field";
                          } else if (value.length < 8) {
                            return "Password required minimum 8 digit";
                          } else if (value !=
                              controller.passwordcontroller.text) {
                            return "Password does not match";
                          } else {
                            return null;
                          }
                        },
                        obscureText: controller.obscureText,
                        height: height,
                        width: width,
                        hintText: "Confirm Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.isTextVisible();
                          },
                          icon: Icon(controller.obscureText
                              ? Icons.remove_red_eye_sharp
                              : CupertinoIcons.eye_slash_fill),
                          color: GREY,
                        ),
                      );
                    }),
                    SizedBox(
                      height: height * .05,
                    ),
                    customeElevtedButton(
                        width: width,
                        height: height,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authController.signUp(
                                authController.emailcontroller.text.trim(),
                                authController.passwordcontroller.text.trim(),
                                authController.nameController.text.trim(),
                                context);
                          }
                        },
                        text: "Sign Up",
                        textColor: WHITE,
                        bgColor: DARK_BLUE_COLOR),
                    SizedBox(
                      height: height * .05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account",
                          style: normalStyle(color: WHITE, fontsize: 18),
                        ),
                        customeTextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ));
                            },
                            text: "Sign In",
                            textColor: DARK_BLUE_COLOR),
                      ],
                    ),
                    SizedBox(
                      height: height * .05,
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
