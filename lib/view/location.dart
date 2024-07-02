import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wanderlog/controller/controller.dart';
import 'package:wanderlog/controller/fire_controller.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/util/style.dart';
import 'package:wanderlog/view/single_item_page.dart';
import 'package:wanderlog/view/widgets/button.dart';
import 'package:wanderlog/view/widgets/no_data.dart';
import 'package:wanderlog/view/widgets/rating_bar.dart';
import 'package:wanderlog/view/widgets/shimmer_effect.dart';

class LocationTab extends StatelessWidget {
  LocationTab({super.key});
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: TRANSPERENT,
        centerTitle: true,
        title: Text(
          "Location",
          style: normalStyle(fontsize: 27, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: Column(children: [
          Consumer<FireController>(builder: (context, fireController, _) {
            return TextFormField(
              controller: searchController,
              onTap: () {
                fireController.fetchAllPost(true);
              },
              onChanged: (value) {
                fireController.serchPlace(value);
              },
              decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.search_rounded,
                    color: GREY,
                  ),
                  // filled: true,
                  // fillColor: REDISH_GREY,
                  hintText: "Search your",
                  hintStyle: normalStyle(letterSpacing: 1, color: GREY),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
            );
          }),
          SizedBox(
            height: height * .02,
          ),
          Consumer<FireController>(builder: (context, fireController, child) {
            return FutureBuilder(
                future: fireController.fetchAllPost(false),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                      child: shimmerEffect(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: width,
                                  height: height * .12,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                        // height: height * .1,
                                        width: width * .6,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            shimmerPlaceholder(
                                                height: height * .02,
                                                width: width * .3),
                                            SizedBox(
                                              height: height * .005,
                                            ),
                                            shimmerPlaceholder(
                                              height: height * .01,
                                            ),
                                            gap(height),
                                            shimmerPlaceholder(
                                                height: height * .01,
                                                width: width * .4),
                                            gap(height),
                                            // const Expanded(child: SizedBox()),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                constRatingBar(2, itemSize: 13),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                    height: height * .02,
                                  ),
                              itemCount: 10)),
                    );
                  }
                  final post = fireController.searchList.isEmpty
                      ? fireController.listOfPost
                      : fireController.searchList;
                  return Expanded(
                    child: post.isEmpty
                        ? const Center(
                            child: NoData(),
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: width,

                                //changed here..................................................
                                height: height * .12,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                                  post[index].imageUrl)),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    SizedBox(
                                      // height: height * .12,
                                      width: width * .6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                post[index].placeName,
                                                style: nunitoStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontsize: 25),
                                              ),
                                              Spacer(),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                  color: Colors.green,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    const CircleAvatar(
                                                      radius: 8,
                                                      backgroundColor: WHITE,
                                                      child: Icon(
                                                        size: 12,
                                                        Icons
                                                            .currency_rupee_rounded,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      post[index].amount,
                                                      style: poppinStyle(
                                                          color: WHITE),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * .005,
                                          ),
                                          Flexible(
                                            child: Text(
                                              post[index].placeDescription,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: nunitoStyle(
                                                fontWeight: FontWeight.bold,
                                                fontsize: 15,
                                                color: GREY,
                                              ),
                                            ),
                                          ),
                                          // const Expanded(child: SizedBox()),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              constRatingBar(post[index].rating,
                                                  itemSize: 13),
                                              navButton(
                                                  icon: Icons
                                                      .arrow_forward_ios_sharp,
                                                  hight: 20,
                                                  width: 20,
                                                  iconSize: 10,
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          SingleItemPage(
                                                        uid: post[index].uid,
                                                        rating:
                                                            post[index].rating,
                                                        postId: post[index]
                                                            .placeId!,
                                                        subtitle: post[index]
                                                            .placeDescription,
                                                        title: post[index]
                                                            .placeName,
                                                        url: post[index]
                                                            .imageUrl,
                                                      ),
                                                    ));
                                                  })
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                                  height: height * .02,
                                ),
                            itemCount: post.length),
                  );
                });
          }),
        ]),
      ),
    );
  }
}
