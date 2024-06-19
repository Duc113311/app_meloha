import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/components/widgets/dialogs/dating_gold_dialog.dart';
import 'package:dating_app/src/data/object_request_api/likes_and_for_you/likes_request.dart';
import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/domain/dtos/like_and_top_pick/customers_like_top_dto.dart';
import 'package:dating_app/src/domain/dtos/static_info/static_info.dart';
import 'package:dating_app/src/domain/repositories/like_and_for_you/like_an_for_you_repo.dart';
import 'package:dating_app/src/general/inject_dependencies/inject_dependencies.dart';
import 'package:dating_app/src/modules/home/screens/components/screens/view_customer_page.dart';
import 'package:dating_app/src/modules/likes_and_tops_pick/screens/like/filter_like.dart';
import 'package:dating_app/src/modules/subviews/blur_image_view.dart';
import 'package:dating_app/src/utils/cache_image_manager.dart';
import 'package:dating_app/src/utils/change_notifiers/premium_notifier.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dating_app/src/utils/filter_manager.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../domain/services/navigator/route_service.dart';
import '../../../../general/constants/app_image.dart';

class LikePage extends StatefulWidget {
  LikePage({super.key, required this.showTitle});

  bool showTitle;

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage>
    with AutomaticKeepAliveClientMixin {
  List<CustomersLikeTopDto> listOtherLikeU = [];
  List<StaticInfoDto> _topInterests = [];
  List<StaticInfoDto> listInterest = StaticInfoManager.shared().interests;
  bool isFilter = false;
  bool isLoading = true;
  List<CustomersLikeTopDto> listFilter = [];

  LikesRequest likesRequest = LikesRequest(10, 0, 'like');
  LikeAndForYouRepo _likeAndForYouRepo = getIt<LikeAndForYouRepo>();

  @override
  void initState() {
    if (PremiumNotifier.shared.isPremium) {
      likesRequest = LikesRequest(-1, 0, 'like');
    }
    super.initState();
    if (listInterest.length > 5) {
      _topInterests = listInterest.sublist(0, 5);
    }
    _loadData();
  }

  Future<void> _loadData() async {
    _likeAndForYouRepo.getLikes(likesRequest).then(
          (value) => value.fold(
            (left) {
              setState(() {
                isLoading = false;
                listOtherLikeU = [];
              });
            },
            (right) {
              setState(() {
                isLoading = false;
                listOtherLikeU = right.listData ?? [];
              });
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.showTitle
            ? AppBar(
                leading: IconButton(
                  onPressed: () {
                    FilterLikeManager.shared.resetFilter();
                    RouteService.pop();
                  },
                  icon: SvgPicture.asset(
                    AppImages.icArrowBack,
                    colorFilter: ColorFilter.mode(
                        ThemeUtils.getTextColor(), BlendMode.srcIn),
                  ),
                ),
                title: Text(
                  S.current.txtid_likes,
                  style: ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio()),
                ),
                surfaceTintColor: Colors.transparent,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
                  statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
                      ? Brightness.light
                      : Brightness.dark,
                ),
              )
            : null,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : listOtherLikeU.isEmpty
                ? _emptyListLikeWidget()
                : _buildListLikeWidget(),
        bottomNavigationBar:
            listOtherLikeU.isEmpty ? const SizedBox() : seeMore());
  }

  Widget _buildListLikeWidget() {
    return Stack(
      children: [
        NotificationListener<OverscrollNotification>(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!PremiumNotifier.shared.isPremium)
                  Padding(
                    padding: EdgeInsets.all(ThemeDimen.paddingNormal),
                    child: Text(
                      S.current.like_upgrade_gold_notice,
                      style: ThemeUtils.getTextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(
                  height: 8,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (isFilter) {
                            FilterLikeManager.shared.resetFilter();
                            setState(() {
                              isFilter = false;
                            });
                          } else {
                            showFilter();
                          }
                        },
                        icon: SvgPicture.asset(
                          AppImages.ic_filter_like,
                          width: 25.toWidthRatio(),
                          height: 25.toWidthRatio(),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              isFilter
                                  ? ThemeUtils.getPrimaryColor()
                                  : ThemeUtils.getTextColor(),
                              BlendMode.srcIn),
                        ),
                      ),
                      Wrap(
                        children: [
                          ...List.generate(
                              _topInterests.length,
                              (index) =>
                                  _getInterestWidgets(_topInterests[index])),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isFilter && listFilter.isEmpty)
                  Column(
                    children: [
                      const SizedBox(
                        height: 32,
                      ),
                      SvgPicture.asset(
                        AppImages.ic_heart_like_page,
                        height: 36.toWidthRatio(),
                        width: 36.toWidthRatio(),
                        allowDrawingOutsideViewBox: true,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ThemeDimen.paddingSuper,
                        ),
                        child: Text(
                          S.current.txt_no_users_filter,
                          style: ThemeUtils.getTextStyle(),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                if (!isFilter || listFilter.isNotEmpty)
                  GridView.count(
                      padding: const EdgeInsets.all(16),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: List.generate(
                          isFilter ? listFilter.length : listOtherLikeU.length,
                          (index) {
                        final item =
                            isFilter ? listFilter[index] : listOtherLikeU[index];
                        return GestureDetector(
                          onTap: () async {
                            if (!PremiumNotifier.shared.isPremium) {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      const DatingGoldDialogPackage());
                              return;
                            }
                            precacheImage(
                                CachedNetworkImageProvider(item.getAvatar,
                                    cacheKey: item.getAvatarCacheKeyId,
                                    cacheManager: BHCacheImageManager.shared()
                                        .cacheManager),
                                context);
                            final deleteCustomer = await RouteService.routeGoOnePage(
                                ViewCustomerPage(customerDto: item.toCustomer()));
                            if (deleteCustomer != null && deleteCustomer is CustomerDto) {
                              setState(() {
                                listFilter.removeWhere((element) => element.id == deleteCustomer.id);
                                listOtherLikeU.removeWhere((element) => element.id == deleteCustomer.id);
                              });
                            }
                          },
                          child: SizedBox(
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      ThemeDimen.borderRadiusSmall),
                                  child: item.getAvatarModel == null
                                      ? const SizedBox()
                                      : BlurImageView(
                                    key: Key(item.id),
                                          imageModel: item.getAvatarModel!,
                                        ),
                                ),
                                item.onlineNow ?? false
                                    ? Column(
                                        children: [
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, bottom: 8),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(ThemeDimen
                                                            .borderRadiusSmall)),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width:
                                                        ThemeDimen.paddingSmall),
                                                Text(
                                                  S.current.recently_active,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        );
                      })),
              ],
            ),

          ),
          onNotification: (scrollInfo) {
            if (PremiumNotifier.shared.isPremium) {
              return false;
            }
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                  const DatingGoldDialogPackage());
            }
            return false;
          },
        ),
      ],
    );
  }

  void showFilter({String? selectedCode}) {
    showModalBottomSheet(
      context: context,
      builder: (b) {
        return FilterLikePage(
          callback: (models) {
            setState(() {
              isFilter = true;
              listFilter = models;
            });
          },
          selectedCode: selectedCode,
        );
      },
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void filterUsers(List<CustomersLikeTopDto> users) {}

  bool checkSelected(StaticInfoDto interest) {
    final filter = FilterLikeManager.shared.getFilter();
    if (filter.interests.contains(interest.code)) {
      return true;
    }
    return false;
  }

  Widget _getInterestWidgets(StaticInfoDto interest) {
    return GestureDetector(
      onTap: () {
        showFilter(selectedCode: interest.code);
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: checkSelected(interest)
                    ? ThemeUtils.getPrimaryColor()
                    : ThemeUtils.borderColor),
            borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal),
          ),
          padding: EdgeInsets.all(ThemeDimen.paddingSmall),
          child: Text(
            interest.value,
            style: ThemeUtils.getTextStyle(),
          ),
        ),
      ),
    );
  }

  Widget _emptyListLikeWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.all(ThemeDimen.paddingNormal),
          child: PremiumNotifier.shared.isPremium
              ? const SizedBox()
              : Text(
                  S.current.like_upgrade_gold_notice,
                  style: ThemeUtils.getTextStyle(),
                  textAlign: TextAlign.center,
                ),
        ),
        Column(
          children: [
            SvgPicture.asset(
              AppImages.ic_heart_like_page,
              height: 36.toWidthRatio(),
              width: 36.toWidthRatio(),
              allowDrawingOutsideViewBox: true,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ThemeDimen.paddingSuper,
              ),
              child: Text(
                S.current.no_one_like_you_notice,
                style: ThemeUtils.getTextStyle(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                maxLines: 3,
              ),
            ),
          ],
        ),
        SizedBox(height: ThemeDimen.paddingSuper),
      ],
    );
  }

  Widget seeMore() {
    return PremiumNotifier.shared.isPremium
        ? const SizedBox()
        : Padding(
            padding: EdgeInsets.fromLTRB(
                ThemeDimen.paddingSuper,
                ThemeDimen.paddingSmall,
                ThemeDimen.paddingSuper,
                ThemeDimen.paddingLarge),
            child: WidgetGenerator.bottomButton(
              selected: true,
              buttonHeight: ThemeDimen.buttonHeightNormal,
              buttonWidth: double.infinity,
              onClick: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) =>
                    const DatingGoldDialogPackage());
              },
              child: SizedBox(
                height: ThemeDimen.buttonHeightNormal,
                child: Center(
                  child: Text(
                    S.current.see_who_like_you.toCapitalized,
                    style: ThemeUtils.getButtonStyle(),
                  ),
                ),
              ),
            ),
          );
  }

  // Private functions
  Future<void> filterCallBackFunction() async {
    RouteService.pop();
  }

  Future<void> onSeeWhoLikeYou() async {}

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
