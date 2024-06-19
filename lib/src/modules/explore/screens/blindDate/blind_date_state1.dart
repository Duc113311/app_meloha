import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/components/widgets/dating_button.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../general/constants/app_constants.dart';
import 'blind_date_state2.dart';

class BlindDateState1 extends StatefulWidget {
  const BlindDateState1({super.key, required this.idTopic});
  final String idTopic;

  @override
  State<BlindDateState1> createState() => _BlindDateState1State();
}

class _BlindDateState1State extends State<BlindDateState1> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AppImages.match9,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(0.3),
        ),
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => RouteService.pop(),
                icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _shareIdea(),
                  _getReady(),
                  _viewProfile(),
                  _btn(),
                  _sizeBox(ThemeDimen.paddingSmall),
                ].expand((e) => [e,_sizeBox(ThemeDimen.paddingNormal)]).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _shareIdea()=>Column(
    children: [
      Container(
        width: 30/375*AppConstants.width,
        height: 30,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child:  Center(
          child: _icon(Icons.question_mark,Colors.grey,20),
        ),
      ),
      _textHeadline3(S.current.share_idea),
      _textHeadline6(S.current.share_idea_info),
    ].expand((e) => [e,_sizeBox(ThemeDimen.paddingNormal)]).toList()..removeLast(),
  );

  Widget _getReady()=> Column(
    children: [
      _icon(Icons.timelapse,Colors.white,35),
      _textHeadline3(S.current.get_ready),
      _textHeadline6(S.current.get_ready_info),
    ].expand((e) => [e,_sizeBox(ThemeDimen.paddingSmall)]).toList()..removeLast(),
  );

  Widget _viewProfile()=>Column(
    children: [
      _icon(Icons.favorite,Colors.white,35),
      _textHeadline3(S.current.compatible_to_view_profiles),
      _textHeadline6(S.current.compatible_to_view_profiles_info),
    ].expand((e) => [e,_sizeBox(ThemeDimen.paddingSmall)]).toList()..removeLast(),
  );

  Widget _btn()=> Column(
    children: [
      DatingButton.generalButton(S.current.txtid_join_now, ThemeUtils.getPrimaryColor(), Colors.white, _joinBlindDate),
      _sizeBox(ThemeDimen.paddingSmall),
      WidgetGenerator.getRippleButton(
        colorBg: Colors.transparent,
        buttonHeight: ThemeDimen.buttonHeightNormal,
        buttonWidth: double.infinity,
        onClick: () {
          RouteService.pop();
        },
        child: Center(
          child: _textHeadline3("NO THANKS"),
        ),
      ),
    ],
  );

  Widget _textHeadline6(String text)=> AutoSizeText(
    text,
    style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(color: Colors.white),
    textAlign: TextAlign.center,
    overflow: TextOverflow.ellipsis,
    maxLines: 4,
  );

  Widget _textHeadline3(String text)=> AutoSizeText(
    text,
    style: Theme.of(Get.context!).textTheme.displaySmall?.copyWith(color: Colors.white),
    textAlign: TextAlign.center,
    overflow: TextOverflow.ellipsis,
  );
  Widget _icon(IconData? icon,Color? color,double? size)=>Icon(
    icon,
    size: size,
    color: color,
  );

  Widget _sizeBox(double height) => SizedBox(height: height);

  _joinBlindDate() async {
    RouteService.routeGoOnePage( BLindDateState2( idTopic: widget.idTopic,));
  }
}
