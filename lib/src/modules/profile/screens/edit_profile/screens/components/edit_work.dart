import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/requests/api_update_profile_setting.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:dating_app/src/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditWorkPage extends StatefulWidget {
  const EditWorkPage( {super.key});

  @override
  State<EditWorkPage> createState() => _EditWorkPageState();
}

class _EditWorkPageState extends State<EditWorkPage> {


  final TextEditingController _textWorkController =
  TextEditingController(text: PrefAssist.getMyCustomer().profiles?.company ?? '');

  bool isInValid = false;
  bool _isCheckedShowWork =
      PrefAssist.getMyCustomer().profiles?.showCommon?.showWork ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            RouteService.pop();
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
              PrefAssist.getMyCustomer().profiles.company = _textWorkController.text.trim();
              await PrefAssist.saveMyCustomer();
              int statusCode = await ApiProfileSetting.updateMyCustomerProfile();
              debugPrint('update status: $statusCode');
              RouteService.pop();
            },
            child: Text(
              S.current.done,
              style: ThemeUtils.getRightButtonStyle(),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingBig),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
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
                  style: ThemeUtils.getTextFieldLabelStyle(),
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
                  S.current.invalid_my_school_field,
                  style: ThemeUtils.getErrorStyle(color: Colors.red),
                ),
              )
                  : const SizedBox(),
              SizedBox(height: ThemeDimen.paddingNormal),
            ],
          ),
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
          ],
        ),
      ),
    );
  }
}
