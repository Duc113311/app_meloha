import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

import 'button_border.dart';
import 'button_gradient.dart';

class DialogExitReport extends StatelessWidget {
  const DialogExitReport({Key? key}) : super(key: key);

  dialogContent(BuildContext context) {
    return Container(
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
          Row(
            children: [
              const Spacer(),
              IconButton(iconSize: 30, onPressed: (){
                RouteService.pop();
              }, icon: const Icon(Icons.cancel,color: AppColors.color00BA83,))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              S.current.txt_cancel_report_message,
              style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20,),
           ButtonGradient(
            textBtn: S.current.yes_cancel,
            onTap: (){
              RouteService.pop();
              RouteService.pop();
            },
          ),
          const SizedBox(height: 20,),
          Buttonboder(
            textBtn: S.current.str_continue,
            onTap: (){
              RouteService.pop();
            },
          ),
          const SizedBox(height: 20,),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), backgroundColor: Colors.transparent, child: dialogContent(context)
    );
  }
}
