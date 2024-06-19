import 'package:dating_app/src/components/widgets/switch_dart.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

class ShowMeOnCard extends StatelessWidget {
  const ShowMeOnCard({super.key, required this.onClick});

  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: ThemeUtils.borderColor, width: 1),
          borderRadius: BorderRadius.circular(12.toWidthRatio())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 12.toWidthRatio()),
              Text(
                S.current.show_me_on_card_stack,
                style: ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio()),
              ),
              const Spacer(),
              HLSwitch(
                  value: !PrefAssist.getMyCustomer().settings!.incognitoMode!, onToggle: (value) {
                onClick();
              },),
              const SizedBox(width: 8,),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(ThemeDimen.paddingSmall),
            child: Text(
              S.current.show_me_on_dating_notice,
              style: ThemeUtils.getTextStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
