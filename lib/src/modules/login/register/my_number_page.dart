import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:dating_app/src/app_manager.dart';
import 'package:dating_app/src/components/bloc/Login/auth_bloc.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/Login/input_info_sequence.dart';
import 'package:dating_app/src/modules/login/register/verify_phone_page.dart';
import 'package:dating_app/src/utils/location_manager.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/services/navigator/route_service.dart';
import '../../../utils/otp_manager.dart';

class MyNumberPage extends StatefulWidget {
  const MyNumberPage({Key? key}) : super(key: key);

  @override
  State<MyNumberPage> createState() => _MyNumberPageState();
}

class _MyNumberPageState extends State<MyNumberPage> {
  AuthBloc authBloc = AuthBloc();
  final TextEditingController _phoneEditingController = TextEditingController();
  bool isEnableContinue = false;
  bool isPhoneInValid = false;
  bool isValid = true;

  String? errorAuthen;

  String strPhoneCode = "84";
  String strCountryCode = "VN";
  DateTime? oldTimer;

  @override
  void initState() {
    super.initState();
    getCountry();
  }

  Future<void> getCountry() async {
    final country = await LocationManager.shared().getCountryPhone();
    if (country != null) {
      setState(() {
        strPhoneCode = country.phoneCode;
        strCountryCode = country.countryCode;
      });
    }
  }

