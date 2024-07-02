import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:lottie/lottie.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wanderlog/controller/controller.dart';
import 'package:wanderlog/controller/fire_controller.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/util/snack_bar.dart';
import 'package:wanderlog/util/style.dart';
import 'package:wanderlog/view/about.dart';
import 'package:wanderlog/view/navigation_bar.dart';
import 'package:wanderlog/view/new_request_page.dart';
import 'package:wanderlog/view/notification.dart';
import 'package:wanderlog/view/profile.dart';
import 'package:wanderlog/view/single_item_page.dart';
import 'package:wanderlog/view/splash_screen.dart';
import 'package:wanderlog/view/widgets/button.dart';
import 'package:wanderlog/view/privacy.dart';
import 'package:wanderlog/view/widgets/no_data.dart';
import 'package:wanderlog/view/widgets/rating_bar.dart';
import 'package:wanderlog/view/widgets/shimmer_effect.dart';

class HomeTab extends StatelessWidget {
  HomeTab({super.key});
  int starLength = 4;
  TextEditingController serchController = TextEditingController();
  clearsearchField() {
    serchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        drawer: Drawer(
            backgroundColor: TRANSPERENT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * .15,
                ),
                Container(
                  height: height * .4,
                  padding: const EdgeInsets.only(left: 30),
                  width: width * .5,
                  decoration: const BoxDecoration(
                      color: DARK_BLUE_COLOR,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(40, 70),
                          bottomRight: Radius.elliptical(200, 60),
                          topRight: Radius.elliptical(80, 20),
                          bottomLeft: Radius.elliptical(10, 0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      drawerButton(
                          title: "Profile",
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ProfileTab(),
                            ));
                          }),
                      drawerButton(
                          title: "Notification",
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const NotificationTab(),
                            ));
                          }),
                      drawerButton(
                          title: "About",
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const About(),
                            ));
                          }),
                      drawerButton(
                          title: "Privacy",
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>  Privacy(),
                            ));
                          }),
                      drawerButton(
                          title: "Log out",
                          onPressed: () {
                            // showLoadingIndicator(
                            //     context, "Removing credentials");
                            // Future.delayed(Duration(seconds: 2))
                            //     .then((value) {
                            FirebaseAuth.instance.signOut().then((value) {
                              // Navigator.of(context).pop();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SplashScreen()),
                                  (route) => false);
                            });

                            // });
                          }),
                    ],
                  ),
                )
              ],
            )),
        body: Consumer2<FireController, Controller>(
            builder: (context, firController, controller, child) {
          return RefreshIndicator.adaptive(
            color: DARK_BLUE_COLOR,
            onRefresh: () {
              return firController.fetchAllPost(true);
            },
            child: CustomScrollView(slivers: [
              SliverAppBar(
                toolbarHeight: height * .15,
                leading: Builder(builder: (context) {
                  return IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(
                        Icons.sort_sharp,
                        size: 33,
                      ));
                }),
                actions: [
                  navButton(
                      icon: Icons.add,
                      hight: 50,
                      width: 50,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddNewRequestPage(),
                        ));
                      }),
                  const SizedBox(
                    width: 10,
                  ),
                ],
                title: TextFormField(
                  onTap: () {
                    firController.fetchAllPost(true);
                  },
                  controller: serchController,
                  onChanged: (value) {
                    firController.serchPlace(value);
                  },
                  decoration: InputDecoration(
                      suffixIcon: const Icon(
                        Icons.search_rounded,
                        color: GREY,
                      ),
                      filled: true,
                      fillColor: REDISH_GREY,
                      hintText: "Search your",
                      hintStyle: normalStyle(letterSpacing: 1, color: GREY),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(height * .1),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: FutureBuilder(
                        future: firController.fetchGreaterThan3ratingPost(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return shimmerEffect(
                              child: Row(
                                children: [
                                  Container(
                                    height: height * .1,
                                    width: 100,
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                  SizedBox(
                                    height: height * .1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: height * .005,
                                        ),
                                        shimmerPlaceholder(
                                            height: height * .01,
                                            width: width * .5),
                                        SizedBox(
                                          height: height * .005,
                                        ),
                                        shimmerPlaceholder(
                                            height: height * .01,
                                            width: width * .3),
                                        const Expanded(child: SizedBox()),
                                        Row(
                                          children: [
                                            shimmerPlaceholder(
                                                height: height * .01,
                                                width: width * .06),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            constRatingBar(
                                                starLength.toDouble())
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          final topRate = firController.topRatedList;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Rating",
                                style: nunitoStyle(
                                    color: BLACK,
                                    fontsize: 22,
                                    fontWeight: FontWeight.w500),
                              ),
                              topRate.isEmpty
                                  ? SizedBox(
                                      width: width,
                                      height: height * .12,
                                      child: shimmerEffect(
                                        child: Lottie.asset(
                                            "assets/no data.json",
                                            height: height * .08),
                                      ),
                                    )
                                  : FlutterCarousel.builder(
                                      itemCount: topRate.length,
                                      options: CarouselOptions(
                                        autoPlay: true,
                                        viewportFraction: .99,
                                        autoPlayAnimationDuration:
                                            const Duration(milliseconds: 1000),
                                        height: height * .12,
                                      ),
                                      itemBuilder:
                                          (context, index, realIndex) =>
                                              Container(
                                        margin: const EdgeInsets.only(
                                            top: 10, bottom: 10, right: 10),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: GREY.withOpacity(.1),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  offset: const Offset(0, 0))
                                            ],
                                            color: WHITE,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        width: width,
                                        height: height * .12,
                                        child: Row(
                                          children: [
                                            Container(
                                              height: height * .1,
                                              width: 100,
                                              margin: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: GREY.shade300,
                                                  image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(
                                                          topRate[index]
                                                              .imageUrl)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                            ),
                                            SizedBox(
                                              height: height * .1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    topRate[index].placeName,
                                                    style: nunitoStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontsize: 17),
                                                  ),
                                                  SizedBox(
                                                    height: height * .005,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.location_pin,
                                                        color: GREY,
                                                        size: 18,
                                                      ),
                                                      Text(
                                                        topRate[index]
                                                            .placeName,
                                                        style: nunitoStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontsize: 15,
                                                          color: GREY,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Expanded(
                                                      child: SizedBox()),
                                                  constRatingBar(
                                                      topRate[index].rating),
                                                ],
                                              ),
                                            ),
                                            const Expanded(child: SizedBox()),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        SingleItemPage(
                                                      uid: topRate[index].uid,
                                                      rating:
                                                          topRate[index].rating,
                                                      postId: topRate[index]
                                                          .placeId!,
                                                      subtitle: topRate[index]
                                                          .placeDescription,
                                                      title: topRate[index]
                                                          .placeName,
                                                      url: topRate[index]
                                                          .imageUrl,
                                                    ),
                                                  ));
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        APP_THEME_COLOR,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7))),
                                                child: Text(
                                                  "More",
                                                  style: nunitoStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: WHITE),
                                                )),
                                            SizedBox(
                                              width: width * .02,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                            ],
                          );
                        }),
                  ),
                ),
              ),
              controller.isSerchEnable
                  ? SliverFillViewport(
                      delegate: SliverChildListDelegate([
                      Container(
                        color: Colors.red,
                        height: height,
                        width: width,
                      )
                    ]))
                  : SliverFillViewport(
                      padEnds: false,
                      viewportFraction: .04,
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: Text(
                            "Recent",
                            style: nunitoStyle(
                                color: BLACK,
                                fontsize: 22,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ])),
              FutureBuilder(
                  future: firController.fetchAllPost(false),
                  builder: (context, snasphot) {
                    if (snasphot.connectionState == ConnectionState.waiting) {
                      return SliverList(delegate:
                          SliverChildBuilderDelegate((context, index) {
                        return shimmerEffectForHome(height, width);
                      }));
                    }
                    if (firController.listOfPost.isEmpty) {
                      return SliverFillViewport(
                          padEnds: false,
                          viewportFraction: 1 / 2,
                          delegate: SliverChildListDelegate([const NoData()]));
                    }
                    final post = firController.searchList.isEmpty
                        ? firController.listOfPost
                        : firController.searchList;

                    return SliverList(
                        delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topRight,
                                padding:
                                    const EdgeInsets.only(right: 10, top: 10),
                                width: width,
                                height: height * .27,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            NetworkImage(post[index].imageUrl)),
                                    color: GREY.shade300,
                                    borderRadius: BorderRadius.circular(20)),
                                child: FutureBuilder(
                                    future: firController
                                        .fechSelectedUserData(post[index].uid,),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return shimmerEffect(
                                            child: Column(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const CircleAvatar(
                                              backgroundColor: WHITE,
                                              radius: 30,
                                            ),
                                            gap(height),
                                          ],
                                        ));
                                      }
                                      final user =
                                          firController.selecteduserData;
                                      return Column(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: WHITE,
                                            radius: 30,
                                            backgroundImage: user!
                                                    .imageUrl.isEmpty
                                                ? null
                                                : NetworkImage(user.imageUrl),
                                          ),
                                          Text(
                                            user.name,
                                            style: nunitoStyle(
                                                fontsize: 12,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      );
                                    }),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    post[index].placeName,
                                    style: poppinStyle(
                                        fontWeight: FontWeight.w500,
                                        fontsize: 26),
                                  ),
                                  constRatingBar(post[index].rating,
                                      itemSize: 12)
                                ],
                              ),
                              Text(post[index].placeDescription),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: navButton(
                                      iconSize: 10,
                                      icon: Icons.arrow_forward_ios,
                                      hight: 20,
                                      width: 20,
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => SingleItemPage(
                                            uid: post[index].uid,
                                            rating: post[index].rating,
                                            postId: post[index].placeId!,
                                            url: post[index].imageUrl,
                                            subtitle:
                                                post[index].placeDescription,
                                            title: post[index].placeName,
                                          ),
                                        ));
                                      })),
                            ],
                          ),
                        );
                      },
                      childCount: post.length,
                    ));
                  }),
              SliverFillViewport(
                  padEnds: false,
                  viewportFraction: .08,
                  delegate: SliverChildListDelegate([const SizedBox()]))
            ]),
          );
        }));
  }
}

Widget drawerButton(
    {required String title, required void Function()? onPressed}) {
  return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: normalStyle(
            color: WHITE, fontWeight: FontWeight.w600, fontsize: 16),
      ));
}
