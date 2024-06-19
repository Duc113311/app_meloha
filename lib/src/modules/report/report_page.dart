import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/modules/report/screens/report_about_screen.dart';
import 'package:dating_app/src/modules/report/screens/report_happen_screen.dart';
import 'package:dating_app/src/modules/report/screens/report_reason_screen.dart';
import 'package:dating_app/src/modules/report/widget/custom_progress_bar.dart';
import 'package:dating_app/src/modules/report/widget/dialog_exit_report.dart';
import 'package:dating_app/src/modules/subviews/hl_popup.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/report_cubit.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final GlobalKey<ProgessBarPageState> globalKeyProgressBar =
      GlobalKey<ProgessBarPageState>();
  PageController controller = PageController();
  ReportCubit cubit = ReportCubit();
  OverlayEntry? overlayEntry;
  int currentPos = 0;
  bool reported = false;
  bool isLoading = false;

  @override
  void initState() {
    cubit.getReason();
    super.initState();
  }

  @override
  void dispose() {
    if (overlayEntry?.mounted ?? false) {
      overlayEntry?.remove();
    }
    super.dispose();
  }

  getPage(int pos) {
    switch (pos) {
      case 0:
        {
          return ReportReasonScreen(
            onTapButtonContinue: () {
              cubit.currentPercent = 2 / 3;
              cubit.saveDataReport(
                  reasonId: cubit.state.reportDto![cubit.selectReasonId].id,
                  userId: widget.userId);
              controller.jumpToPage(1);
            },
          );
        }
      case 1:
        {
          return ReportHappenScreen(
            onTapButtonContinue: () {
              cubit.currentPercent = 3 / 3;
              controller.jumpToPage(2);
            },
          );
        }
      case 2:
        {
          return const ReportAboutScreen();
        }
    }
  }

  _renderAppBar(context) {
    return SafeArea(
      child: Container(
        color: ThemeUtils.getScaffoldBackgroundColor(),
        child: BlocBuilder<ReportCubit, ReportState>(
          builder: (context, state) {
            return Column(
              children: [
                ProgessBarPage(
                  percent: cubit.currentPercent,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      if (currentPos != 0)
                        IconButton(
                          onPressed: () {
                            controller.previousPage(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.linear);
                            cubit.currentPercent = cubit.currentPercent - 1 / 3;
                          },
                          icon: Icon(Icons.arrow_back_ios_new_rounded,
                              color: ThemeUtils.getTextColor()),
                        ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => HLPopupPage(
                                      cancelAction: () {
                                        RouteService.pop();
                                      },
                                      okAction: () async {
                                        RouteService.pop();
                                        RouteService.pop();
                                      },
                                      title: '',
                                      message:
                                          S.current.txt_cancel_report_message,
                                      okTitle: S.current.yes_cancel,
                                      cancelTitle: S.current.str_continue,
                                    ));
                          },
                          child: Text(
                            S.current.str_cancel,
                            style:
                                TextStyle(color: ThemeUtils.getPrimaryColor()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
            statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
                ? Brightness.light
                : Brightness.dark,
          ),
          toolbarHeight: 0,
        ),
        backgroundColor: ThemeUtils.getScaffoldBackgroundColor(),
        body: _buildReport(),
      ),
    );
  }

  Widget _buildReport() => BlocListener<ReportCubit, ReportState>(
        listener: (context, state) {
          if (state.runtimeType == ReportLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state.runtimeType == ReportSuccess) {
            setState(() {
              isLoading = false;
            });
          } else if (state.runtimeType == ReportComplete ||
              state.runtimeType == ReportCompleteWithError) {
            setState(() {
              isLoading = false;
            });
            RouteService.pop(result: Const.kNopeAction);
            Utils.toast(S.current.success);
          }
        },
        child: Stack(children: [
          Column(
            children: [
              _renderAppBar(context),
              Expanded(
                child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller,
                    onPageChanged: (index) {
                      setState(() {
                        currentPos = index;
                      });
                    },
                    // itemCount: 2,
                    itemBuilder: (context, index) {
                      return getPage(index);
                    }),
              ),
            ],
          ),
          if (isLoading)
            Container(
              width: context.width,
              height: context.height,
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                    color: ThemeUtils.getPrimaryColor()),
              ),
            )
        ]),
      );
}
