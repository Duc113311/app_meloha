import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/dtos/report/report_dto.dart';
import '../../../general/constants/app_image.dart';
import '../bloc/report_cubit.dart';

class ReportReasonScreen extends StatefulWidget {
  const ReportReasonScreen({
    Key? key,
    required this.onTapButtonContinue,
  }) : super(key: key);
  final Function onTapButtonContinue;

  @override
  State<ReportReasonScreen> createState() => _ReportReasonScreenState();
}

class _ReportReasonScreenState extends State<ReportReasonScreen>
    with AutomaticKeepAliveClientMixin<ReportReasonScreen> {
  List<String> reasons = [];
  int currentPicker = -1;
  bool isAddData = true;

  Future<List<String>> getReason(List<ReasonsDto> reasonsDtoDto) async {
    reasons = [];
    for (int i = 0; i < reasonsDtoDto.length; i++) {
      reasons.add(reasonsDtoDto[i].reason);
    }

    return reasons;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        if (state.runtimeType == ReportSuccess && isAddData) {
          getReason(state.reportDto!);
        }
        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
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
                AutoSizeText(
                  S.current.txtid_what_would_you_like_to_report_to_us,
                  style: ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio()),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AutoSizeText(
                    S.current.txtid_we_care_about_you_and_what_you_have_to_say,
                    style: TextStyle(
                      fontSize: 15,
                      color: ThemeUtils.getTextColor(),
                    ),
                  ),
                ),

                selectReason(),
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    S.current.txtid_grow_with_us_and_enjoy_the_journey,
                    style: ThemeUtils.getTextStyle(color: AppColors.color323232),
                  ),
                ),
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
                      context.read<ReportCubit>().selectReasonId =
                          currentPicker;
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

  Widget selectReason() => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: ListView.separated(
            itemCount: reasons.length,
            padding: EdgeInsets.zero,
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
                        reasons[index],
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
  bool get wantKeepAlive => true;
}
