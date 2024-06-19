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

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({super.key});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final TextEditingController _textAddressController = TextEditingController(
      text: PrefAssist.getMyCustomer().profiles?.address ?? '');

  bool isInValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            RouteService.pop();
          },
          icon: SvgPicture.asset(
            AppImages.icArrowBack,
            colorFilter:
                ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),
          ),
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
              PrefAssist.getMyCustomer().profiles.address =
                  _textAddressController.text.trim();
              await PrefAssist.saveMyCustomer();
              int statusCode =
                  await ApiProfileSetting.updateMyCustomerProfile();
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
                  Text(
                    S.current.profile_edit_living_in.toCapitalized,
                    style: ThemeUtils.getTitleStyle(),
                  ),
                ],
              ),
              SizedBox(height: ThemeDimen.paddingNormal),
              Center(
                child: TextFormField(
                  controller: _textAddressController,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {
                      isInValid = _textAddressController.text.trim().isEmpty;
                    });
                  },
                  autofocus: true,
                  cursorColor: ThemeUtils.borderColor,
                  decoration: InputDecoration(
                    hintText: S.current.profile_edit_living_in.toCapitalized,
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
              SizedBox(height: ThemeDimen.paddingNormal),
            ],
          ),
        ),
      ),
    );
  }
}
