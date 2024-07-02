import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wanderlog/controller/controller.dart';
import 'package:wanderlog/controller/fire_controller.dart';
import 'package:wanderlog/model/review_model.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/util/snack_bar.dart';
import 'package:wanderlog/util/style.dart';
import 'package:wanderlog/view/selected_profile_detail.dart';
import 'package:wanderlog/view/widgets/button.dart';
import 'package:wanderlog/view/widgets/rating_bar.dart';
import 'package:wanderlog/view/widgets/shimmer_effect.dart';

class SingleItemPage extends StatelessWidget {
  String url;
  String uid;
  double rating;
  // String profile;
  String postId;
  // String userName;
  String title;
  String subtitle;

  SingleItemPage(
      {super.key,
      required this.rating,
      required this.postId,
      required this.subtitle,
      required this.title,
      required this.url,
      required this.uid});
  String time = DateFormat('h:mm a').format(DateTime.now());
  String date = DateFormat("dd-mm-yy EEEE").format(DateTime.now());
  double? rateIndex;
  var commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: ListView(
          children: [
            SizedBox(
              height: height * .02,
            ),
            Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.only(right: 10, top: 10),
              width: width,
              height: height * .27,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill, image: NetworkImage(url)),
                  color: GREY.shade300,
                  borderRadius: BorderRadius.circular(20)),
              child: Consumer<FireController>(
                  builder: (context, fireController, _) {
                return FutureBuilder(
                    future: fireController.fechSelectedUserData(
                      uid,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        shimmerEffect(
                          child: const CircleAvatar(
                            backgroundColor: WHITE,
                            radius: 30,
                          ),
                        );
                      }
                      final user = fireController.selecteduserData;
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SelectedProfileDetail(
                              userModel: user,
                            ),
                          ));
                        },
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: WHITE,
                              radius: 30,
                              backgroundImage: user!.imageUrl.isEmpty
                                  ? null
                                  : NetworkImage(user.imageUrl),
                            ),
                            Text(
                              user.name,
                              style: nunitoStyle(
                                  fontsize: 12, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      );
                    });
              }),
            ),
            SizedBox(
              height: height * .02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: poppinStyle(fontWeight: FontWeight.w500, fontsize: 26),
                ),
                Builder(builder: (context) {
                  return constRatingBar(rating, itemSize: 18);
                })
              ],
            ),
            SizedBox(
              height: height * .02,
            ),
            Text(subtitle)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                // expands: true,
                textCapitalization: TextCapitalization.sentences,
                controller: commentController,

                validator: (value) {
                  if (value!.isEmpty) {
                    return "Drop your comment";
                  } else {
                    return null;
                  }
                },
                maxLines: 1,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: WHITE,
                    hintText: "Comment",
                    hintStyle: nunitoStyle(),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: BLACK)),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    )),
              ),
            ),
            Consumer<FireController>(builder: (context, firController, _) {
              return IconButton(
                  onPressed: () {
                    if (commentController.text.isNotEmpty) {
                      firController
                          .addNewReview(
                              postId,
                              CommentModel(
                                  commentedUserId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  date: date,
                                  postId: postId,
                                  comment: commentController.text,
                                  time: time,
                                  postOwnnerId: uid))
                          .then((value) {
                        commentController.clear();
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => Consumer<Controller>(
                                    builder: (context, controller, child) {
                                  return Container(
                                    height: height * .2,
                                    color: WHITE,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Center(
                                          child: RatingBar.builder(
                                              initialRating: controller.rating,
                                              ignoreGestures: false,
                                              // glow: false,

                                              unratedColor: BLACK,
                                              glowColor: YELLOW,
                                              itemSize: 40,
                                              itemBuilder: (context, index) {
                                                return const Icon(
                                                  Icons.star,
                                                  color: YELLOW,
                                                );
                                              },
                                              onRatingUpdate: (index) {
                                                rateIndex = index;
                                                controller.updaterating(index);
                                              }),
                                        ),
                                        SizedBox(
                                          width: width / 2,
                                          child: customeElevtedButton(
                                              bgColor: DARK_BLUE_COLOR,
                                              textColor: WHITE,
                                              text: "Submit",
                                              width: width,
                                              height: height,
                                              onPressed: () {
                                                firController
                                                    .addRating(
                                                        postId, rateIndex)
                                                    .then((value) {
                                                  firController
                                                      .updateRatingautomatically(
                                                          postId);
                                                  controller.clearReating();
                                                  Navigator.of(context).pop();
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  );
                                }));
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.send,
                    size: 33,
                    color: DARK_BLUE_COLOR,
                  ));
            }),
          ],
        ),
      ),
    );
  }
}
