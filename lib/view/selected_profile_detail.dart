import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wanderlog/controller/fire_controller.dart';
import 'package:wanderlog/model/user_model.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/util/style.dart';
import 'package:wanderlog/view/chat_page.dart';
import 'package:wanderlog/view/widgets/shimmer_effect.dart';

class SelectedProfileDetail extends StatelessWidget {
  UserModel userModel;
  SelectedProfileDetail({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        surfaceTintColor: TRANSPERENT,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: height * .1,
                  width: width * .25,
                  decoration: BoxDecoration(
                      image: userModel.imageUrl.isEmpty
                          ? const DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage("assets/noprofile.png"))
                          : DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(userModel.imageUrl)),
                      // color: DARK_BLUE_COLOR,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.elliptical(40, 50),
                          bottomRight: Radius.elliptical(69, 90),
                          topRight: Radius.elliptical(60, 30),
                          bottomLeft: Radius.elliptical(60, 50))),
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
                        userModel.name,
                        style: poppinStyle(
                            fontWeight: FontWeight.w600, fontsize: 25),
                      ),
                      Text(
                        userModel.description,
                        style: poppinStyle(
                            fontWeight: FontWeight.w600, fontsize: 15),
                      ),
                      Text(
                        userModel.bio,
                        // overflow: TextOverflow.ellipsis,
                        style: poppinStyle(
                          fontWeight: FontWeight.w500,
                          fontsize: 12,
                        ),
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Row(
                        children: [
                          Text("Message"),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                          name: userModel.name,
                                          url: userModel.imageUrl,
                                          anotherUid: userModel.uid!,
                                        )));
                              },
                              icon: Icon(CupertinoIcons.chat_bubble_text)),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: height * .02,
            ),
            Consumer<FireController>(builder: (context, firecontroller, child) {
              return FutureBuilder(
                  future:
                      firecontroller.fechOnlySelectedUserPosts(userModel.uid),
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
                        child: GridView.builder(
                      itemCount: post.length,
                      gridDelegate: SliverQuiltedGridDelegate(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        repeatPattern: QuiltedGridRepeatPattern.inverted,
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: SizedBox(
                            child: Image.network(
                              post[index].imageUrl,
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      },
                      // childrenDelegate: SliverChildBuilderDelegate(
                      //   (context, index) => Container(
                      //     color: Colors.red,
                      //     child: Center(child: Text(index.toString())),
                      //   ),
                      // ),
                    ));
                  });
            })
          ],
        ),
      ),
    );
  }
}
