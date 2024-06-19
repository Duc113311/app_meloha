import 'package:dating_app/src/general/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../general/constants/app_color.dart';

class LikesChatShimmer extends StatefulWidget {
  const LikesChatShimmer({super.key});

  @override
  _LikesChatShimmerState createState() => _LikesChatShimmerState();
}

class _LikesChatShimmerState extends State<LikesChatShimmer> {
  _LikesChatShimmerState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.newMatchWidth + 16,
      child: GestureDetector(
        onTap: () => {},
        child: Column(
          children: [
            Stack(children: <Widget>[
              Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: ClipOval(
                      // child: Container (
                      //   height: AppConstants.newMatchWidth * 1.2,
                      //   width: AppConstants.newMatchWidth * 1.2,
                      //   color: Colors.greenAccent,
                      // ),
                      child: Shimmer.fromColors(
                        baseColor: AppColors.white,
                        highlightColor: Colors.grey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(
                                height: AppConstants.newMatchWidth * 1.2,
                                width: AppConstants.newMatchWidth * 1.2,
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(width: 3, color: AppColors.black),
                                  shape: BoxShape.circle,
                                  color: AppColors.color00BA83,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            ]),
          ],
        ),
      ),
    );
  }
}
