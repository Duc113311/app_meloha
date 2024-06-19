import 'package:dating_app/src/modules/report/bloc/report_cubit.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../components/resource/molecules/text_filed_input.dart';
import '../../../general/constants/app_image.dart';
import '../widget/button_gradient.dart';

class ReportAboutScreen extends StatefulWidget {
  const ReportAboutScreen({Key? key}) : super(key: key);

  @override
  State<ReportAboutScreen> createState() => _ReportAboutScreenState();
}

class _ReportAboutScreenState extends State<ReportAboutScreen> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        return Padding(
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
                height: 30,
              ),
              Text(
                S.current.let_share,
                style: ThemeUtils.getTextStyle(),
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
                      S.current.add_a_comment,
                      style: ThemeUtils.getTextStyle(),
                    ),
                  ),
                  TextFiledInput(
                    maxLength: 200,
                    maxLine: 5,
                    controller: textEditingController,
                    onChange: (change) {
                      setState(() {});
                    },
                  ),
                ],
              ),
              const Spacer(),
              const SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: WidgetGenerator.bottomButton(
                  selected: textEditingController.text != '',
                  isShowRipple: true,
                  buttonHeight: ThemeDimen.buttonHeightNormal,
                  buttonWidth: double.infinity,
                  onClick: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    var cubit = context.read<ReportCubit>();
                    await cubit.saveDataReport(
                        comments: textEditingController.text);
                    cubit.pushReport(cubit.report);
                  },
                  child: Center(
                    child: Text(
                      S.current.submit,
                      style: ThemeUtils.getButtonStyle(),
                    ),
                  ),
                ),
              ),

            ],
          ),
        );
      },
    );
  }
}
