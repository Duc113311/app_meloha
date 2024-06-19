import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/src/components/widgets/dating_button.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/modules/subviews/upgrade_button.dart';
import 'package:dating_app/src/modules/verify/screens/enable_camera.dart';
import 'package:dating_app/src/modules/verify/screens/lets_you_verified.dart';
import 'package:dating_app/src/utils/change_notifiers/premium_notifier.dart';
import 'package:dating_app/src/utils/change_notifiers/tabbar_item_notifier.dart';
import 'package:dating_app/src/utils/change_notifiers/verify_account_notifier.dart';
import 'package:dating_app/src/utils/explore_manager.dart';
import 'package:dating_app/src/utils/extensions/color_ext.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/filter_manager.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../domain/dtos/topics/topic_dto.dart';
import '../../../../general/constants/app_image.dart';
import '../../../../utils/cache_image_manager.dart';
import '../../../likes_and_tops_pick/screens/liketop_tabbar_controller.dart';
import '../../widget/explore_shimmer.dart';
import '../verifyPhoto/verify_detail.dart';
import 'explore_detail_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool wantKeepAlive = true;

  List<TopicDto> _topics = [];
  TopicDto? _verifyTopic;
  int step = 0;
  bool showVerifyBox = false;
  bool showLikePage = false;
  int loadStep = 0;
  bool bannerLoaded = false;
  bool showLoading = true;


  @override
  void initState() {
    super.initState();
    loadData();
    ThemeNotifier.themeModeRef.addListener(() {
      setState(() {});
    });
    VerifyAccountNotifier.shared.addListener(() {
      if (mounted) {
        setState(() {

        });
      }
    });

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (bannerLoaded) {
        if(mounted) {
          setState(() {});
        }
        timer.cancel();
      }
    });

    PremiumNotifier.shared.addListener(() {
      if(mounted) {
        setState(() {});
      }
      debugPrint(PremiumNotifier.shared.isPremium.toString());
    });

    TabbarItemNotifier.shared.addListener(tabbarItemChanged);
  }

  void tabbarItemChanged() {
    int index = TabbarItemNotifier.shared.tabbarIndex;
    if (index != 2) {
      setState(() {
        showLikePage = false;
      });
    }
  }
  @override
  void dispose() {
    TabbarItemNotifier.shared.removeListener(tabbarItemChanged);
    super.dispose();
  }

  Future loadData() async {
    final topics = await ExploreManager.shared().getListTopic();
    setState(() {
      if (mounted) {
        _topics = topics.where((element) => element.typeExplore == 1).toList();
        _verifyTopic =
            topics.firstWhereOrNull((element) => element.typeExplore == 0);
        showLoading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
              statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
                  ? Brightness.light
                  : Brightness.dark,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  S.current.app_title.toUpperCase(),
                  style: ThemeUtils.getTitleStyle(
                      color: ThemeUtils.getTextColor()),
                ),
                const Spacer(),
              ],
            ),
            actions: [
              UpgradeButton(
                isPremium: PremiumNotifier.shared.isPremium,
              ),
            ],
          ),
          body: showLikePage
              ? Container(
            color: Colors.red,
                child: LikePickTabBar(
                    backHandle: () {
                      setState(() {
                        showLikePage = false;
                      });
                      FilterLikeManager.shared.resetFilter();
                    },
                  ),
              )
              : showLoading
                  ? const SizedBox(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox(
                      height: Get.height,
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                                horizontal: ThemeDimen.paddingSmall),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: ThemeDimen.paddingNormal),
                                Column(
                                  children: [
                                    if (_verifyTopic != null)
                                      verify(_verifyTopic!),
                                    SizedBox(height: ThemeDimen.paddingBig),
                                    listTopicViews(_topics),
                                  ],
                                ),
                                SizedBox(height: ThemeDimen.paddingNormal),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 8,
                            bottom: 0,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  showLikePage = true;
                                });
                              },
                              child: SvgPicture.asset(
                                AppImages.btLike,
                                width: 67.toWidthRatio(),
                                height: 67.toWidthRatio(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate(delay: 500.ms).fadeIn(),
        ),
        if (showVerifyBox)
          Container(
              width: Get.width,
              height: Get.height,
              color: ThemeUtils.getTextColor().withOpacity(0.25),
              child: Center(child: boxVerify())),
      ],
    );
  }

  Widget listTopicViews(List<TopicDto> topics) {
    if (topics.isNotEmpty) {
      return GridView.count(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: ThemeDimen.paddingSmall,
        mainAxisSpacing: ThemeDimen.paddingSmall,
        children: List.generate(
          _topics.length,
          (index) {
            return hasData(_topics[index]);
          },
        ),
      );
    }

    return GridView.count(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1,
      crossAxisSpacing: ThemeDimen.paddingSmall,
      mainAxisSpacing: ThemeDimen.paddingSmall,
      children: List.generate(
        4,
        (index) {
          return shimmer();
        },
      ),
    );
  }

  Widget verify(TopicDto topic) => Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusSmall),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (PrefAssist.getMyCustomer().verified ==
                        Const.kVerifyAccountSuccess) {

                      RouteService.routeGoOnePage(const VerifyDetailPage());
                      return;
                    }
                    if (PrefAssist.getMyCustomer().verified ==
                        Const.kVerifyAccountPending) {
                      Utils.toast(
                          S.current.txtid_your_account_is_being_verified);
                      return;
                    }

                    setState(() {
                      showVerifyBox = true;
                    });
                  },
                  child: CachedNetworkImage(
                    height: (Get.width - 20) / 3,
                    width: Get.width - 20,
                    fit: BoxFit.cover,
                    imageUrl: topic.image,
                    progressIndicatorBuilder: (BuildContext context, String url,
                        DownloadProgress downloadProgress) {
                      //do something with value when value == 1
                      double? value =
                          downloadProgress.progress; //between 0 and 1

                      loadStep += 1;
                      if (loadStep >= 2) {
                        double val = value ?? 1;
                        if (val >= 1) {
                          print("explore value: $value");
                          bannerLoaded = true;
                        }
                      }
                      return Container();
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  right: Get.width / 2,
                  child: Center(
                    child: Text(
                      S.current.txtid_verified_photo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ThemeDimen.paddingNormal),
          if (bannerLoaded)
            AutoSizeText(S.current.lets_find_people_same_with_your_viber,
                style: ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio())),
        ],
      );

  Widget shimmer() => Shimmer.fromColors(
        baseColor: AppColors.color7B7B7B,
        highlightColor: AppColors.black,
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
          ),
        ),
      );

  Widget hasData(TopicDto topicDto) => GestureDetector(
        onTap: () async {
          if (topicDto.id == ExploreManager.shared().blindDateId) {
            debugPrint("tinh nang chua lam");
          } else {
            if (!(PrefAssist.getMyCustomer().explore?.topics ?? [])
                .contains(topicDto.id)) {
              final model =
                  await ExploreManager.shared().joinTopic(topicDto.id);
              if (model != null) {
                PrefAssist.getMyCustomer().explore = model.explore;
                PrefAssist.saveMyCustomer();
              }
            }

            BHCacheImageManager.shared().pauseCache();
            await RouteService.routeGoOnePage(
              ExploreDetailPage(topicDto),
            );
            BHCacheImageManager.shared().continueCacheIfNeed();
          }
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusSmall),
              child: CachedNetworkImage(
                imageUrl: topicDto.image,
                fit: BoxFit.cover,
                height: 300,
                width: Get.width / 1.5,
                placeholder: (context, url) => const ExploreShimmer(),
                cacheManager: BHCacheImageManager.shared().cacheManager,
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: ThemeDimen.paddingSmall),
                    AutoSizeText(
                      topicDto.name,
                      style:
                          ThemeUtils.getTitleStyle(color: Colors.white, fontSize: 16.toWidthRatio()),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    AutoSizeText(
                      topicDto.description,
                      style:
                          ThemeUtils.getTitleStyle(color: Colors.white, fontSize: 14.toWidthRatio()),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ThemeDimen.paddingSmall),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget boxVerify() => Container(
        //height: Get.height / 2.2,
        width: Get.width - 16,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Center(
                  child: SvgPicture.asset(
                AppImages.icVerifiedEnable,
                width: 60,
                height: 60,
              )),
            ),
            Padding(
              padding: EdgeInsets.only(top: ThemeDimen.paddingNormal),
              child: AutoSizeText(
                _getTitle(),
                style: ThemeUtils.getTitleStyle(
                    color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
              child: Center(
                child: AutoSizeText(
                  _getDescription(),
                  style: TextStyle(fontSize: 16, color: HexColor("323232")),
                  overflow: TextOverflow.clip,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
              child: DatingButton.darkButton(
                S.current.str_continue,
                true,
                () async {
                  if (step >= 1) {
                    final isGranted = await Permission.camera.status.isGranted;
                    setState(() {
                      showVerifyBox = false;
                    });
                    ;
                    if (isGranted) {
                      RouteService.routeGoOnePage(const LetYouVerified());
                    } else {
                      RouteService.routeGoOnePage(const EnableCamera());
                    }
                  } else {
                    setState(() {
                      step += 1;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: ThemeDimen.paddingBig),
              child: InkWell(
                onTap: () {
                  setState(() {
                    showVerifyBox = false;
                  });
                  ;
                },
                child: AutoSizeText(
                  S.current.may_be_later,
                  style: ThemeUtils.getPopupTitleStyle(
                      fontSize: 14.toWidthRatio(), color: HexColor("979798")),
                ),
              ),
            ),
            SizedBox(height: ThemeDimen.paddingBig),
          ],
        ),
      );

  String _getDescription() {
    switch (step) {
      case 0:
        return S.current.get_verified_notice;
      // case 1:
      //   return "You are almost there! If you quit now, you will start over from the beginning next time";
      case 1:
        return S.current.txt_verify_capture_complete_message;
      default:
        return "";
    }
  }

  String _getTitle() {
    switch (step) {
      case 0:
        return S.current.get_verified;
      // case 1:
      //   return "Are you sure want to quit verification?";
      case 1:
        return S.current.txt_how_it_work;
      default:
        return "";
    }
  }
}
