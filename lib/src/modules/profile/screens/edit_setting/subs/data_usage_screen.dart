import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/services/navigator/route_service.dart';


class DataUsageScreen extends StatefulWidget {
  const DataUsageScreen({Key? key}) : super(key: key);

  @override
  State<DataUsageScreen> createState() => _DataUsageScreenState();
}

class _DataUsageScreenState extends State<DataUsageScreen> {
  List<_ControlObject> listControlDataUsage = [_ControlObject(S.current.on_wifiand_cellular_data, false), _ControlObject(S.current.never_autoplayvideos, false), _ControlObject(S.current.on_wifi_only, false)];
  int selected = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => RouteService.pop(),
          child:  IconButton(
            onPressed: () => RouteService.pop(),
            icon: Icon(Icons.arrow_back_ios_new_rounded,color:  ThemeUtils.getTextColor(),),
          ),
        ),
        title: Text(
          S.current.txtid_automatically_play_videos,
          style: ThemeUtils.getTextStyle(),
        ),
      ),
      body: SizedBox(
        height: double.maxFinite,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              S.current.txtid_playing_videos_uses_more_mobile_data_than_displaying_images_so_choose_when_videos_play_automatically_here,
              style: ThemeUtils.getCaptionStyle(),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    S.current.txtid_autoplay_option.toUpperCase(),
                    style: Theme.of(Get.context!).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: ThemeUtils.getShadowColor(),
                    borderRadius: BorderRadius.zero,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listControlDataUsage.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          selected = index;
                          listControlDataUsage[index].isSelected = true;
                          setState(() {});
                        },
                        child: Ink(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: ThemeDimen.paddingNormal),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: ThemeDimen.paddingSmall),
                                  Expanded(
                                    child: Text(
                                      listControlDataUsage[index].title,
                                      style: ThemeUtils.getTextStyle(),
                                    ),
                                  ),
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: listControlDataUsage[index].isSelected && selected == index ? ThemeUtils.getPrimaryColor() : Colors.transparent,
                                  ),
                                  SizedBox(width: ThemeDimen.paddingNormal),
                                ],
                              ),
                              SizedBox(height: ThemeDimen.paddingNormal),
                              (index != listControlDataUsage.length - 1)
                                  ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
                                child: WidgetGenerator.getDivider(),
                              )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ControlObject {
  late String _title;
  late bool _isSelected;

  _ControlObject(String title, bool isSelected) {
    _title = title;
    _isSelected = isSelected;
  }

  String get title => _title;

  set title(value) => _title = value;

  bool get isSelected => _isSelected;

  set isSelected(value) => _isSelected = value;
}
