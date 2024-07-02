import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/util/style.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * .1,
        leadingWidth: 70,
        centerTitle: true,
        title: Text(
          "About",
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
                        offset: Offset(0, 2))
                  ],
                  color: WHITE,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: BLACK,
                )),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: SizedBox.expand(
          child: Text(
            "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam,   Lorem ipsum dolor sit amet, con Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam,   Lorem ipsum dolor sit amet, con Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam,",
            style: poppinStyle(fontsize: 20),
          ),
        ),
      ),
    );
  }
}
