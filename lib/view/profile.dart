import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wanderlog/controller/fire_controller.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/util/style.dart';
import 'package:wanderlog/view/edit_profile_page.dart';
import 'package:wanderlog/view/widgets/button.dart';
import 'package:wanderlog/view/widgets/no_data.dart';
import 'package:wanderlog/view/widgets/shimmer_effect.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: TRANSPERENT,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: Column(
          children: [
            Consumer<FireController>(builder: (context, fireController, _) {
              return FutureBuilder(
                  future: fireController.fechSelectedUserData(
                    FirebaseAuth.instance.currentUser!.uid,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return shimmerEffectForProfile(
                          height, width, true, context);
                    }
                    
                    final data = fireController.selecteduserData;

                    return Row(
                      children: [
                        Container(
                          height: height * .1,
                          width: width * .25,
                          decoration: BoxDecoration(
                            image: data!.imageUrl.isEmpty
                                ? const DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage("assets/noprofile.png"))
                                : DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(data
                                        .imageUrl)), // color: DARK_BLUE_COLOR,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.elliptical(40, 50),
                              bottomRight: Radius.elliptical(69, 90),
                              topRight: Radius.elliptical(60, 30),
                              bottomLeft: Radius.elliptical(
                                60,
                                50,
                              ),
                            ),
                          ),
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
                                "${data.name.substring(0, 1).toUpperCase()}${data.name.substring(1)}",
                                style: poppinStyle(
                                    fontWeight: FontWeight.w600, fontsize: 25),
                              ),
                              Text(
                                data.description,
                                style: poppinStyle(
                                    fontWeight: FontWeight.w600, fontsize: 15),
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
                              customeElevtedButton(
                                width: width * .45,
                                height: height * .7,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => EditProfilePage()));
                                },
                                text: "Edit profile",
                                bgColor: LIGHT_BLUE_COLOR,
                                textColor: WHITE,
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  });
            }),
            SizedBox(
              height: height * .02,
            ),
            Consumer<FireController>(
              builder: (context, firecontroller, child) {
                return FutureBuilder(
                    future: firecontroller.fechOnlySelectedUserPosts(
                        FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Expanded(
                            child: shimmerEffect(
                          child: GridView.builder(
                            itemCount: 10,
                            gridDelegate: SliverQuiltedGridDelegate(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              repeatPattern: QuiltedGridRepeatPattern.inverted,
                              pattern: [
                                const QuiltedGridTile(2, 1),
                                const QuiltedGridTile(1, 1),
                                const QuiltedGridTile(1, 1),
                              ],
                            ),
                            itemBuilder: (context, index) {
                              return const Card();
                            },
                          ),
                        ));
                      }
                      final post = firecontroller.selectedUserPost;
                      return Expanded(
                          child: post.isEmpty
                              ? const Center(
                                  child: NoData(),
                                )
                              : GridView.builder(
                                  itemCount: post.length,
                                  gridDelegate: SliverQuiltedGridDelegate(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 20,
                                    repeatPattern:
                                        QuiltedGridRepeatPattern.inverted,
                                    pattern: [
                                      const QuiltedGridTile(2, 1),
                                      const QuiltedGridTile(1, 1),
                                      const QuiltedGridTile(1, 1),

                                      // QuiltedGridTile(2, 2),
                                      // QuiltedGridTile(2, 2),
                                    ],
                                  ),
                                  itemBuilder: (context, index) {
                                    return ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      child: SizedBox(
                                        child: Image.network(
                                          post[index].imageUrl,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  },
                                ));
                    });
              },
            )
          ],
        ),
      ),
   
    );
  }
}
