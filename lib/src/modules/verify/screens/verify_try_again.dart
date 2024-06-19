import 'package:dating_app/src/components/widgets/dating_button.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';


class VerifyTryAgain extends StatefulWidget {
  const VerifyTryAgain({super.key});

  @override
  State<VerifyTryAgain> createState() => _VerifyTryAgainState();
}

class _VerifyTryAgainState extends State<VerifyTryAgain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(
            Icons.close_rounded,
            color: Colors.white,
            size: 30,
          ),
          onTap: () {
            RouteService.pop();
          },
        ),
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        color: ThemeColor.darkMainColor,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: Get.height / 20),
                child: Text(
                  S.current.txtid_lets_try_that_again,
                  style: ThemeTextStyle.kDatingMediumFontStyle(16, Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: ThemeDimen.paddingBig),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Column(), Column()],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    S.current.txtid_no_glare_or_extreme_lightning,
                    style: ThemeUtils.getTextStyle(),
                    textAlign: TextAlign.center,
                  ))
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          color: ThemeColor.darkMainColor,
          child: SizedBox(
            width: double.infinity,
            height: 40,
            child: DatingButton.darkButton(S.current.i_am_ready, true, iamReady),
          )),
    );
  }

  iamReady() async {}
}
