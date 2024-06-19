import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/dating_tabbar.dart';
import 'package:dating_app/src/requests/api_reg_login.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailPasswordPage extends StatefulWidget {
  const EmailPasswordPage({super.key});

  @override
  State<EmailPasswordPage> createState() => _EmailPasswordPageState();
}

class _EmailPasswordPageState extends State<EmailPasswordPage> {
  final TextEditingController _userNameController =
      TextEditingController(text: 'newman@tester.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'Bacha123!@2024');

  String oAuth2Id = '';
  bool isInValid = false;
  final fakeToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiIwMUhYVjdENERQOFBSSFRDWThQNzhLQUtHQSIsIm9BdXRoMklkIjoibURoa2tuUjZTMlJpV2ZWVk5PaTFBY0Y4UDVIMyIsImZ1bGxuYW1lIjoidnRobyIsImVtYWlsIjoidGhvdnRAYmFjaGFzb2Z0LmNvbSIsInBob25lIjoiKzg0OTY1Nzg0MDU5IiwiZXhwIjoxNzE2MzY0NzQzLCJpYXQiOjE3MTU3NTk5NDN9.k4GDjPNjqcdbiXLPhVP_afmkzBRyyk6a-8xrL7qPRKU";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => RouteService.pop(),
          icon: SvgPicture.asset(
            AppImages.icArrowBack,
            colorFilter:
                ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),
          ),
        ),
        title: Text(
          "Email - Password(Debug)",
          style: ThemeUtils.getTitleStyle(),
        ),
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: _userNameController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() {
                      isInValid = !EmailValidator.validate(value);
                    });
                  },
                  autofocus: true,
                  cursorColor: ThemeUtils.borderColor,
                  decoration: InputDecoration(
                    hintText: S.current.txtid_email,
                    hintStyle: ThemeUtils.getPlaceholderTextStyle(),
                    labelStyle: ThemeUtils.getTextFieldLabelStyle(),
                  ),
                  style: ThemeUtils.getTextStyle(),
                  maxLines: null,
                ),
              ),
              if (isInValid)
                Text(
                  "Định dạng email không hợp lệ",
                  style: ThemeUtils.getTextStyle(color: Colors.red),
                ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: false,
                  autofocus: true,
                  cursorColor: ThemeUtils.borderColor,
                  decoration: InputDecoration(
                    hintText: S.current.txt_password,
                    hintStyle: ThemeUtils.getPlaceholderTextStyle(),
                    labelStyle: ThemeUtils.getTextFieldLabelStyle(),
                  ),
                  style: ThemeUtils.getTextStyle(),
                ),
              ),
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
            Padding(
              padding: EdgeInsets.fromLTRB(
                  ThemeDimen.paddingSuper,
                  ThemeDimen.paddingSmall,
                  ThemeDimen.paddingSuper,
                  ThemeDimen.paddingLarge),
              child: WidgetGenerator.bottomButton(
                selected: !isInValid && _passwordController.text.isNotEmpty,
                isShowRipple: true,
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: onSignInTapped,
                child: SizedBox(
                  height: ThemeDimen.buttonHeightNormal,
                  child: Center(
                      child: Text(
                    S.current.login,
                    style: ThemeUtils.getButtonStyle(),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onSignInTapped() async {
    PrefAssist.setAccessToken(fakeToken);
    await StaticInfoManager.shared().loadData();
    RouteService.routePushReplacementPage(const DatingTabbar());

    return;

    final email = _userNameController.text;
    final password = _passwordController.text;

    if (!EmailValidator.validate(email)) {
      Utils.toast("Kiểm tra định dạng email");
      return;
    }

    if (password.isEmpty) {
      Utils.toast("Nhập vào password");
      return;
    }

    Utils.showLoading();
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if (credential?.user == null) {
      Utils.toast("Đăng nhập không thành công!");
      Utils.hideLoading();
      return;
    }

    oAuth2Id = await credential!.user!.getIdToken(true) ?? '';
    if (oAuth2Id.isEmpty) {
      Utils.hideLoading();
      Utils.toast("Đăng nhập không thành công!");
      return;
    }

    debugPrint("idToken:\n$oAuth2Id\n");

    PrefAssist.getMyCustomer().oAuth2Id = oAuth2Id;
    PrefAssist.getMyCustomer().email = credential?.user?.email;

    await PrefAssist.saveMyCustomer();

    LoginResponseModel? response = await loginServer(oAuth2Id);

    if (response?.customer != null) {
      await StaticInfoManager.shared().loadData();
      RouteService.routePushReplacementPage(const DatingTabbar());
      Utils.hideLoading();
    } else {
      Utils.hideLoading();
      Utils.toast("Đăng nhập không thành công!");
    }
  }

  Future<LoginResponseModel?> loginServer(String token) async {
    if (token.isEmpty) {
      return null;
    }
    Utils.showLoading();
    LoginResponseModel response = await ApiRegLogin.login(token);
    return response;
  }
}
