import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:dating_app/src/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../general/constants/app_color.dart';
import '../../../general/constants/app_image.dart';

class InfoWorkPage extends StatefulWidget {
  final PageController pageController;

  const InfoWorkPage(this.pageController, {Key? key}) : super(key: key);

  @override
  State<InfoWorkPage> createState() => _InfoWorkPageState();
}

class _InfoWorkPageState extends State<InfoWorkPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _textWorkController =
  TextEditingController(text: PrefAssist.getMyCustomer().profiles?.company ?? '');

  bool isInValid = false;
  bool _isCheckedShowWork =
      PrefAssist.getMyCustomer().profiles?.showCommon?.showWork ?? false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
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
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();

              setState(() {
                _isCheckedShowWork = false;
                _textWorkController.text = "";
              });

              PrefAssist.getMyCustomer().profiles?.showCommon.showWork = false;
              PrefAssist.getMyCustomer().profiles?.company = "";
              await PrefAssist.saveMyCustomer();
              widget.pageController.nextPage(
                  duration:
                  const Duration(milliseconds: ThemeDimen.animMillisDuration),
                  curve: Curves.easeIn);
            },
            child: Text(
              S.current.txtid_skip,
              style: ThemeUtils.getRightButtonStyle(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingBig),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ThemeDimen.paddingBig),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(AppImages.icInfoWork, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn)),
                SizedBox(
                  width: ThemeDimen.paddingNormal,
                ),
                Text(
                  S.current.txt_where_do_you_work.toCapitalized,
                  style: ThemeUtils.getTitleStyle(),
                ),
              ],
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            Center(
              child: TextFormField(
                controller: _textWorkController,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    isInValid = _textWorkController.text.trim().isEmpty;
                  });
                },
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                autofocus: true,
                cursorColor: ThemeUtils.borderColor,
                decoration: InputDecoration(
                  hintText: S.current.txt_workplace.toCapitalized,
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
                maxLength: 100,
                maxLines: null,
                validator: (value) =>
                    Validation.validateStringMaxmumLength(value, 100),
              ),
            ),
            isInValid
                ? Padding(
              padding: EdgeInsets.only(top: ThemeDimen.paddingNormal),
              child: Text(
                S.current.invalid_my_workplay_field,
                style: ThemeUtils.getErrorStyle(color: Colors.red),
              ),
            )
                : const SizedBox(),
            SizedBox(height: ThemeDimen.paddingNormal),
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
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: ThemeDimen.paddingNormal),
              child: GestureDetector(
                onTap: () async {
                  setState(
                          () => _isCheckedShowWork = !_isCheckedShowWork);
                  PrefAssist.getMyCustomer()
                      .profiles
                      ?.showCommon
                      ?.showWork = _isCheckedShowWork;
                  await PrefAssist.saveMyCustomer();
                },
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSuper),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _isCheckedShowWork
                          ? SvgPicture.asset(AppImages.ic_checkbox_selected, width: 25, height: 25,)
                          : SvgPicture.asset(AppImages.ic_checkbox_unselect, width: 25, height: 25,),
                      SizedBox(width: ThemeDimen.paddingTiny),
                      Flexible(
                        child: AutoSizeText(
                          S.current.txt_show_on_my_profile,
                          style: ThemeUtils.getTextStyle(),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          minFontSize: 7,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  ThemeDimen.paddingSuper,
                  ThemeDimen.paddingSmall,
                  ThemeDimen.paddingSuper,
                  ThemeDimen.paddingLarge),
              child: WidgetGenerator.bottomButton(
                selected: _textWorkController.text.trim().isNotEmpty,
                isShowRipple:
                _textWorkController.text.trim().isNotEmpty ? true : false,
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: onContinueHandle,
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
          ],
        ),
      ),
    );
  }

  Future<void> onContinueHandle() async {
    if (_textWorkController.text.trim().isNotEmpty) {
      PrefAssist.getMyCustomer().profiles!.company = _textWorkController.text.trim();
      await PrefAssist.saveMyCustomer();
      FocusManager.instance.primaryFocus?.unfocus();
      widget.pageController.nextPage(
          duration: const Duration(milliseconds: ThemeDimen.animMillisDuration),
          curve: Curves.easeIn);
    } else {
      setState(() => isInValid = true);
    }
  }
}
