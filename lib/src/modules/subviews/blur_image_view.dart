import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/src/domain/dtos/profiles/avatar_dto.dart';
import 'package:dating_app/src/modules/subviews/blur_hash_view.dart';
import 'package:dating_app/src/utils/cache_image_manager.dart';
import 'package:dating_app/src/utils/change_notifiers/premium_notifier.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:flutter/material.dart';
import '../../general/constants/app_image.dart';

class BlurImageView extends StatefulWidget {
  BlurImageView({super.key, required this.imageModel});

  AvatarDto imageModel;

  @override
  State<BlurImageView> createState() => _BlurImageViewState(imageModel: imageModel);
}

class _BlurImageViewState extends State<BlurImageView> {
  _BlurImageViewState({required this.imageModel});

  AvatarDto imageModel;

  @override
  void initState() {
    super.initState();

    //_loadData();
  }

  @override
  Widget build(BuildContext context) {
    return imageModel == null
        ? Image.asset(
            AppImages.bgBlurImage,
            fit: BoxFit.fill,
          )
        : PremiumNotifier.shared.isPremium
            ? CachedNetworkImage(
                cacheKey: imageModel.url!.removeQuery,
                imageUrl: imageModel.url!,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, e, i) => const SizedBox(),
                cacheManager: BHCacheImageManager.shared().cacheManager,
              )
            : HLBlurHash(imageModel: imageModel);
    // : Stack(children: [
    //     Image.asset(
    //       AppImages.bgBlurImage,
    //       fit: BoxFit.fill,
    //     ),
    //     Container(
    //       decoration: BoxDecoration(
    //         image: DecorationImage(
    //             image: CachedNetworkImageProvider(
    //               imageURL!,
    //               cacheKey: imageURL!.split("?").firstOrNull ?? 'id',
    //               cacheManager: BHCacheImageManager.shared().cacheManager,
    //             ),
    //             fit: BoxFit.cover),
    //       ),
    //       child: ClipRRect(
    //         child: BackdropFilter(
    //           filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 12.0),
    //           child: Container(
    //             decoration: BoxDecoration(
    //                 color: Colors.white.withOpacity(0.39)),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ]);
  }
}
