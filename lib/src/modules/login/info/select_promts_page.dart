import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/domain/dtos/profiles/prompt_dto.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../generated/l10n.dart';
import '../../../domain/dtos/static_info/static_info.dart';
import '../../../domain/services/navigator/route_service.dart';
import '../../../utils/theme_const.dart';
import '../../../utils/theme_notifier.dart';
import 'answer_prompt_page.dart';

class SelectPromptsPage extends StatefulWidget {
  const SelectPromptsPage({super.key});

  @override
  State<SelectPromptsPage> createState() => _SelectPromptsPageState();
}

class _SelectPromptsPageState extends State<SelectPromptsPage> {
  final List<CategoryPromptStaticInfoDto> _allPrompts = List.from(StaticInfoManager.shared().prompts);
  late CategoryPromptStaticInfoDto _selectedPrompts;
  int _selectedIndex = 0;

  @override
  void initState() {

    final mergePrompts =
        _allPrompts.expand((element) => element.prompts).toList();
    final mergePromptDto = CategoryPromptStaticInfoDto(
        code: "all",
        value: S.current.txt_all.toCapitalized,
        prompts: mergePrompts);

    _allPrompts.insert(0, mergePromptDto);

    _selectedPrompts = mergePromptDto;
    _selectedIndex = 0;

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
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ThemeDimen.paddingSmall),
          Row(
            children: [
              const SizedBox(width: 32),
              Text(
                S.current.txt_prompts.toCapitalized,
                style: TextStyle(
                    color: ThemeUtils.getTextColor(),
                    fontWeight: FontWeight.bold,
                    fontFamily: ThemeNotifier.fontBold,
                    fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 60,
              child: ListView.builder(
                itemCount: _allPrompts.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                        _selectedPrompts = _allPrompts[index];
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: index == _selectedIndex
                                    ? Colors.transparent
                                    : AppColors.obxColor,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              color: index == _selectedIndex
                                  ? Colors.blue
                                  : Colors.transparent,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            child: Text(
                              _allPrompts[index].value,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                  color: index == _selectedIndex
                                      ? Colors.white
                                      : ThemeUtils.getCaptionColor(), fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListView.builder(
                itemCount: _selectedPrompts.prompts.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var result = await RouteService.routeGoOnePage(
                              AnswerPromptsPage(prompt: _selectedPrompts.prompts[index],));

                          if (result is PromptDto) {
                            await RouteService.pop(result: result);
                          }

                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                    _selectedPrompts.prompts[index].value,
                                    style: ThemeUtils.getCaptionStyle(color: ThemeUtils.color646465).copyWith(fontSize: 17),
                                    overflow: TextOverflow.visible),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(color: ThemeUtils.borderColor),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(height: ThemeDimen.paddingSmall),
        ],
      ),
    );
  }
}
