import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/utils/change_notifiers/verify_email_notifier.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notification_center/notification_center.dart';

import '../../../domain/services/navigator/route_service.dart';
import '../../../general/constants/app_constants.dart';
import '../../../general/constants/app_image.dart';
import '../../../requests/auth_services.dart';
import '../../../utils/pref_assist.dart';
import '../../../utils/validation.dart';
import '../input_info_sequence.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final TextEditingController _emailVerifyController = TextEditingController();
  AuthServices authServices = AuthServices();

  bool _isEnableBtnContinue = false;
  bool _isEmailInValid = false;
  bool _isCheckedCondition = false;

  Future<void> verifyHandle() async {
    final error = VerifyEmailNotifier.shared.error;
    if (error.isEmpty) {
      final result = await showOkAlertDialog(
          context: context,
          title: S.current.success,
          okLabel: S.current.txtid_ok,
          message: S.current.txt_email_verified,
          onPopInvoked: (didPop) {
            debugPrint("did pop: $didPop");
          });

      debugPrint("result: $result");

      RouteService.routeGoOnePage(const InputInfoSequence());
    } else {
      final result = await showOkAlertDialog(
          context: context,
          title: S.current.error,
          message: S.current.txt_email_verified_failed_message,
          onPopInvoked: (didPop) {
            debugPrint("did pop: $didPop");
          });

      debugPrint("result: $result");
    }
  }

  @override
  void initState() {
    super.initState();

    VerifyEmailNotifier.shared.addListener(verifyHandle);
  }

  @override
  void dispose() {
    VerifyEmailNotifier.shared.removeListener(verifyHandle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
        leading: IconButton(
          onPressed: () async {
            if (await InputInfoSequence.showExitConfirmDialog(context) ==
                Utils.kDialogPositiveValue) {
              await RouteService.popToRootPage();
            }
          },
          icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: ThemeDimen.paddingNormal),
            Text(
              S.current.what_is_your_email,
              style: ThemeUtils.getTitleStyle(),
            ),
            SizedBox(height: ThemeDimen.paddingSmall),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.color323232)),
                color: Colors.transparent,
              ),
              child: TextField(
                onTapOutside: (event) =>
                    FocusScope.of(context).unfocus(),
                controller: _emailVerifyController,
                keyboardType: TextInputType.emailAddress,
                onChanged: onChangedText,
                autofocus: true,
                cursorColor: ThemeUtils.borderColor,
                decoration: InputDecoration(
                  hintText: S.current.enter_email_hint,
                  hintStyle: ThemeUtils.getPlaceholderTextStyle(),
                  labelStyle: ThemeUtils.getTextFieldLabelStyle(),
                  border: InputBorder.none,
                ),
                style: ThemeUtils.getTextStyle(),
              ),
            ),
           // Divider(color: AppColors.color323232,),
            SizedBox(height: ThemeDimen.paddingNormal),
            Text(
              S.current.verify_email_text,
              style: ThemeUtils.getCaptionStyle(),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            Center(
              child: Text(
                _isEmailInValid ? S.current.email_invalid : "",
                style: ThemeUtils.getErrorStyle(color: Colors.red),
              ),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),

          ],
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isCheckedCondition = !_isCheckedCondition;
                  });
                  if (_isCheckedCondition) {
                    PrefAssist.setBool(PrefConst.kReceiveNews, true);
                  } else {
                    PrefAssist.setBool(PrefConst.kReceiveNews, false);
                  }
                },
                child: Row(
                  children: <Widget>[
                    _isCheckedCondition
                        ? Icon(
                      Icons.check_box,
                      color: ThemeUtils.getPrimaryColor(),
                    )
                        : Icon(
                      Icons.check_box_outline_blank,
                      color: ThemeUtils.getTextColor(),
                    ),
                    SizedBox(width: ThemeDimen.paddingSmall),
                    Expanded(                 child: Text(
                      S.current.receive_news,
                      style: ThemeUtils.getCaptionStyle(),
                      overflow: TextOverflow.clip,
                    ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
              child: WidgetGenerator.getRippleButton(
                colorBg: _isEnableBtnContinue
                    ? ThemeUtils.getPrimaryColor()
                    : AppColors.color323232,
                isShowRipple: _isEnableBtnContinue ? true : false,
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: onContinueVerify,
                child: Center(
                  child: Text(
                    S.current.str_continue,
                    style: ThemeUtils.getButtonStyle(),
                  ),
                ),
              ),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            Center(
              child: Text(
                S.current.or.toLowerCase().toCapitalized,
                style: TextStyle(color: AppColors.color141414, fontSize: 16, fontFamily: ThemeNotifier.fontSemiBold),
              ),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            Container(
              margin:
              EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
              child: WidgetGenerator.getRippleButton(
                colorBg: Colors.white,
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: onLoginWithGoogle,
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        height: 20.toWidthRatio(),
                        width: 20.toWidthRatio(),
                        AppImages.icGoogle,
                        allowDrawingOutsideViewBox: true,
                        colorFilter: const ColorFilter.mode(ThemeColor.buttonDisable, BlendMode.srcIn),
                      ),
                      SizedBox(width: ThemeDimen.paddingNormal),
                      Text(
                        S.current.login_with_google,
                        textAlign: TextAlign.start,
                        style: ThemeUtils.getButtonStyle(color: ThemeColor.buttonDisable, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
          ],
        ),
      ),
    );
  }

  void onChangedText(String value) async {
    final validate = Validation.isValidationEmail(value);
    print("validate \"$value\" is $validate");
    setState(() {
      if (validate) {
        _isEmailInValid = false;
        _isEnableBtnContinue = true;
      } else {
        _isEmailInValid = true;
        _isEnableBtnContinue = false;
      }
    });
  }

  void onContinueVerify() {
    final email = _emailVerifyController.text;
    if (Validation.isValidationEmail(email)) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user?.email == email) {
        setError(error: S.current.txtid_opps_something_went_wrong);
        return;
      }

      String url = '${AppConstants.dynamicLink}?email=$email';
      var acs = ActionCodeSettings(
          url: url,
          handleCodeInApp: true,
          androidPackageName: AppConstants.androidPackageName,
          androidInstallApp: false,
          androidMinimumVersion: '1');

      FirebaseAuth.instance
          .sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
          .catchError((onError) {
        print('Error sending email verification $onError');
        setError(error: S.current.txt_can_not_send_email);
      }).then((value) async {

        PrefAssist.setString(Const.kVerifyEmail, email);
        FocusScope.of(context).unfocus();

        final result = await showOkAlertDialog(
            context: context,
            title: S.current.txt_check_your_mailbox_alert,
            message:
                S.current.txt_check_your_mailbox_body,
            onPopInvoked: (didPop) {
              debugPrint("did pop: $didPop");
            });

        debugPrint("result: $result");
      });
    } else {
      setError();
    }
  }

  void setError({String error = ""}) {
    setState(() {
      _isEmailInValid = true;
      _isEnableBtnContinue = false;
    });
  }

  void onLoginWithGoogle() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final provider = GoogleAuthProvider();
    await user!.linkWithProvider(provider).then((value) async {
      PrefAssist.getMyCustomer().email = user.email;
      await PrefAssist.saveMyCustomer();
      RouteService.routeGoOnePage(const InputInfoSequence());
    }).catchError((error) {
      showOkAlertDialog(
          context: context,
          title: S.current.app_title,
          message: error.toString());
    });
  }
}
