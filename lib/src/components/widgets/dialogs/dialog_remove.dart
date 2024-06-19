import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/report/widget/button_gradient.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DialogRemove extends StatelessWidget {
  final VoidCallback? onTapSubmit;
  final VoidCallback? onTapBack;

  const DialogRemove({
    Key? key,
    this.onTapSubmit,
    this.onTapBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      insetPadding: EdgeInsets.all(ThemeDimen.paddingSmall),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(22),
          height: Get.height / 4,
          width: Get.width,
          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                height: 28 / 667 * Get.height,
                width: 28 / 375 * Get.width,
                AppImages.icApp,
                allowDrawingOutsideViewBox: true,
              ),
              SizedBox(
                height: ThemeDimen.paddingNormal,
              ),
              Text(
                S.current.do_you_want_to_unmatch_this_user,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: ThemeDimen.paddingBig,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonGradient(
                    widthBtn: Get.width / 3,
                    isOffBtn: false,
                    textBtn: S.current.submit,
                    onTap: onTapSubmit,
                  ),
                  ButtonGradient(
                    widthBtn: Get.width / 5,
                    isOffBtn: true,
                    isOffOnTap: false,
                    textBtn: 'not',
                    onTap: onTapBack,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
