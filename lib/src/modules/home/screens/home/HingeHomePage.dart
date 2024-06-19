import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/modules/home/screens/components/screens/hinge_home.dart';
import 'package:dating_app/src/modules/subviews/upgrade_button.dart';
import 'package:dating_app/src/utils/change_notifiers/premium_notifier.dart';
import 'package:dating_app/src/utils/change_notifiers/setting_notifier.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../../../../generated/l10n.dart';
import '../../../../domain/dtos/customers/customers_dto.dart';
import '../../../../utils/card_manager.dart';
import '../../../../utils/theme_notifier.dart';
import '../components/widget/loading_animation.dart';

class HingeHomePage extends StatefulWidget {
  const HingeHomePage({super.key});

  @override
  State<HingeHomePage> createState() => _HingeHomePageState();
}

class _HingeHomePageState extends State<HingeHomePage>
    with AutomaticKeepAliveClientMixin {
  List<CustomerDto> cardCustomers = [];
  bool isEndUser = false;
  bool showSetting = false;
  bool isActive = false;
  bool isLoading = false;
  int currentIndex = 0;

  Timer? precacheTimer;

  void loadCardListener() {
    if (mounted) {
      loadCards(true, loadMore: false);
    }
  }

  void premiumListener() {
    if(mounted) {
      setState(() {});
      debugPrint(PremiumNotifier.shared.isPremium.toString());
    }
  }

  void themeListener() {
    if (mounted) {
      setState(() {});
    }
  }
  @override
  void initState() {
    super.initState();
    ThemeNotifier.themeModeRef.addListener(themeListener);
    SettingNotifier.shared.addListener(loadCardListener);
    PremiumNotifier.shared.addListener(premiumListener);

    loadCards(true);
  }


  @override
  void dispose() {
    ThemeNotifier.themeModeRef.removeListener(themeListener);
    SettingNotifier.shared.removeListener(loadCardListener);
    PremiumNotifier.shared.removeListener(premiumListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
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
      body: isLoading || cardCustomers.isEmpty
          ? LoadingAnimation(
              isChangeSetting: showSetting,
            )
          : HingeHome(
              key: Key(cardCustomers.firstOrNull?.id ?? "hingeHome"),
              cardCustomers: cardCustomers,
              onEndArray: onEndArray,
              onChanged: (index) {
                currentIndex = index;
              },
            ),
    );
  }

  Future<void> onEndArray(List<CustomerDto> customers, int index) async {
    debugPrint("load more data: ${cardCustomers.length}");
    if (customers.length - index == 0) {
      setState(() {
        showSetting = true;
      });
    }
    final animation = cardCustomers.length < 10;
    cardCustomers = customers;
    loadCards(animation);
  }

  Future<void> loadCards(bool showLoading, {bool loadMore = true}) async {
    if (isLoading) {
      return;
    }
    if (showLoading) {
      setState(() {
        isLoading = true;
      });
    }

    final cards = await CardManager.shared().getCards(loadMore);
    if (cardCustomers.isEmpty && cards.length > 2) {
      if (mounted) {
        final model = cards[0];
        // BHCacheImageManager.shared()
        //     .addCache(model.getAvatarUrl, model.getAvatarCacheKeyId);

        await DefaultCacheManager()
            .downloadFile(model.getAvatarUrl,
                key: model.getAvatarUrl.removeQuery)
            .then((value) {
          setState(() {
            showSetting = false;
            cardCustomers = cards;
            isLoading = false;
          });
        }).onError((error, stackTrace) {
          setState(() {
            showSetting = false;
            cardCustomers = cards;
            isLoading = false;
          });
        });
      } else {
        setState(() {});
      }
    } else {
      if (mounted) {
        setState(() {
          showSetting = cards.isEmpty;
          cardCustomers = cards;
          isLoading = false;
        });
      } else {
        setState(() {});
      }
    }

    //Precache
    // BHCacheImageManager.shared().preCache(cards);
    // debugPrint("card updated: ${cardCustomers.length}");
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
