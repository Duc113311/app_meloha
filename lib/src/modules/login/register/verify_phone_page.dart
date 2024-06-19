import 'dart:async';

import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/Login/input_info_sequence.dart';
import 'package:dating_app/src/modules/dating_tabbar.dart';
import 'package:dating_app/src/modules/subviews/hl_popup.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';

import '../../../domain/services/navigator/route_service.dart';
import '../../../requests/api_utils.dart';
import '../../../utils/otp_manager.dart';
import '../../../utils/pref_assist.dart';
import '../../Login/verify/verify_email_page.dart';

class VerifyPhonePage extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;
  final String verificationId;

  const VerifyPhonePage(this.countryCode, this.phoneNumber,
      {super.key, required this.verificationId});

  @override
  State<VerifyPhonePage> createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage>
    with AutomaticKeepAliveClientMixin {
  TextEditingController otpEditingController = TextEditingController();
  final FocusNode otpCodeFocusNode = FocusNode();
  bool _isBtnContinueEnabled = false;
  bool hasInvalidOtp = false;
  bool hasSendOtp = false;
  String currentOtp = "";
  int isCanSendOtp = 0;
  late String correctPhone;

  // Firebase Auth
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationId = "";
  String strPhoneNumber = "";
  String oAuth2Id = "";

  // invalide otp code
  bool isResendEnable = false;
  String timeToResent = "";
  int leastInvalidOtp = 10; // co toi da 10 lan nhap sai ma otp
  int leastResendEnable = 3; // sau 3 lần resend nhập sai ,
  String invalidOtpMsg = "";
  bool isUserExist = false;

  int resentMaxDuration = 60;
  int currentSecond = 0;
  Timer? resentTimer;

  @override
  void initState() {
    super.initState();
    correctPhone = '${widget.countryCode} ${widget.phoneNumber}';
    verificationId = widget.verificationId;
    OTPManager.shared().registerCallback((time) {
      if (mounted) {
        setState(() {
          timeToResent = (time <= 0) ? "" : time.toTimeString();
          isResendEnable = time <= 0;
        });
        debugPrint("timeToResent: $timeToResent");
      }
    });
    OTPManager.shared().startTimer(widget.phoneNumber, verificationId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PinTheme defaultPinTheme = PinTheme(
      width: (Get.width - (ThemeDimen.paddingLarge * 2)) / 7,
      height: (Get.width - (ThemeDimen.paddingLarge * 2)) / 7,
      textStyle: ThemeUtils.getTitleStyle(),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: AppColors.color323232),
        borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
        leading: IconButton(
          onPressed: () => RouteService.pop(),
          icon: SvgPicture.asset(
            AppImages.icArrowBack,
            colorFilter:
                ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: ThemeDimen.paddingLarge),
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    correctPhone,
                    style: ThemeUtils.getTextStyle()
                        .copyWith(color: ThemeColor.grey3),
                  ),
                  Opacity(
                    opacity: isResendEnable ? 1 : 0.5,
                    child: Container(
                      height: 32.toHeightRatio(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ThemeColor.mainColor,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (isResendEnable) {
                            registerPhoneOtp();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              S.current.resend,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: ThemeNotifier.fontMedium,
                                  fontSize: 12.toWidthRatio()),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SvgPicture.asset(
                              AppImages.icReload,
                              width: 16,
                              height: 16,
                              fit: BoxFit.fill,
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            Text(
              S.current.my_code_is,
              style: TextStyle(
                fontFamily: ThemeNotifier.fontBold,
                color: ThemeUtils.getTextColor(),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: ThemeDimen.paddingBig),
            Center(
              child: Pinput(
                androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsRetrieverApi,
                defaultPinTheme: defaultPinTheme,
                errorPinTheme: defaultPinTheme.copyDecorationWith(
                    border: Border.all(color: Colors.red)),
                focusedPinTheme: defaultPinTheme.copyDecorationWith(
                    border: Border.all(
                        color: hasInvalidOtp
                            ? Colors.red
                            : ThemeUtils.getPrimaryColor())),
                submittedPinTheme: defaultPinTheme.copyDecorationWith(
                    border: Border.all(
                        color: hasInvalidOtp
                            ? Colors.red
                            : ThemeUtils.getPrimaryColor())),
                showCursor: true,
                length: 6,
                autofocus: true,
                controller: otpEditingController,
                focusNode: otpCodeFocusNode,
                // eachFieldMargin: EdgeInsets.symmetric(horizontal: 5),
                onCompleted: (String pin) => () {
                  setState(() {
                    currentOtp = pin;
                  });
                },
                pinAnimationType: PinAnimationType.scale,
                onChanged: (String value) {
                  setState(() {
                    hasInvalidOtp = false;
                    currentOtp = value;
                    _isBtnContinueEnabled =
                        value.length == 6 && leastInvalidOtp > 0;
                  });
                },
              ),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            SizedBox(
              width: Get.width,
              child: Text(
                hasInvalidOtp ? invalidOtpMsg : "",
                style: ThemeUtils.getTextStyle().copyWith(color: Colors.red),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ),
            Text(
              isUserExist
                  ? S.current.txtid_your_phone_number_already_exists
                  : "",
              style: ThemeUtils.getTextStyle().copyWith(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            // if (timeToResent.isNotEmpty)
            //   Center(
            //     child: Text(
            //       '${S.current.txt_time_remaining}: $timeToResent',
            //       style: const TextStyle(color: Colors.red),
            //     ),
            //   ),
            SizedBox(
              height: Get.height / 5,
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
                selected: _isBtnContinueEnabled,
                isShowRipple: _isBtnContinueEnabled ? true : false,
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: onVerifyOtp,
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

  // register phone number with firebase
  Future<void> registerPhoneOtp() async {
    setState(() {
      _isBtnContinueEnabled = false;
      isResendEnable = false;
      timeToResent = "";
    });

    final valid =
        OTPManager.shared().isValid(OTPModel(phone: widget.phoneNumber));
    if (!valid) {
      invalidOtpMsg = S.current.reached_limit_otp;
      return;
    }

    setState(() {
      otpEditingController.text = "";
      invalidOtpMsg = "";
      leastInvalidOtp = 10;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: correctPhone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: _onVerificationFailed,
      codeSent: (String verificationID, int? resendToken) {
        verificationId = verificationID;
        invalidOtpMsg = "";

        OTPManager.shared().startTimer(widget.phoneNumber, verificationId);
        Utils.hideLoading();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        Utils.hideLoading();
      },
    );
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.toString().contains(
        "We have blocked all requests from this device due to unusual activity. Try again later.")) {
      RouteService.pop();
      Utils.toast(exception.toString());
    }
    debugPrint("The phone verify failed : ${exception.toString()}");
    if (exception.code == 'invalid-phone-number') {
      debugPrint("The phone number entered is invalid!");
    }
  }

  handleError(String error) {
    debugPrint(error);

    Utils.hideLoading();

    setState(() {
      hasInvalidOtp = true;
      if (error == FBErrorType.CHANNEL_ERROR) {
        invalidOtpMsg = S.current.txtid_opps_something_went_wrong;
      } else if (error == FBErrorType.CREDENTIAL_ALREADY_IN_USE) {
        invalidOtpMsg = S.current.txt_fb_error_credential_already_in_use;
      } else if (error == FBErrorType.INVALID_VERIFICATION_CODE) {
        invalidOtpMsg = S.current.invalid_otp_alert;
      } else if (error == FBErrorType.PROVIDER_ALREADY_LINKED) {
        invalidOtpMsg = S.current.txt_fb_error_provider_already_linked;
      } else {
        invalidOtpMsg =
            invalidOtpMsg = S.current.txtid_opps_something_went_wrong;
      }

      leastInvalidOtp = leastInvalidOtp - 1;

      if (leastInvalidOtp == 0) {
        invalidOtpMsg = S.current.invalid_otp_many_failed_attempt;
        isResendEnable = true;
        _isBtnContinueEnabled = false;
      }
    });
  }

  void onVerifyOtp() async {
    if (currentOtp.isEmpty) {
      currentOtp = otpEditingController.text;
    }
    if (!_isBtnContinueEnabled) {
      hasInvalidOtp = true;
      invalidOtpMsg = S.current.empty_otp_alert;
      return;
    }
    Utils.showLoading();
    debugPrint("onVerifyOtp: $verificationId - $currentOtp - $correctPhone");
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: currentOtp);

    final currenUser = FirebaseAuth.instance.currentUser;
    if (currenUser != null && currenUser.phoneNumber == null) {
      setState(() {
        hasInvalidOtp = false;
      });

      await FirebaseAuth.instance.currentUser!
          .linkWithCredential(credential)
          .then((value) {
        Utils.hideLoading();
        OTPManager.shared().reset();
        PrefAssist.getMyCustomer().phone =
            value.user?.phoneNumber ?? widget.phoneNumber;
        RouteService.routePushReplacementPage(const InputInfoSequence());
      }).catchError((onError) async {
        var error = onError as FirebaseAuthException;
        handleError(error.code);
      });
    } else {
      await auth.signInWithCredential(credential).then((value) async {
        debugPrint("signInWithCredential, value: ${value.toString()}");

        setState(() {
          hasInvalidOtp = false;
        });

        if (value.user?.uid == null) {
          return;
        }

        oAuth2Id = await value.user!.getIdToken(true) ?? '';

        if (oAuth2Id.isEmpty) {
          return;
        }

        PrefAssist.getMyCustomer().oAuth2Id = oAuth2Id;
        PrefAssist.getMyCustomer().phone =
            value.user?.phoneNumber ?? widget.phoneNumber;
        PrefAssist.getMyCustomer().email = value.user?.email;

        if (value.user?.email == null) {
          OTPManager.shared().reset();

          await PrefAssist.saveMyCustomer();
          RouteService.routePushReplacementPage(const VerifyEmailPage());
          Utils.hideLoading();
        } else {
          debugPrint("UID : $oAuth2Id");
          OTPManager.shared().reset();

          LoginResponseModel loginResponseModel =
              await ApiRegLogin.login(oAuth2Id);

          Utils.hideLoading();
          if (loginResponseModel.customer != null) {
            RouteService.routePushReplacementPage(const DatingTabbar());
          } else if (loginResponseModel?.blockExtraInfo != null) {
            Utils.hideLoading();
            if (!mounted) {
              return;
            }
            final extraInfo = loginResponseModel!.blockExtraInfo!;
            String message = '${S.current.txt_blocked_message}\n';
            String? date;
            if (extraInfo.disable != true) {
              var formatter = DateFormat('dd MMMM yyyy HH:mm a');
              date = formatter.format(extraInfo.toDate);

              message += S.current.txt_blocked_toDate;
            }
            showDialog(
                context: context,
                builder: (BuildContext context) => HLPopupNotification(
                      okAction: () async {
                        await FirebaseAuth.instance.signOut();
                        RouteService.pop();
                      },
                      title: S.current.txt_blocked_title,
                      message: message,
                      highlightMessage: date,
                      okTitle: S.current.txtid_ok,
                    ));
          } else {
            await PrefAssist.saveMyCustomer();
            RouteService.routePushReplacementPage(const InputInfoSequence());
          }
        }
      }).catchError((onError) {
        debugPrint('SignIn Error: ${onError.toString()}\n\n');
        var error = onError as FirebaseAuthException?;
        if (error != null) {
          handleError(error.code);
        }

        Utils.hideLoading();
      });
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class FBErrorType {
  ///da lien ket voi account khac
  static const String INVALID_PHONE_NUMBER = "invalid-phone-number";

  ///da lien ket voi account khac
  static const String CHANNEL_ERROR = "channel-error";

  ///da lien ket truoc roi
  static const String PROVIDER_ALREADY_LINKED = "provider-already-linked";

  ///account da duoc su dung
  static const String CREDENTIAL_ALREADY_IN_USE = "credential-already-in-use";

  //Sai OTP
  static const String INVALID_VERIFICATION_CODE = "invalid-verification-code";

  static const String INVALID_VERIFICATION_ID = "invalid-verification-id";
}
