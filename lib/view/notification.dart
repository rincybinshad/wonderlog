import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wanderlog/controller/fire_controller.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/util/style.dart';
import 'package:wanderlog/view/widgets/button.dart';
import 'package:wanderlog/view/widgets/no_data.dart';
import 'package:wanderlog/view/widgets/shimmer_effect.dart';

class NotificationTab extends StatelessWidget {
  const NotificationTab({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: TRANSPERENT,
        centerTitle: true,
        title: Text(
          "Notification",
          style: normalStyle(fontsize: 27, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child:
            Consumer<FireController>(builder: (context, fireController, child) {
          return FutureBuilder(
              future: fireController.fetchCurrentUSerComments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return shimmerEffect(
                      child: ListView.separated(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return tile(height, width);
                    },
                    separatorBuilder: (context, index) => const Divider(
                      endIndent: 20,
                      indent: 20,
                    ),
                  ));
                }
                final myComment = fireController.myReviews;
                return myComment.isEmpty
                    ? const Center( 
                        child: NoData(),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          return FutureBuilder(
                              future: fireController.fechSelectedUserData(
                                  myComment[index].commentedUserId,),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return tile(height, width);
                                }
                                final commenter =
                                    fireController.selecteduserData;
                                return ListTile(
                                  leading: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image:  commenter!.imageUrl.isEmpty?AssetImage("assets/noprofile.png") as ImageProvider
                                            :NetworkImage(
                                                commenter.imageUrl)),
                                        // color: DARK_BLUE_COLOR,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.elliptical(40, 50),
                                            bottomRight:
                                                Radius.elliptical(69, 90),
                                            topRight: Radius.elliptical(60, 30),
                                            bottomLeft:
                                                Radius.elliptical(60, 50))),
                                  ),
                                  title: Text(
                                    "${commenter.name}:\n${myComment[index].comment}",
                                    style:
                                        normalStyle(color: GREY, fontsize: 19),
                                  ),
                                  trailing: Text(
                                    myComment[index].time,
                                    style:
                                        normalStyle(color: GREY, fontsize: 19),
                                  ),
                                );
                              });
                        },
                        separatorBuilder: (context, index) => const Divider(
                              endIndent: 20,
                              indent: 20,
                            ),
                        itemCount: myComment.length);
              });
        }),
      ),
    );
  }

  Widget tile(height, width) {
    return ListTile(
      leading: Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage("assets/noprofile.png")),
            // color: DARK_BLUE_COLOR,
            borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(40, 50),
                bottomRight: Radius.elliptical(69, 90),
                topRight: Radius.elliptical(60, 30),
                bottomLeft: Radius.elliptical(60, 50))),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shimmerPlaceholder(height: height * .01),
          gap(
            height,
          ),
          shimmerPlaceholder(height: height * .01, width: width * .5),
          gap(
            height,
          ),
          shimmerPlaceholder(height: height * .01, width: width * .3),
        ],
      ),
      trailing: shimmerPlaceholder(height: height * .01, width: width * .1),
    );
  }
}
