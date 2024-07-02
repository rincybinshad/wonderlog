import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wanderlog/controller/fire_controller.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/util/snack_bar.dart';
import 'package:wanderlog/util/style.dart';
import 'package:wanderlog/view/widgets/shimmer_effect.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});
  TextEditingController editiNameController = TextEditingController();
  TextEditingController editiBioController = TextEditingController();
  TextEditingController editiDesController = TextEditingController();
  clearProfileField() {
    editiNameController.clear();
    editiBioController.clear();
    editiDesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final provider = Provider.of<FireController>(context);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: TRANSPERENT,
        
        actions: [
          TextButton(
              onPressed: () {
                if (editiBioController.text.isNotEmpty ||
                    editiDesController.text.isNotEmpty ||
                    editiNameController.text.isNotEmpty) {
                  provider
                      .updateUserProfile(editiNameController.text,
                          editiBioController.text, editiDesController.text)
                      .then((value) {
                    clearProfileField();
                    successSnackBar(context, "Profile Updated");
                  });
                } else {
                  errorSnackBar(context, "Edit before submit");
                }
              },
              child: Text(
                "Done",
                style: poppinStyle(color: BLACK, fontsize: 19),
              ))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
          child:
              Consumer<FireController>(builder: (context, fireController, _) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                      future: fireController.fechSelectedUserData(
                          FirebaseAuth.instance.currentUser!.uid,),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return shimmerEffectForProfile(
                              height, width, false, context);
                        }
                        final data = fireController.selecteduserData;
                        return Row(
                          children: [
                            InkWell(
                              onTap: () {
                                fireController.pickImage();
                              },
                              child: Container(
                                  alignment: Alignment.bottomRight,
                                  height: height * .1,
                                  width: width * .25,
                                  decoration: BoxDecoration(
                                      image: data!.imageUrl.isEmpty
                                          ? const DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                  "assets/noprofile.png"))
                                          : DecorationImage(
                                              fit: BoxFit.fill,
                                              image:
                                                  NetworkImage(data.imageUrl)),
                                      // color: DARK_BLUE_COLOR,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.elliptical(40, 50),
                                          bottomRight:
                                              Radius.elliptical(69, 90),
                                          topRight: Radius.elliptical(60, 30),
                                          bottomLeft:
                                              Radius.elliptical(60, 50))),
                                  child: const Icon(
                                    Icons.add,
                                    color: BLACK,
                                  )),
                            ),
                            SizedBox(
                              width: width * .05,
                            ),
                            SizedBox(
                              width: width * .6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.name.isEmpty
                                        ? "N/A"
                                        : "${data.name.substring(0, 1).toUpperCase()}${data.name.substring(1).toLowerCase()}",
                                    style: poppinStyle(
                                        fontWeight: FontWeight.w600,
                                        fontsize: 25),
                                  ),
                                  Text(
                                    data.description,
                                    style: poppinStyle(
                                        fontWeight: FontWeight.w600,
                                        fontsize: 15),
                                  ),
                                  Text(
                                    data.bio,
                                    // overflow: TextOverflow.ellipsis,
                                    style: poppinStyle(
                                      fontWeight: FontWeight.w500,
                                      fontsize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * .02,
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      }),
                  SizedBox(
                    height: height * .09,
                  ),
                  Column(
                    children: [
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: editiNameController,
                        decoration: InputDecoration(
                            hintText: "Name",
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
                        textCapitalization: TextCapitalization.sentences,
                        controller: editiDesController,
                        decoration: InputDecoration(
                            hintText: "Contact Info.",
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
                        maxLines: 5,
                        onFieldSubmitted: (value) {},
                        controller: editiBioController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            hintText: "Bio",
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
                  ),
                ],
              ),
            );
          })),
    );
  }
}
