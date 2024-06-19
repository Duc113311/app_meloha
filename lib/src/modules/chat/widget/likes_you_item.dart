import 'package:dating_app/src/utils/printd.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n.dart';
import '../../../domain/dtos/like_and_top_pick/customers_like_top_dto.dart';
import '../../../general/constants/app_constants.dart';
import '../../../general/constants/app_image.dart';
import '../../../utils/image_utils.dart';
import '../../../utils/theme_notifier.dart';

class LikesYouItem extends StatefulWidget {
  LikeTopDto otherLikeYouDTO;
  void Function() onItemTap;

  LikesYouItem(
      {super.key, required this.otherLikeYouDTO, required this.onItemTap});

  @override
  State<LikesYouItem> createState() => _LikesYouItemState(
      otherLikeYouDTO: otherLikeYouDTO, onItemTap: onItemTap);
}

class _LikesYouItemState extends State<LikesYouItem> {
  _LikesYouItemState({required this.otherLikeYouDTO, required this.onItemTap});

  LikeTopDto otherLikeYouDTO;
  void Function() onItemTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.newMatchWidth * 1.2,
      child: GestureDetector(
        onTap: () => onItemTap(),
        child: Column(
          children: [
            Stack(children: <Widget>[
              Center(
                  child: GestureDetector(
                onTap: onItemTap,
                child: ClipOval(
                  child: Container(
                    height: AppConstants.newMatchWidth * 1.2,
                    // height of the button
                    width: AppConstants.newMatchWidth * 1.2,
                    // width of the button
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: Colors.yellow,
                            width: 1.5,
                            style: BorderStyle.solid),
                        shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Center(
                        child: ClipOval(
                          child: Stack(children: [
                            Image.asset(AppImages.bgBlurImage, fit: BoxFit.fill,),
                            Center(
                              child: ClipOval(
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: const BoxDecoration (
                                    gradient: LinearGradient (
                                      colors: [Colors.orangeAccent, Colors.orange],
                                    )
                                  ),
                                  child: Center(
                                    child: Text(
                                        otherLikeYouDTO.total?.toString() ?? "0",
                                        style:
                                            const TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
            ]),
            const Spacer(),
            Text(
              S.current.txtid_likes,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ThemeUtils.getTextColor().withOpacity(0.79), fontSize: 13,
              ),
            )
          ],
        ),
      ),
    );
  }
}
