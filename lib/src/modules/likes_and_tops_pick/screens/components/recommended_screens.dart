import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/src/data/object_request_api/likes_and_for_you/likes_request.dart';
import 'package:dating_app/src/domain/repositories/like_and_for_you/like_an_for_you_repo.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/general/constants/app_constants.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/general/inject_dependencies/inject_dependencies.dart';
import 'package:dating_app/src/modules/home/screens/components/screens/view_customer_page.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../domain/dtos/like_and_top_pick/customers_like_top_dto.dart';
import '../../../../domain/services/navigator/route_service.dart';
import '../../../../utils/cache_image_manager.dart';

class RecommendedScreens extends StatefulWidget {
  const RecommendedScreens({super.key});

  @override
  State<RecommendedScreens> createState() => _RecommendedScreensState();
}

class _RecommendedScreensState extends State<RecommendedScreens> {
  List<CustomersLikeTopDto> children = [];

  LikeAndForYouRepo likeAndForYouRepo = getIt<LikeAndForYouRepo>();
  LikesRequest likesRequest = LikesRequest(-1, 0, 'like');
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    likeAndForYouRepo
        .getForYou(likesRequest)
        .then((value) => value.fold((left) {
              setState(() {
                isLoading = false;
                children = [];
              });
            }, (right) {
              setState(() {
                isLoading = false;
                children = right.listData ?? [];
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
        leading: IconButton(
          onPressed: () => RouteService.pop(),
          icon: SvgPicture.asset(
            AppImages.icArrowBack,
            colorFilter:
                ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),
          ),
        ),
        title: AutoSizeText(S.current.txtid_recommended,
            style: ThemeUtils.getTitleStyle()),
      ),
      body: SingleChildScrollView(
          child: isLoading
              ? load()
              : children.isEmpty
                  ? empty()
                  : Column(
                      children: [
                        sizeBox(),
                        hasData(children),
                        sizeBox(),
                      ],
                    )),
    );
  }

  Widget empty() => SizedBox(
        height: 800,
        child: Center(
            child: AutoSizeText(S.current.txtid_there_are_currently_no_likes)),
      );

  Widget sizeBox() => const SizedBox(
        height: 10,
      );

  Widget load() => Column(
        children: [
          sizeBox(),
          shimmer(),
          sizeBox(),
        ],
      );

  Widget shimmer() => GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1,
      crossAxisSpacing: 3,
      children: List.generate(
        2,
        (index) => Shimmer.fromColors(
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
            )),
      ));

  Widget hasData(List<CustomersLikeTopDto> list) => GridView.count(
        padding: EdgeInsets.all(
          ThemeDimen.paddingSmall / 667 * AppConstants.height,
        ),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 3,
        children: List.generate(
          list.length,
          (index) {
            var data = list[index];
            return GestureDetector(
              onTap: () {
                // show user detail
                RouteService.routeGoOnePage(ViewCustomerPage(
                  customerDto: data.toCustomer(),
                  isFriend: true,
                ));
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(ThemeDimen.borderRadiusNormal),
                      child: CachedNetworkImage(
                        cacheKey: data.getCacheKeyThumbnailMaxSize,
                        imageUrl: data.getThumbnailMaxSize,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, e, i) => const SizedBox(),
                        cacheManager: BHCacheImageManager.shared().cacheManager,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            ThemeUtils.getTextColor().withOpacity(0.7)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          tileMode: TileMode.clamp,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(ThemeDimen.borderRadiusNormal),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: EdgeInsets.all(ThemeDimen.paddingSmall),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AutoSizeText(
                            data.fullName!,
                            style: ThemeUtils.getTextStyle()
                                .copyWith(color: Colors.white),
                          ),
                          data.onlineNow ?? false
                              ? Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        // Utils.isConsiderOnline(likeUser.listData![index].online!) ? Colors.green : Colors.grey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                ThemeDimen.borderRadiusSmall)),
                                      ),
                                    ),
                                    SizedBox(width: ThemeDimen.paddingSmall),
                                    Text(
                                      S.current.recently_active,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      );
}
