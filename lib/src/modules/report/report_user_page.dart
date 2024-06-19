import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/domain/dtos/reason/reason_dto.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/requests/api_report.dart';
import 'package:dating_app/src/requests/api_utils.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dating_app/src/utils/limit_range_textInput_formatter.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

class ReportUserPage extends StatefulWidget {
  ReportUserPage({
    super.key,
    required this.userId,
    required this.callback,
  });

  final String userId;
  void Function(bool success) callback;

  @override
  State<ReportUserPage> createState() => _ReportUserPageState();
}

class _ReportUserPageState extends State<ReportUserPage> {
  final TextEditingController _commentController =
      TextEditingController(text: '');

  List<ReasonDto> reasons = [];
  ReasonDto? reasonDto;
  CodeReason? codeReason;
  CodeReasonDetail? codeReasonDetail;

  int step = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  List<String> get getValues {
    switch (step) {
      case 0:
        return reasons.map((e) => e.value).toList();
      case 1:
        if (reasonDto == null) {
          return [];
        }
        return reasonDto!.codeReasons.map((e) => e.value).toList();
      default:
        if (codeReason == null) {
          return [];
        } else {
          return codeReason!.codeReasonDetails.map((e) => e.value).toList();
        }
    }
  }

  void loadData() async {
    final model = await StaticInfoManager.shared().getReasons();
    if (model != null) {
      setState(() {
        reasons = model.reasons;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          children: [child()],
        ),
      ),
    );
  }

  Widget child() {
    switch (step) {
      case 0:
        return step1Widget();
      case 1:
        return step2Widget();
      case 2:
        return step3Widget();
      case 3:
        return doneReport();
      default:
        return step1Widget();
    }
  }

  Widget step1Widget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Spacer(),
            IconButton(
                onPressed: () {
                  RouteService.pop();
                },
                icon: const Icon(Icons.close)),
            const SizedBox(
              width: 2,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            S.current.report.toCapitalized,
            style: ThemeUtils.getTitleStyle(
              fontSize: 25.toWidthRatio(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 32),
          child: Text(
            S.current.txtid_what_would_you_like_to_report_to_us,
            style: ThemeUtils.getCaptionStyle(
              fontSize: 16.toWidthRatio(),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          children: List.generate(reasons.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  reasonDto = reasons[index];
                  step += 1;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: ThemeUtils.colorGrey1(),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        reasons[index].value,
                        style: ThemeUtils.getPopupTitleStyle(
                            fontSize: 14.toWidthRatio()),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget step2Widget() {
    return (reasonDto == null || (reasonDto?.codeReasons ?? []).isEmpty)
        ? step3Widget()
        : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          step -= 1;
                        });
                      },
                      icon: const Icon(Icons.arrow_back_ios_new)),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        RouteService.pop();
                      },
                      icon: const Icon(Icons.close)),
                  const SizedBox(
                    width: 2,
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  reasonDto!.value,
                  style: ThemeUtils.getTitleStyle(
                    fontSize: 25.toWidthRatio(),
                  ),
                ),
              ),

              const SizedBox(height: 32,),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children:
                      List.generate(reasonDto!.codeReasons.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          codeReason = reasonDto!.codeReasons[index];
                          step += 1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: ThemeUtils.colorGrey1(),
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                reasonDto!.codeReasons[index].value,
                                style: ThemeUtils.getPopupTitleStyle(
                                    fontSize: 14.toWidthRatio()),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          );
  }

  Widget step3Widget() {
    return (codeReason?.codeReasonDetails ?? []).isEmpty
        ? doneReport()
        : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          step -= 1;
                        });
                      },
                      icon: const Icon(Icons.arrow_back_ios_new)),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        RouteService.pop();
                      },
                      icon: const Icon(Icons.close)),
                  const SizedBox(
                    width: 2,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  codeReason!.value,
                  style: ThemeUtils.getTitleStyle(
                    fontSize: 25.toWidthRatio(),
                  ),
                ),
              ),

              const SizedBox(height: 32,),

              Column(
                mainAxisSize: MainAxisSize.max,
                children: List.generate(codeReason!.codeReasonDetails.length,
                    (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        codeReasonDetail = codeReason!.codeReasonDetails[index];
                        step += 1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: ThemeUtils.colorGrey1(),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              codeReason!.codeReasonDetails[index].value,
                              style: ThemeUtils.getPopupTitleStyle(
                                  fontSize: 14.toWidthRatio()),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          );
  }

  Widget doneReport() {
    String title = codeReasonDetail?.value ??
        codeReason?.value ??
        reasonDto?.value ??
        S.current.report.toCapitalized;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    step -= 1;
                  });
                },
                icon: const Icon(Icons.arrow_back_ios_new)),
            const Spacer(),
            IconButton(
                onPressed: () {
                  RouteService.pop();
                },
                icon: const Icon(Icons.close)),
            const SizedBox(
              width: 2,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            title,
            style: ThemeUtils.getTitleStyle(
              fontSize: 25.toWidthRatio(),
            ),
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        Container(
          decoration: BoxDecoration(
            color: ThemeUtils.getShadowColor(),
            borderRadius:
                BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusSmall)),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 100,
              maxHeight: 200,
            ),
            child: TextField(
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(ThemeDimen.paddingSmall),
                hintText: S.current.txt_report_hint,
                hintStyle: ThemeUtils.getPlaceholderTextStyle(),
                hintMaxLines: 3,
              ),
              style: ThemeUtils.getTextFieldLabelStyle(),
              controller: _commentController,
              textAlign: TextAlign.left,
              inputFormatters: [LimitRangeTextInputFormatter(10, 500)],
              onChanged: (v) async {
                setState(() {});
              },
            ),
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
          child: SizedBox(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  ThemeDimen.paddingSuper,
                  ThemeDimen.paddingSmall,
                  ThemeDimen.paddingSuper,
                  ThemeDimen.paddingLarge),
              child: WidgetGenerator.bottomButton(
                selected: true,
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: () async {
                  if (reasonDto == null) {
                    return;
                  }

                  final code = await ApiReport.reportUser(widget.userId, reasonDto!.code, codeTitle: codeReason?.codeTitle ?? '', codeDetail: codeReasonDetail?.codeDetail ?? '', comments: _commentController.text);
                  debugPrint('report user: $code]');
                  widget.callback(code == ApiCode.success);

                  if (code == ApiCode.success) {
                    Utils.toast(S.current.success);
                  }

                  RouteService.pop();
                },
                child: SizedBox(
                  height: ThemeDimen.buttonHeightNormal,
                  child: Center(
                    child: Text(
                      S.current.submit,
                      style: ThemeUtils.getButtonStyle(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

