import 'package:dating_app/src/domain/dtos/profiles/prompt_dto.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../generated/l10n.dart';
import '../../../domain/dtos/static_info/static_info.dart';
import '../../../domain/services/navigator/route_service.dart';
import '../../../utils/theme_notifier.dart';
import '../../../utils/validation.dart';

class AnswerPromptsPage extends StatefulWidget {
  AnswerPromptsPage({super.key, required this.prompt});

  PromptStaticInfoDto prompt;

  @override
  State<AnswerPromptsPage> createState() => _AnswerPromptsPageState();
}

class _AnswerPromptsPageState extends State<AnswerPromptsPage> {

  final TextEditingController _textAnswerController =
  TextEditingController(text: '');
  bool isInValid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await RouteService.pop();
          },
          icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingBig),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.prompt.value,
                style: ThemeUtils.getTitleStyle(),
              ),
              SizedBox(height: ThemeDimen.paddingNormal),
              Center(
                child: TextFormField(
                  controller: _textAnswerController,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {
                      isInValid = _textAnswerController.text.trim().isEmpty;
                    });
                  },
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  autofocus: true,
                  cursorColor: ThemeUtils.borderColor,
                  decoration: InputDecoration(
                    hintText: S.current.txt_and_write_your_own_answer.toCapitalized,
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
                  maxLength: 150,
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
      bottomNavigationBar: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              ThemeDimen.paddingSuper,
              ThemeDimen.paddingSmall,
              ThemeDimen.paddingSuper,
              ThemeDimen.paddingLarge),
          child: WidgetGenerator.bottomButton(
            selected: _textAnswerController.text.trim().isNotEmpty,
            isShowRipple:
            _textAnswerController.text.trim().isNotEmpty ? true : false,
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
      ),
    );
  }

  Future<void> onContinueHandle() async {
    if (_textAnswerController.text.trim().isNotEmpty) {
      final prompt = PromptDto(codePrompt: widget.prompt.code, answer: _textAnswerController.text.trim());
      await RouteService.pop(result: prompt);
    }
  }
}
