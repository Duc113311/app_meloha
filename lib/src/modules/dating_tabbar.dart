import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/modules/chat/screens/messages/message_page.dart';
import 'package:dating_app/src/modules/explore/screens/explore/explore_page.dart';
import 'package:dating_app/src/modules/profile/screens/profile_page.dart';
import 'package:dating_app/src/requests/api_update_profile_setting.dart';
import 'package:dating_app/src/utils/change_notifiers/edit_profile_notifier.dart';
import 'package:dating_app/src/utils/remote_configs.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../general/constants/app_image.dart';
import '../utils/change_notifiers/tabbar_item_notifier.dart';
import '../utils/notification_manager.dart';
import '../utils/pref_assist.dart';
import '../utils/socket_manager.dart';
import 'home/screens/home/HingeHomePage.dart';
import 'login/location/request_location.dart';

class DatingTabbar extends StatefulWidget {
  const DatingTabbar({Key? key}) : super(key: key);

  @override
  State<DatingTabbar> createState() => _DatingTabbarState();
}

class _DatingTabbarState extends State<DatingTabbar>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  TabbarItems selectedItem = TabbarItems.home;
  bool hasPermission = false;
  bool canPop = false;
  DateTime currentBackPressTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    _requestLocation();

    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(
        initialIndex: selectedItem.index,
        length: TabbarItems.values.length,
        vsync: this);

    _tabController.addListener(() {
      setState(() {
        selectedItem = TabbarItem.init(_tabController.index);
      });
      TabbarItemNotifier.shared.updateIndex(_tabController.index);
    });

    EditProfileNotifier.shared.addListener( () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) async {
    super.didChangeLocales(locales);
    await StaticInfoManager.shared().loadData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("AppLifecycleState $state");
    switch (state) {
      case AppLifecycleState.resumed:
        _requestLocation();
        SocketManager.shared().reConnect();
        LocalNotificationManager.shared().requestPermission();
        RemoteConfigsManager.loadConfigs();
        break;
      case AppLifecycleState.inactive:
        imageCache.clear();
        break;
      case AppLifecycleState.paused:
        imageCache.clear();
        break;
      case AppLifecycleState.detached:
        imageCache.clear();
        SocketManager.shared().closeSocket();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: onWillPop,
      canPop: canPop,
      child: hasPermission
          ? mainView()
          : RequestLocation(requestedCallback: _requestedHandle),
    );
  }

  Future<void> _requestLocation() async {
    if (await Permission.location.isGranted ||
        PrefAssist.getMyCustomer().location != null) {
      _requestedHandle(true);
    } else {
      _requestedHandle(false);
    }
  }

  Future<void> _requestedHandle(bool isGranted) async {
    if (mounted) {
      setState(() {
        hasPermission = isGranted;
      });
    }
  }

  Widget mainView() {
    return Scaffold(
      body: Column(
        children: [
          // if (tabIndex == 0) _renderAppBar(context),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const ClampingScrollPhysics(),
              children: const [
                HingeHomePage(),
                ExplorePage(),
                MessagePage(),
                ProfilePage(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _menu(),
    );
  }

  Widget _menu() {
    const iconSize = 32.0;
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).dividerColor,
          border: Border(
              top:
                  BorderSide(color: Theme.of(context).dividerColor, width: 1))),
      child: BottomNavigationBar(
        backgroundColor: ThemeUtils.getTabbarBackgroundColor(),
        onTap: (value) async {
          setState(() {
            selectedItem = TabbarItem.init(value);
          });
          _tabController.animateTo(selectedItem.index,
              duration:
                  const Duration(milliseconds: ThemeDimen.animMillisDuration),
              curve: Curves.easeIn);

          if (selectedItem == TabbarItems.profile) {
            await ApiProfileSetting.getProfile(force: true);
          }
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              selectedItem == TabbarItems.home
                  ? AppImages.icHomeTabSelected
                  : AppImages.icHomeTab,
              height: iconSize,
              width: iconSize,
              allowDrawingOutsideViewBox: true,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              selectedItem == TabbarItems.search
                  ? AppImages.icExploreTabSelected
                  : AppImages.icExploreTab,
              height: iconSize,
              width: iconSize,
              allowDrawingOutsideViewBox: true,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              selectedItem == TabbarItems.chat
                  ? AppImages.icMessageTabSelected
                  : AppImages.icMessageTab,
              height: iconSize,
              width: iconSize,
              allowDrawingOutsideViewBox: true,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: selectedItem == TabbarItems.profile
                  ? ThemeUtils.getPrimaryColor()
                  : AppColors.color323232,
              radius: iconSize / 2,
              child: CachedNetworkImage(
                imageUrl: PrefAssist.getMyCustomer().getAvatarUrl,
                errorWidget: (context, url, error) => const SizedBox(),
                placeholder: (context, imageProvider) =>
                    SvgPicture.asset(AppImages.icProfileTab),
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: (iconSize - 3) / 2,
                  backgroundImage: imageProvider,
                ),
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }

  void onWillPop(bool didPop) {
    debugPrint("didPop: $didPop");

    if (selectedItem != TabbarItems.home) {
      _tabController.animateTo(0,
          duration: const Duration(milliseconds: ThemeDimen.animMillisDuration),
          curve: Curves.easeIn);
    } else {
      DateTime now = DateTime.now();
      if (now.difference(currentBackPressTime) > const Duration(seconds: 5)) {
        currentBackPressTime = now;
        Fluttertoast.cancel();
        Fluttertoast.showToast(msg: S.current.tap_back_again_to_leave);
      } else {
        Fluttertoast.cancel();
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      }
    }
  }
}

enum TabbarItems { home, search, chat, profile }

extension TabbarItem on TabbarItems {
  int get index {
    switch (this) {
      case TabbarItems.home:
        return 0;
      case TabbarItems.search:
        return 1;
      case TabbarItems.chat:
        return 2;
      case TabbarItems.profile:
        return 3;
    }
  }

  static TabbarItems init(int index) {
    switch (index) {
      case 0:
        return TabbarItems.home;
      case 1:
        return TabbarItems.search;
      case 2:
        return TabbarItems.chat;
      case 3:
        return TabbarItems.profile;
      default:
        return TabbarItems.home;
    }
  }
}
