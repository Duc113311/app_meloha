import 'dart:async';

import 'package:dating_app/src/general/constants/app_constants.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:dating_app/src/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app_manager.dart';
import '../../../domain/services/navigator/route_service.dart';
import '../../Login/input_info_sequence.dart';
import '../login_page.dart';

class InfoNamePage extends StatefulWidget {
  final PageController pageController;

  const InfoNamePage(this.pageController, {super.key});

  @override
  State<InfoNamePage> createState() => _InfoNamePageState();
}

class _InfoNamePageState extends State<InfoNamePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _textNameController =
      TextEditingController(text: PrefAssist.getMyCustomer().fullname);

  bool isInValidFormat = false;
  bool isInvalidUsername = false;
  Timer? checkValidTimer;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            if (await InputInfoSequence.showExitConfirmDialog(context) == Utils.kDialogPositiveValue) {
            try {
            await AppManager.shared().dispose();
            } catch (e) {}
            await RouteService.routePushReplacementPage(const LoginPage());}
          },
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
          children: [
            SizedBox(height: ThemeDimen.paddingBig),
            Text(
              S.current.my_name_is,
              style: ThemeUtils.getTitleStyle(),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            Center(
              child: TextFormField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: _textNameController,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  checkValidTimer?.cancel();
                  checkValidTimer = Timer(const Duration(milliseconds: 200), () {
                    setState(() {
                      final text = _textNameController.text.trim().toLowerCase();
                      isInValidFormat = text.isEmpty;
                      isInvalidUsername = Const.blacklistNames.contains(text) || text.contains(Const.appName.toLowerCase());
                    });
                  });
                },
                autofocus: true,
                cursorColor: ThemeUtils.borderColor,
                decoration: InputDecoration(
                  hintText: S.current.your_name,
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
                maxLength: 20,
                maxLines: null,
                validator: (value) =>
                    Validation.validateStringMaxmumLength(value, 50),
              ),
            ),
            isInValidFormat || isInvalidUsername
                ? Padding(
                    padding: EdgeInsets.only(top: ThemeDimen.paddingNormal),
                    child: Text(
                      isInValidFormat ? S.current.invalid_my_name_field : S.current.txt_invalid_fullname,
                      style: ThemeUtils.getErrorStyle(color: Colors.red),
                    ),
                  )
                : const SizedBox(),
            SizedBox(height: ThemeDimen.paddingNormal),
            Text(
              S.current.fist_name_alert,
              style: ThemeUtils.getCaptionStyle(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  ThemeDimen.paddingSuper,
                  ThemeDimen.paddingSmall,
                  ThemeDimen.paddingSuper,
                  ThemeDimen.paddingLarge),
              child: WidgetGenerator.bottomButton(
                selected: _textNameController.text.trim().isNotEmpty,
                isShowRipple:
                _textNameController.text.trim().isNotEmpty ? true : false,
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: onContinueToBirthdayPage,
                child: SizedBox(
                  height: ThemeDimen.buttonHeightNormal,
                  child: Center(
                    child: Text(
                      S.current.str_continue,
                      style: ThemeUtils.getButtonStyle(),
                    )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onContinueToBirthdayPage() {
    if (_textNameController.text.trim().isNotEmpty) {
      PrefAssist.getMyCustomer().fullname = _textNameController.text.trim();
      PrefAssist.saveMyCustomer();
      FocusManager.instance.primaryFocus?.unfocus();
      widget.pageController.nextPage(
          duration: const Duration(milliseconds: ThemeDimen.animMillisDuration),
          curve: Curves.easeIn);
    } else {
      setState(() => isInValidFormat = true);
    }
  }
}
