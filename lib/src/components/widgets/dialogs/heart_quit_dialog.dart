import 'package:dating_app/src/components/widgets/dating_button.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../domain/services/navigator/route_service.dart';

class HeartLinkQuitDialog extends StatelessWidget {
  late String content;
  final VoidCallback continueCallBack;

  HeartLinkQuitDialog({super.key, required this.content, required this.continueCallBack});

  dialogContent(BuildContext context) {
    return Container(
      height: 150,
      width: Get.width - 16,
      decoration: BoxDecoration(
        color: ThemeColor.darkMainColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 10.0))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: EdgeInsets.only(top: ThemeDimen.paddingNormal),
              child: const Center(
                child: Icon(
                  Icons.verified_user,
                  color: Colors.blue,
                  size: 36,
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
            child: Center(
              child: Text(
                content,
                style: Theme.of(Get.context!).textTheme.displaySmall,
                overflow: TextOverflow.clip,
                maxLines: 4,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
            child: DatingButton.darkButton(S.current.str_continue, true, continueCallBack),
          ),
          Padding(
            padding: EdgeInsets.only(top: ThemeDimen.paddingNormal),
            child: InkWell(
              onTap: () {
                RouteService.pop();
              },
              child: Text(
                S.current.may_be_later.toUpperCase(),
                style: ThemeTextStyle.kDatingMediumFontStyle(15, Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), backgroundColor: Colors.transparent, child: dialogContent(context));
  }
}
