import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/modules/dating_tabbar.dart';
import 'package:dating_app/src/utils/theme_notifier.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../domain/services/navigator/route_service.dart';
import '../../../general/constants/app_image.dart';
import '../../../requests/api_utils.dart';

class RegisterCompletedPage extends StatefulWidget {
  final PageController pageController;

  const RegisterCompletedPage(this.pageController, {Key? key}) : super(key: key);

  @override
  State<RegisterCompletedPage> createState() => _RegisterCompletedPageState();
}

class _RegisterCompletedPageState extends State<RegisterCompletedPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
            statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
                ? Brightness.light
                : Brightness.dark,
          ),
          toolbarHeight: 0,
        ),
        body: Container (
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.bgLogin),
              fit: BoxFit.cover,
            ),
          ),
          constraints: const BoxConstraints.expand(),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(S.current.txt_wellcome_signup_no2, textAlign: TextAlign.center, style: TextStyle(color: AppColors.color323232, fontWeight: FontWeight.bold, fontSize: 22, fontFamily: ThemeNotifier.fontBold), ),
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          ThemeDimen.paddingSuper,
                          ThemeDimen.paddingSmall,
                          ThemeDimen.paddingSuper,
                          ThemeDimen.paddingSuper),
                      child: WidgetGenerator.bottomButton(
                        selected: true,
                        isShowRipple: true,
                        buttonHeight: ThemeDimen.buttonHeightNormal,
                        buttonWidth: double.infinity,
                        onClick: onContinueHandle,
                        child: Center(
                          child: Text(
                            S.current.str_continue,
                            textAlign: TextAlign.center,
                            style: ThemeUtils.getButtonStyle(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => widget.pageController.previousPage(
                        duration:
                        const Duration(milliseconds: ThemeDimen.animMillisDuration),
                        curve: Curves.easeIn),
                    icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onContinueHandle() async {
    Utils.showLoading();
    final error = await ApiRegLogin.sendRegister();
    if (error != null) {
      Fluttertoast.showToast(msg: error.errorMessage ?? S.current.txtid_opps_something_went_wrong);
      // Fluttertoast.showToast(
      //     msg: S.current.txtid_opps_something_went_wrong);
      Utils.hideLoading();
      return;
    }
    RouteService.routeGoOnePage(const DatingTabbar());
    Utils.hideLoading();
  }
}
