import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wanderlog/controller/controller.dart';
import 'package:wanderlog/controller/fire_controller.dart';
import 'package:wanderlog/model/new_post.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/util/snack_bar.dart';
import 'package:wanderlog/util/style.dart';

class AddNewRequestPage extends StatelessWidget {
  AddNewRequestPage({super.key});
  TextEditingController placeNameController = TextEditingController();
  TextEditingController placeDecController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  clearRequest() {
    placeDecController.clear();
    placeNameController.clear();
    fileImage = null;
    postUrl = "";
  }

  File? fileImage;
  String? postUrl;
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
            Consumer<FireController>(builder: (context, firController, child) {
              return TextButton(
                  onPressed: () {
                    if (placeDecController.text.isNotEmpty ||
                        placeNameController.text.isNotEmpty) {
                      if (fileImage != null) {
                        showLoadingIndicator(context, "Please wait...");
                        firController.urlGenarator(fileImage).then((url) {
                          firController
                              .addNewPost(AddNewPost(
                                  amount: priceController.text,
                                  placeDescription: placeDecController.text,
                                  imageUrl: url!,
                                  placeName: placeNameController.text,
                                  rating: 1,
                                  uid: FirebaseAuth.instance.currentUser!.uid,
                                  status: "Requested"))
                              .then((value) {
                            clearRequest();
                            successSnackBar(
                                context, "Your request is submitted");
                            final nav = Navigator.of(context);
                            nav.pop();
                            nav.pop();
                          });
                        });
                      } else {
                        errorSnackBar(context, "Select the image and continue");
                      }
                    } else {
                      errorSnackBar(context, "Enter the required fields");
                    }
                  },
                  child: Text(
                    "Request",
                    style: poppinStyle(color: BLACK, fontsize: 19),
                  ));
            })
          ],
          leading: const SizedBox()),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<Controller>(builder: (context, controller, _) {
                return InkWell(
                  onTap: () {
                    controller.pickPostImage().then((file) {
                      fileImage = file;
                      controller.cancelIndicator();
                      print(fileImage);
                    });
                  },
                  child: Container(
                    height: height * .16,
                    width: width * .7,
                    decoration: BoxDecoration(
                        image: fileImage != null
                            ? DecorationImage(
                                fit: BoxFit.fill, image: FileImage(fileImage!))
                            : null,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add,
                          size: 33,
                        ),
                        Text(
                          "Add Image",
                          style: nunitoStyle(),
                        )
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(
                height: height * .1,
              ),
              Consumer<Controller>(builder: (context, controller, child) {
                return Column(
                  children: [
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: placeNameController,
                      decoration: InputDecoration(
                          hintText: "Place",
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
                    SizedBox(
                      height: height * .01,
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Price",
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
                    SizedBox(
                      height: height * .01,
                    ),
                    TextFormField(
                      maxLines: 10,
                      controller: placeDecController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          hintText: "Description",
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
                    )
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
