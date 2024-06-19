import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:dating_app/src/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InfoMyUniversityPage extends StatefulWidget {
  final PageController pageController;

  const InfoMyUniversityPage(this.pageController, {Key? key}) : super(key: key);

  @override
  State<InfoMyUniversityPage> createState() => _InfoMyUniversityPageState();
}

class _InfoMyUniversityPageState extends State<InfoMyUniversityPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _textController =
      TextEditingController(text: PrefAssist.getMyCustomer().profiles?.school);


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
        leading: IconButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            widget.pageController.previousPage(
                duration:
                    const Duration(milliseconds: ThemeDimen.animMillisDuration),
                curve: Curves.easeIn);
          },
          icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingBig),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ThemeDimen.paddingSmall),
            Text(
              S.current.my_university_is,
              style: ThemeUtils.getTitleStyle(),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            Center(
              child: TextFormField(
                onTapOutside: (s) {
                  FocusScope.of(context).unfocus();
                },
                controller: _textController,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  PrefAssist.getMyCustomer().profiles?.school = value;
                  PrefAssist.saveMyCustomer();
                  setState(() {});
                },
                autofocus: true,
                cursorColor: ThemeUtils.borderColor,
                decoration: InputDecoration(
                  hintText: S.current.university_name,
                  hintStyle: ThemeUtils.getPlaceholderTextStyle(),
                  labelStyle: ThemeUtils.getTextFieldLabelStyle(),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(ThemeDimen.borderRadiusNormal),
                    borderSide: BorderSide(
                      color: ThemeUtils.getShadowColor(),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(ThemeDimen.borderRadiusNormal),
                    borderSide: BorderSide(
                      color: ThemeUtils.getShadowColor(),
                    ),
                  ),
                ),
                style: ThemeUtils.getTextStyle(),
                maxLength: 128,
                maxLines: null,
                validator: (value) =>
                    Validation.validateStringMaxmumLength(value, 128),
              ),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            Text(
              S.current.university_will_appear,
              style: ThemeUtils.getCaptionStyle(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        curve: Curves.fastOutSlowIn,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  ThemeDimen.paddingSuper,
                  ThemeDimen.paddingSmall,
                  ThemeDimen.paddingSuper,
                  ThemeDimen.paddingLarge),
              child: WidgetGenerator.getRippleButton(
                colorBg: _textController.text.isNotEmpty
                    ? ThemeUtils.getPrimaryColor()
                    : AppColors.color323232,
                isShowRipple: _textController.text.isNotEmpty ? true : false,
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: onContinueToInterestPage,
                child: Center(
                  child: Text(
                    S.current.str_continue,
                    style: ThemeUtils.getButtonStyle(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onContinueToInterestPage() {
    if (_textController.text.isNotEmpty) {
      PrefAssist.getMyCustomer().profiles?.school = _textController.text;
      PrefAssist.saveMyCustomer();
      FocusManager.instance.primaryFocus?.unfocus();
      widget.pageController.nextPage(
          duration: const Duration(milliseconds: ThemeDimen.animMillisDuration),
          curve: Curves.easeIn);
    }
  }
}
