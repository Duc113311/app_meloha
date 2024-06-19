import 'package:dating_app/src/components/widgets/birth_text_input_formatter.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/printd.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:visibility_detector/visibility_detector.dart';

class InfoBirthPage extends StatefulWidget {
  final PageController pageController;

  const InfoBirthPage(this.pageController, {super.key});

  @override
  State<InfoBirthPage> createState() => _InfoBirthPageState();
}

class _InfoBirthPageState extends State<InfoBirthPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  BirtTextInputFormatter birtTextInputFormatter = BirtTextInputFormatter();
  TextEditingController birtDateInputController = TextEditingController(
      text: PrefAssist.getMyCustomer().dob != null
          ? DateTimeUtils.getStringFromDateTime(PrefAssist.getMyCustomer().dob!)
          : '');

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => widget.pageController.previousPage(
              duration:
                  const Duration(milliseconds: ThemeDimen.animMillisDuration),
              curve: Curves.easeIn),
          icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingBig),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: ThemeDimen.paddingBig),
            Text(
              S.current.my_birthday_is,
              style: ThemeUtils.getTitleStyle(),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
              height: ThemeDimen.buttonHeightBig,
              width: double.infinity,
              color: Colors.transparent,
              child: Align(
                alignment: Alignment.centerLeft,
                child: VisibilityDetector(
                  onVisibilityChanged: (visible) {
                    if (visible.visibleFraction == 1) {
                      showDatePicker();
                    }
                  },
                  key: Key("birthday"),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: birtDateInputController,
                    textAlignVertical: TextAlignVertical.center,
                    //autofocus: true,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "MM/DD/YYYY",
                      hintStyle: ThemeUtils.getPlaceholderTextStyle(),
                      labelStyle: ThemeUtils.getTextFieldLabelStyle(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ThemeUtils.getTextColor(),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ThemeUtils.getTextColor(),
                        ),
                      ),
                    ),
                    style: ThemeUtils.getTextStyle(),
                    validator: (value) {
                      debugPrint("value : $value");
                      return null;
                      // Validation.birthDateValidator(value);
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.singleLineFormatter,
                      birtTextInputFormatter,
                    ],
                    onTap: () {
                      showDatePicker();
                    },
                  ),
                ),
              ),
            ),
            validBirthDate.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: ThemeDimen.paddingNormal),
                    child: Text(
                      validBirthDate,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.red),
                    ))
                : const SizedBox(),
            SizedBox(height: ThemeDimen.paddingNormal),
            Text(
              S.current.your_age_will_public,
              style: ThemeUtils.getCaptionStyle(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
            ThemeDimen.paddingSuper,
            ThemeDimen.paddingSmall,
            ThemeDimen.paddingSuper,
            ThemeDimen.paddingLarge),
        child: WidgetGenerator.bottomButton(
          selected: birtDateInputController.text.isNotEmpty,
          isShowRipple: birtDateInputController.text.isNotEmpty ? true : false,
          buttonHeight: ThemeDimen.buttonHeightNormal,
          buttonWidth: double.infinity,
          onClick: onContinueToGenderInfo,
          child: SizedBox(
            height: ThemeDimen.buttonHeightNormal,
            child: Center(
              child: Text(
                S.current.str_continue,
                style: ThemeUtils.getButtonStyle(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String validBirthDate = "";

  showDatePicker() async {
    final DateTime now = DateTime.now();
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(now.year - Const.kSettingMaxAgeRange, now.month, 1),
        maxTime: DateTime(now.year - Const.kSettingMinAgeRange, now.month, 1),
        onChanged: (date) {}, onConfirm: (date) {
      setState(() {
        int year = date.year;
        int month = date.month;
        int day = date.day;

        setState(() {
          PrefAssist.getMyCustomer().dob = date;
          PrefAssist.saveMyCustomer();
          birtDateInputController.text = "$month/$day/$year";
        });
      });
      debugPrint('confirm $date');
    },
        currentTime: PrefAssist.getMyCustomer().dob ?? DateTime(now.year - Const.kSettingMinAgeRange, now.month, 1));
  }

  Future<void> onContinueToGenderInfo() async {
    if (birtDateInputController.text.isNotEmpty) {
      if (PrefAssist.getMyCustomer().location != null) {
        int nextPage = (widget.pageController.page ?? 2).round() + 2;
        widget.pageController.jumpToPage(nextPage);
      } else {
        widget.pageController.nextPage(
            duration:
                const Duration(milliseconds: ThemeDimen.animMillisDuration),
            curve: Curves.easeIn);
      }
    }
  }
}
