import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class BHCacheImageManager {
  static final BHCacheImageManager _shared = BHCacheImageManager._internal();

  BHCacheImageManager._internal();

  static BHCacheImageManager shared() => _shared;

  //Variables
  static const _key = 'BHCustomCacheKey';
  final Set<String> _cacheKeys = {};

  Timer? _precacheTimer;
  bool _isPaused = false;
  List<CustomerDto> _cacheCards = [];

  final cacheManager = CacheManager(
    Config(
      _key,
      stalePeriod: const Duration(days: 1),
      maxNrOfCacheObjects: 500,
    ),
  );

  //Functions
  void addCache(String url, String key, {BuildContext? context}) async {
    if ( hasKey(key)) {
      debugPrint("BH Cache key has saved!");
      return;
    }
    //debugPrint("BH Cache add new key");
    _cacheKeys.add(key);
    await precacheImage(CachedNetworkImageProvider(url, cacheKey: key, cacheManager: cacheManager), context ?? Get.context!);
    //debugPrint("BH Cache add new key");
  }

  void removeKey(String key) {
    _cacheKeys.remove(key);
  }

  bool hasKey(String key) {
    return _cacheKeys.contains(key);
  }

  void preCache(List<CustomerDto> cards) {
    _cacheCards = [...cards];
    _precacheTimer?.cancel();
    _precacheTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_cacheCards.isEmpty) {
        _precacheTimer?.cancel();
        return;
      }
      final model = _cacheCards.first;
      addCache(
          model.getAvatarUrl,
          model.getAvatarCacheKeyId);

      _cacheCards.removeAt(0);
    });
  }

  void pauseCache() {
    _precacheTimer?.cancel();
    _isPaused = true;
    debugPrint("pause cache");
  }

  void continueCacheIfNeed() {
    if (_cacheCards.isNotEmpty && _isPaused) {
      _isPaused = false;
      preCache([..._cacheCards]);
      debugPrint("Continue cache");
    }
  }

  // Future<void> addCache(String url, BuildContext context) async {
  //   if (url.isEmpty || _cacheKeys.contains(url)) {
  //     return;
  //   }
  //   _cacheKeys.add(url);
  //   await precacheImage(CachedNetworkImageProvider(url), context);
  //   _autoRemoveCaches();
  //   debugPrint('add url to cache. Current cache length: ${_cacheKeys.length}');
  // }
  //
  // Future<void> addCaches(List<String> urls, BuildContext context) async {
  //   for (String url in urls) {
  //     await addCache(url, context);
  //   }
  // }
  //
  // Future<void> removeCache(String url) async {
  //   final removed = imageCache.evict(url);
  //   if (removed) {
  //     _cacheKeys.removeWhere((element) => element == url);
  //   }
  //   debugPrint('clear cache complete with status: $removed');
  // }
  //
  // Future<void> removeCaches(List<String> urls) async {
  //   for (String url in urls) {
  //     await removeCache(url);
  //   }
  // }
  //
  // Future<void> _autoRemoveCaches() async {
  //   if (_cacheKeys.length > 50) {
  //     final removing = _cacheKeys.getRange(0, 30).toList();
  //     removeCaches(removing);
  //   }
  // }
}
