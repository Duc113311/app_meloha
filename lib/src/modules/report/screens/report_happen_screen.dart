import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/modules/report/bloc/report_cubit.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/dtos/report/report_dto.dart';
import '../../../general/constants/app_image.dart';

class ReportHappenScreen extends StatefulWidget {
  const ReportHappenScreen({Key? key, required this.onTapButtonContinue}) : super(key: key);
  final Function onTapButtonContinue;

  @override
  State<ReportHappenScreen> createState() => _ReportHappenScreenState();
}

class _ReportHappenScreenState extends State<ReportHappenScreen> with AutomaticKeepAliveClientMixin<ReportHappenScreen>{
  int currentPicker = -1;
  List<String> detailReasons = [];
  bool isAddData = true;

  Future<List<String>> getDetail(List<ReasonsDto> reasonsDtoDto) async {
    var index = context.read<ReportCubit>().selectReasonId;
    detailReasons = reasonsDtoDto[index].details;
    return detailReasons;
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        if (state.runtimeType == ReportSuccess && isAddData) {
          //isAddData = false;
          getDetail(state.reportDto!);
          //detailReason.insert(0, 'Lý do');
        }
        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification){
            notification.disallowIndicator();
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                SvgPicture.asset(
                  AppImages.icSafety,
                  color: ThemeUtils.getPrimaryColor(),
                  height: 60,
                  width: 60,
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  S.current.txtid_what_is_your_reason_for_reporting,
                  style:  ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio()),
                ),
                const SizedBox(
                  height: 32,
                ),
                selectDetailReason(),
                const SizedBox(
                  height: 32,
                ),
                //  Text(
                //   'Cusng tooi',
                //   style:  ThemeUtils.getTextStyle(),
                // ),
                const SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: WidgetGenerator.bottomButton(
                    selected: currentPicker >= 0,
                    isShowRipple: true,
                    buttonHeight: ThemeDimen.buttonHeightNormal,
                    buttonWidth: double.infinity,
                    onClick: () {
                      widget.onTapButtonContinue();
                      context.read<ReportCubit>().saveDataReport(reasonDetail: detailReasons[currentPicker]);
                    },
                    child: Center(
                      child: Text(
                        S.current.txt_next,
                        style: ThemeUtils.getButtonStyle(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget selectDetailReason() => Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: ListView.separated(
        itemCount: detailReasons.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                currentPicker = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                      child: AutoSizeText(
                        detailReasons[index],
                        maxLines: 2,
                        style: TextStyle(
                            color: ThemeUtils.getTextColor(),
                            fontSize: 15,
                            fontWeight: index == currentPicker
                                ? FontWeight.bold
                                : FontWeight.normal),
                      )),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Container(
                      color: Colors.transparent,
                      child: index == currentPicker
                          ? Icon(Icons.check_rounded, color: ThemeUtils.getPrimaryColor())
                          : const SizedBox(),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
        const Divider(),
      ),
    ),
  );

  @override
  bool get wantKeepAlive => false;
}