  @override
  void dispose() {
    _phoneEditingController.dispose();
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
            if (FirebaseAuth.instance.currentUser != null) {
              if (await InputInfoSequence.showExitConfirmDialog(context) ==
                  Utils.kDialogPositiveValue) {
                try {
                  await AppManager.shared().dispose();
                  RouteService.pop();
                } catch (e) {
                  debugPrint(e.toString());
                  RouteService.pop();
                }
              }
            } else {
              RouteService.pop();
            }
          },
          icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingBig),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: ThemeDimen.paddingSmall),
            Text(
              S.current.my_number_is,
              style: ThemeUtils.getTitleStyle(),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            Container(
              height: ThemeDimen.buttonHeightBig,
              decoration: BoxDecoration(
                  color: ThemeUtils.getShadowColor(),
                  borderRadius: BorderRadius.all(
                      Radius.circular(ThemeDimen.borderRadiusNormal))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: ThemeDimen.paddingNormal),
                    child: GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          onSelect: (Country country) {
                            setState(() {
                              strCountryCode = country.countryCode;
                              strPhoneCode = country.phoneCode;
                            });
                          },
                          showPhoneCode: true,
                          countryListTheme: CountryListThemeData(
                            // backgroundColor: ThemeUtils.getPrimaryColor(),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              topRight: Radius.circular(40.0),
                            ),
                            // Optional. Styles the search field.
                            inputDecoration: InputDecoration(
                              labelStyle: ThemeUtils.getTextStyle(),
                              labelText: S.current.search,
                              hintText: S.current.search_hint,
                              prefixIcon: const Icon(Icons.search),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("$strCountryCode +$strPhoneCode",
                              style: ThemeUtils.getTextStyle()),
                          Icon(
                            Icons.arrow_drop_down,
                            color:
                                Theme.of(context).textTheme.titleSmall?.color,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    width: (Get.width - 20) * 0.55,
                    child: StreamBuilder(
                      stream: authBloc.phoneVerifyStream,
                      builder: ((context, snapshot) => TextField(
                            onTapOutside: (event) =>
                                FocusScope.of(context).unfocus(),
                            controller: _phoneEditingController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            onChanged: onChangedText,
                            autofocus: true,
                            cursorColor: ThemeUtils.borderColor,
                            decoration: InputDecoration(
                              hintText: S.current.phone_number,
                              hintStyle: ThemeUtils.getPlaceholderTextStyle(),
                              labelStyle: ThemeUtils.getTextFieldLabelStyle(),
                              border: InputBorder.none,
                            ),
                            style: ThemeUtils.getTextStyle(),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
            isEnableContinue && isValid == false
                ? Padding(
                    padding: EdgeInsets.only(top: ThemeDimen.paddingNormal),
                    child: Text(
                      requiredInputPhoneValidator(
                              _phoneEditingController.text) ??
                          '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.red),
                    ),
                  )
                : const SizedBox.shrink(),
            SizedBox(height: ThemeDimen.paddingNormal),
            Center(
              child: Text.rich(
                TextSpan(
                  style: ThemeUtils.getCaptionStyle(),
                  children: [
                    TextSpan(
                      text: '${S.current.str_my_number_verification_alert_1} ',
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = (() async {
                          if (!await launchUrl(
                              Uri.parse(Const.kUrlPhonesChangesPolicy))) {
                            Fluttertoast.showToast(
                                msg: S.current.error_when_open_url,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.white,
                                textColor: Colors.red,
                                fontSize: ThemeTextStyle.txtSizeBig);
                          }
                        }),
                      text: S.current.str_my_number_verification_alert_2,
                      style:
                          const TextStyle(decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),
            ),
            if (errorAuthen != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  errorAuthen!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )
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
              child: WidgetGenerator.bottomButton(
                selected: isEnableContinue,
                isShowRipple: isEnableContinue ? true : false,
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: onContinueOtp,
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

  String removeText(String value) {
    if (value.length <= 1) {
      return value;
    }
    if (value[0] == "0" && value[1] == "0") {
      final split = value.substring(1);
      return removeText(split);
    } else {
      return value;
    }
  }

  void onChangedText(String value) async {
    var text = _phoneEditingController.text.trim();
    final correctText = removeText(text);

    setState(() {
      if (correctText != _phoneEditingController.text) {
        _phoneEditingController.text = correctText;
      }

      isEnableContinue = _validateMobile(correctText);
      errorAuthen = null;
    });
  }

  bool _validateMobile(String phone) {
    String pattern = r'^(?:[+0]9)?[0-9]{7,14}$';
    RegExp regExp = RegExp(pattern);

    return regExp.hasMatch(phone);
  }

  void onContinueOtp() {
    if (isEnableContinue == false) return;
    // Check phone number invalid
    String phoneNumber = _phoneEditingController.text.trim();
    final isValid = _validateMobile(phoneNumber);
    setState(() {
      if (isValid) {
        isPhoneInValid = false;
        isEnableContinue = true;

        registerPhoneOtp(phoneNumber);
      } else {
        isPhoneInValid = true;
        isEnableContinue = false;
      }
    });
  }

  Future<void> registerPhoneOtp(String phone) async {
    if (OTPManager.shared().isWaiting(phone)) {
      RouteService.routeGoOnePage(VerifyPhonePage(
        "+$strPhoneCode",
        phone,
        verificationId: OTPManager.shared().verificationId,
      ));
    } else {
      final valid = OTPManager.shared().isValid(OTPModel(phone: phone));
      if (!valid) {
        errorAuthen = S.current.invalid_otp_many_failed_attempt;
        return;
      }
      Utils.showLoading();
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+$strPhoneCode $phone',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          debugPrint(e.toString());
          setState(() {
            if (e.code == FBErrorType.INVALID_PHONE_NUMBER) {
              errorAuthen = S.current.valid_phone_number_alert;
            } else {
              errorAuthen = e.code;
            }
            Utils.hideLoading();
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          RouteService.routeGoOnePage(VerifyPhonePage(
            "+$strPhoneCode",
            phone,
            verificationId: verificationId,
          ));
          Utils.hideLoading();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          Utils.hideLoading();
          // RouteService.routeGoOnePage(
          //     VerifyPhonePage("+$strPhoneCode", phone, verificationId: verificationId,));
        },
      );
    }
  }

  String? requiredInputPhoneValidator(String? value) {
    if (isValid) return '';
    if (value == null || value.isEmpty) {
      isValid = false;
      return S.current.valid_phone_number_alert;
    }

    if (value.startsWith('84') && value.length != 10) {
      isValid = false;
      return S.current.valid_phone_number_alert;
    }
    if ((value.contains('.') && value.contains('-')) ||
        !RegExp(r'^[\d\.-]+$').hasMatch(value)) {
      isValid = false;
      return S.current.valid_phone_number_alert;
    }

    if (!RegExp(
            r'^(0|84)?((3[2-9])|(5[689])|(7[06-9])|(8[1-689])|(9[0-46-9]))(\d)(\d{3})(\d{3})$')
        .hasMatch(value)) {
      isValid = false;
      return S.current.valid_phone_number_alert;
    }

    if (isEnableContinue) {
      isValid = true;
    }

    if (isPhoneInValid) {
      isValid == false;
      return S.current.valid_phone_number_alert;
    }

    setState(() {});

    return null;
  }
}
