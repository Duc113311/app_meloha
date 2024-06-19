import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

class ExploreShimmer extends StatelessWidget {
  const ExploreShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primaryColor,
      highlightColor: AppColors.color00BA83,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Column(
          children: [
            Container(
              height: 10,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              height: 20,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
