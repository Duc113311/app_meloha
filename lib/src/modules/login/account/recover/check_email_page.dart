import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../domain/services/navigator/route_service.dart';
import '../../register/my_number_page.dart';
import 'login_email_page.dart';

class CheckEmailPage extends StatefulWidget {
  const CheckEmailPage({super.key, required this.email});

  final String email;

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  TextEditingController otpEditingController = TextEditingController();
  bool hasInvalidOtp = false;
  String currentOtp = "";

  bool isResendEnable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () =>RouteService.pop(), icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade900,
            height: 1.0,
          ),
        ),
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        color: ThemeColor.darkMainColor,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: Get.height / 10),
                child: Center(
                  child: Text(
                    S.current.check_email,
                    style: Theme.of(Get.context!).textTheme.displaySmall,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 20, right: 30),
                child: Center(
                  child: Text(
                    "${S.current.email_check1} ${widget.email}, ${S.current.email_check2}",
                    style: ThemeUtils.getTextStyle(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: Get.height / 4),
                child: Center(
                  child: Text(
                    S.current.email_not_receive,
                    style: ThemeUtils.getTextStyle(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: GestureDetector(
                  onTap: () {
    RouteService.routeGoOnePage(const LoginByEmailPage());
                  },
                  child: Text(
                    S.current.use_difference_email.toUpperCase(),
                    style: Theme.of(Get.context!).textTheme.displaySmall!.copyWith(color: Colors.red),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: GestureDetector(
                  onTap: () {
    RouteService.routeGoOnePage(MyNumberPage());
                  },
                  child: Text(
                    S.current.use_your_phone_number.toUpperCase(),
                    style: Theme.of(Get.context!).textTheme.displaySmall!.copyWith(color: Colors.red),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
