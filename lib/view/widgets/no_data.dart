import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:wanderlog/util/style.dart';
import 'package:wanderlog/view/widgets/shimmer_effect.dart';

class NoData extends StatelessWidget {

  
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    return shimmerEffect(
                              child: Column(
                                children: [
                                  Lottie.asset("assets/no data.json"),
                                  Text(
                                    "No Data",
                                    style: poppinStyle(letterSpacing: 1),
                                  )
                                ],
                              ),
                            );
  }
}