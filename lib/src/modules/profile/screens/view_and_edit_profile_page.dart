import 'dart:async';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/profile/screens/edit_profile_page.dart';
import 'package:dating_app/src/modules/profile/screens/view_profile/view_my_profile.dart';
import 'package:dating_app/src/utils/cache_image_manager.dart';
import 'package:dating_app/src/utils/change_notifiers/edit_profile_notifier.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notification_center/notification_center.dart';
import '../../../domain/services/navigator/route_service.dart';
import '../../../general/constants/app_color.dart';
import '../../../requests/api_update_profile_setting.dart';
import '../../subviews/back_button.dart';

class ViewEditProfilePage extends StatefulWidget {
  ViewEditProfilePage({super.key, required this.tabIndex});

  int tabIndex;

  @override
  State<ViewEditProfilePage> createState() => _ViewEditProfilePageState();
}

class _ViewEditProfilePageState extends State<ViewEditProfilePage>
    with
        WidgetsBindingObserver,
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();

    if (widget.tabIndex != 0) {
      Timer(const Duration(milliseconds: 500), () {
        _tabController.animateTo(widget.tabIndex);
      });
    }
  }

  @override
  void didChangeLocales(List<Locale>? locales) async {
    super.didChangeLocales(locales);
    Utils.showLoading();
    PrefAssist.setBool(PrefConst.kIsChangedLocale, true);
    await StaticInfoManager.shared().loadData();
    PrefAssist.setBool(PrefConst.kIsChangedLocale, false);
    Utils.hideLoading();
    setState(() {});
  }

  Future goBack({bool canPop = true}) async {
    BHCacheImageManager.shared().continueCacheIfNeed();
    await updateProfile();

    if (canPop) {
      RouteService.pop();
    }
  }

  Future<bool> isChangedLocale() async {
    return PrefAssist.getBool(PrefConst.kIsChangedLocale);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (canPop) {
        goBack(canPop: false);
      },
      canPop: true,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              surfaceTintColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
                statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
                    ? Brightness.light
                    : Brightness.dark,
              ),
              toolbarHeight: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      HLBackButton(
                        onPressed: () {
                          goBack();
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: Get.width - 120,
                        ),
                        child: Text(
                          PrefAssist.getMyCustomer().fullname,
                          maxLines: 1,
                          style: ThemeUtils.getTitleStyle(fontSize: 18)
                              .copyWith(overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Stack(
                          children: [
                            Center(
                                child: CircularProgressIndicator(
                              color: AppColors.progressColor,
                              backgroundColor:
                                  AppColors.progressColor.withOpacity(0.2),
                              value: PrefAssist.getMyCustomer()
                                      .getPercentCompleted /
                                  100,
                            )),
                            Center(
                              child: Text(
                                "${PrefAssist.getMyCustomer().getPercentCompleted.toString()}%",
                                style: const TextStyle(
                                    fontSize: 8,
                                    color: AppColors.progressColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TabBar(
                    controller: _tabController,
                    labelColor: ThemeUtils.getTextColor(),
                    unselectedLabelColor:
                        ThemeUtils.getTextColor().withOpacity(0.5),
                    tabs: [
                      // first tab [you can add an icon using the icon property]
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppImages.icEdit,
                              colorFilter: ColorFilter.mode(
                                  ThemeUtils.getTextColor(), BlendMode.srcIn),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              S.current.edit_profile,
                              style: TextStyle(
                                  color: ThemeUtils.getTextColor(),
                                  fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppImages.icView,
                              colorFilter: ColorFilter.mode(
                                  ThemeUtils.getTextColor(), BlendMode.srcIn),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              S.current.view_profile,
                              style: TextStyle(
                                  color: ThemeUtils.getTextColor(),
                                  fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        EditProfilePage(showLoading: widget.tabIndex != 0,
                        ),
                        const ViewMyProfile(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateProfile() async {
    Utils.showLoading();
    final code = await ApiProfileSetting.updateMyCustomerProfile();
    debugPrint("update profile : $code");
    Utils.hideLoading();
  }

  @override
  bool get wantKeepAlive => true;
}
