import 'package:dating_app/src/components/bloc/Login/auth_bloc.dart';
import 'package:dating_app/src/components/widgets/dating_textfield.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/login/account/recover/check_email_page.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../domain/services/navigator/route_service.dart';

class LoginByEmailPage extends StatefulWidget {
  const LoginByEmailPage({Key? key}) : super(key: key);

  @override
  State<LoginByEmailPage> createState() => _LoginByEmailPageState();
}

class _LoginByEmailPageState extends State<LoginByEmailPage> {
  AuthBloc authBloc = AuthBloc();
  final TextEditingController _emailEditingController = TextEditingController();
  bool isEnabledSendEmail = false;
  bool _isEmailInValid = false;

  @override
  void initState() {
    super.initState();
    configLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => RouteService.pop(),
          icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: ThemeDimen.paddingNormal),
            Text(
              S.current.login_by_email,
              style: ThemeUtils.getTitleStyle(),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            DatingTextField.darkInputField(S.current.enter_email_hint, _emailEditingController, null, onChangedText, TextInputType.emailAddress, true),
            SizedBox(height: ThemeDimen.paddingNormal),
            Center(
              child: Text(
                _isEmailInValid ? S.current.email_invalid : "",
                style: ThemeUtils.getTextStyle().copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            Center(
              child: Text(
                S.current.email_notice,
                style: ThemeUtils.getCaptionStyle(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(ThemeDimen.paddingSuper, ThemeDimen.paddingSmall, ThemeDimen.paddingSuper, ThemeDimen.paddingLarge),
        child: WidgetGenerator.getRippleButton(
          colorBg: isEnabledSendEmail ? ThemeUtils.getPrimaryColor() : AppColors.color323232,
          isShowRipple: isEnabledSendEmail ? true : false,
          buttonHeight: ThemeDimen.buttonHeightNormal,
          buttonWidth: double.infinity,
          onClick: onSendVerfifyEmail,
          child: SizedBox(
            height: ThemeDimen.buttonHeightNormal,
            child: Center(
              child: Text(
                S.current.send_email,
                style: ThemeUtils.getTitleStyle(color: ThemeUtils.getTextButtonColor()),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onChangedText(String value) {
    if (authBloc.isEmailValid(value)) {
      setState(() {
        _isEmailInValid = false;
        isEnabledSendEmail = true;
      });
    } else {
      setState(() {
        isEnabledSendEmail = false;
        _isEmailInValid = true;
      });
    }
  }

  void onSendVerfifyEmail() {
    // enable loading
    requestEmailAuth(_emailEditingController.text.toString());
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             CheckEmailPage(email: _emailEditingController.text)));
  }

  // Add deep link here
  Future<void> requestEmailAuth(String email) async {
    var acs = ActionCodeSettings(
        url: 'https://heartlink.page.link',
        // demo page link
        handleCodeInApp: true,
        iOSBundleId: "com.dating.heartlink",
        androidPackageName: "com.dating.heartlink",
        androidInstallApp: true,
        androidMinimumVersion: '24');

    // send email
    FirebaseAuth.instance
        .sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
        .catchError((onError) => debugPrint("Error sending email verification $onError"))
        .then((value) => debugPrint("Successfully send email verification "))
        .whenComplete(() => _processSendEmailSucess());
  }

  _processSendEmailSucess() async {
    // Disable loading
    RouteService.routeGoOnePage(CheckEmailPage(email: _emailEditingController.text));
    Navigator.push(context, MaterialPageRoute(builder: (context) => CheckEmailPage(email: _emailEditingController.text)));
  }

  // TEST LOADING
  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 5000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }
}

//https://firebase.google.com/docs/dynamic-links/custom-domains
// shannonaustin22111990@gmail.com
