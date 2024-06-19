import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/domain/dtos/profiles/prompt_dto.dart';
import 'package:dating_app/src/general/constants/app_constants.dart';
import 'package:dating_app/src/modules/login/info/select_promts_page.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../main.dart';
import '../../../components/bloc/static_info/static_info_data.dart';
import '../../../domain/services/navigator/route_service.dart';
import '../../../general/constants/app_color.dart';
import '../../../general/constants/app_image.dart';
import '../../../utils/pref_assist.dart';
import '../../../utils/utils.dart';

class InfoPromptPage extends StatefulWidget {
  final PageController pageController;

  const InfoPromptPage(this.pageController, {Key? key}) : super(key: key);

  @override
  State<InfoPromptPage> createState() => _InfoPromptPageState();
}

class _InfoPromptPageState extends State<InfoPromptPage>
    with WidgetsBindingObserver, RouteAware {
  List<PromptDto> myPrompts =
      PrefAssist.getMyCustomer().profiles?.prompts ?? [];

  bool isActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        if (isActive) {
          callBackChangeLanguage();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      default:
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);

    setState(() {
      isActive = true;
    });
  }

  @override
  void didPushNext() {
    // Route was pushed onto navigator and is now topmost route.
    isActive = false;
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
    isActive = true;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<void> callBackChangeLanguage() async {
    await StaticInfoManager.shared().loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => widget.pageController.previousPage(
              duration:
                  const Duration(milliseconds: ThemeDimen.animMillisDuration),
              curve: Curves.easeIn),
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
              PrefAssist.getMyCustomer().profiles?.prompts = [];
              await PrefAssist.saveMyCustomer();
              widget.pageController.nextPage(
                  duration: const Duration(milliseconds: 79),
                  curve: Curves.easeIn);
            },
            child: Text(
              S.current.txtid_skip,
              style: ThemeUtils.getRightButtonStyle(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingBig),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: ThemeDimen.paddingBig),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(AppImages.icInfoPrompt,
                    colorFilter: ColorFilter.mode(
                        ThemeUtils.getTextColor(), BlendMode.srcIn)),
                SizedBox(
                  width: ThemeDimen.paddingNormal,
                ),
                Expanded(
                  child: Column(
                    children: [
                      AutoSizeText(
                        S.current.txt_write_your_profile_answers.toCapitalized,
                        style: ThemeUtils.getTitleStyle(),
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: ThemeDimen.paddingBig),
            ListView.builder(
              reverse: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: AppConstants.MAX_NUMBER_PROMPT,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    DottedBorder(
                      color: ThemeUtils.borderColor,
                      strokeWidth: 1,
                      radius: const Radius.circular(10),
                      dashPattern: const [10, 10],
                      borderType: BorderType.RRect,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            _addPrompt(index);
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          AutoSizeText(
                                            (index < myPrompts.length)
                                                ? StaticInfoManager.shared().convertPrompt(
                                                myPrompts[index].codePrompt!)
                                                : S.current.txt_select_a_prompt,
                                            style: TextStyle(
                                                color: ThemeUtils.getCaptionColor(),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.toWidthRatio()),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            (index < myPrompts.length)
                                                ? myPrompts[index].answer!
                                                : S.current
                                                .txt_and_write_your_own_answer,
                                            style: TextStyle(
                                                color: ThemeUtils.color646465,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: ThemeNotifier.fontRegular,
                                                fontSize: 17),
                                            maxLines: 3,
                                            softWrap: true,
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.clip,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8,),
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (index < myPrompts.length) {
                                        _deletePrompt(index);
                                      } else {
                                        _addPrompt(index);
                                      }
                                    },
                                    child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: index < myPrompts.length
                                          ? SvgPicture.asset(
                                        AppImages.icDeleteImage,
                                        fit: BoxFit.fitWidth,
                                      )
                                          : SvgPicture.asset(
                                        AppImages.icAddPrompt,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // DottedBorder(
                    //   color: AppColors.color323232,
                    //   strokeWidth: 1,
                    //   radius: const Radius.circular(10),
                    //   dashPattern: const [5, 5],
                    //   borderType: BorderType.RRect,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: GestureDetector(
                    //       onTap: () async {
                    //         _addPrompt(index);
                    //       },
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Row(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Expanded(
                    //                 child: Column(
                    //                   crossAxisAlignment: CrossAxisAlignment.start,
                    //                   children: [
                    //                     AutoSizeText(
                    //                       (index < myPrompts.length)
                    //                           ? StaticInfoManager.shared()
                    //                           .convertPrompt(
                    //                           myPrompts[index].codePrompt!)
                    //                           : S.current.txt_select_a_prompt,
                    //                       style: const TextStyle(
                    //                           color: ThemeColor.caption,
                    //                           fontWeight: FontWeight.bold,
                    //                           fontSize: 20),
                    //                       maxLines: 2,
                    //                       overflow: TextOverflow.ellipsis,
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //               const SizedBox(width: 8,),
                    //               IconButton(
                    //                 onPressed: () {
                    //                   if (index < myPrompts.length) {
                    //                     _deletePrompt(index);
                    //                   } else {
                    //                     _addPrompt(index);
                    //                   }
                    //                 },
                    //                 icon: index < myPrompts.length
                    //                     ? SvgPicture.asset(
                    //                         AppImages.icDeleteImage,
                    //                         height: 30,
                    //                         width: 30,
                    //                       )
                    //                     : SvgPicture.asset(
                    //                         AppImages.icAddPrompt,
                    //                         width: 30,
                    //                         height: 30,
                    //                       ),
                    //               ),
                    //             ],
                    //           ),
                    //           Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               AutoSizeText(
                    //                 (index < myPrompts.length)
                    //                     ? myPrompts[index].answer!
                    //                     : S.current
                    //                         .txt_and_write_your_own_answer,
                    //                 style: ThemeUtils.getPopupTitleStyle(color: ThemeUtils.color646465, fontSize: 14.toWidthRatio()),
                    //                 maxLines: 3,
                    //                 softWrap: true,
                    //                 textAlign: TextAlign.start,
                    //                 overflow: TextOverflow.clip,
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: ThemeDimen.paddingBig),
                  ],
                );
              },
            ),
            SizedBox(height: ThemeDimen.paddingBig),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                ThemeDimen.paddingSuper,
                ThemeDimen.paddingSmall,
                ThemeDimen.paddingSuper,
                ThemeDimen.paddingLarge),
            child: WidgetGenerator.bottomButton(
              selected: myPrompts.isNotEmpty,
              isShowRipple: myPrompts.isNotEmpty,
              buttonHeight: ThemeDimen.buttonHeightNormal,
              buttonWidth: double.infinity,
              onClick: onContinueHandle,
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
    );
  }

  Future<void> _addPrompt(int index) async {
    var result = await RouteService.routeGoOnePage(const SelectPromptsPage());

    if (result is PromptDto) {
      PromptDto promptDto = result;
      if (myPrompts.length > index) {
        PromptDto current = myPrompts[index];
        current.answer = result.answer;
        current.codePrompt = result.codePrompt;
        setState(() {
          myPrompts[index] = current;
        });
      } else {
        setState(() {
          myPrompts.add(promptDto);
        });
      }

      PrefAssist.getMyCustomer().profiles?.prompts = myPrompts;
      await PrefAssist.saveMyCustomer();
    }
  }

  Future<void> _deletePrompt(int index) async {
    if (index >= myPrompts.length) {
      return;
    }
    setState(() {
      myPrompts.removeAt(index);
    });

    PrefAssist.getMyCustomer().profiles?.prompts = myPrompts;
    await PrefAssist.saveMyCustomer();
  }

  Future<void> onContinueHandle() async {
    if (myPrompts.isNotEmpty) {
      widget.pageController.nextPage(
          duration: const Duration(milliseconds: 79), curve: Curves.easeIn);
    }
  }
}
