import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:dating_app/src/domain/dtos/profiles/avatar_dto.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/cupertino.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart' as blur;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class HLBlurHash extends StatelessWidget {
  HLBlurHash(
      {super.key,
      required this.imageModel,
      this.hash,
      this.fit = BoxFit.cover,
      this.errorMessage,
      this.errorIcon,
      this.errorIconColor,
      this.errorIconSize});

  AvatarDto imageModel;
  String? hash;
  BoxFit fit;
  Text? errorMessage;
  IconData? errorIcon;
  Color? errorIconColor;
  double? errorIconSize;

  final String _defaultHash = 'LEHV6nWB2yk8pyo0adR*.7kCMdnj';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        final data = snapshot.data;

        return data == null ? genImage(hash ?? _defaultHash) : genImage(data!);
      },
      future: getBlurHash(),
    );
  }

  Widget genImage(String imgHash) {
    return blur.BlurHash(
      hash: imgHash,
      imageFit: fit,
    );
  }

  Future<String?> getBlurHash() async {
    final key = imageModel.thumbnail.removeQuery;
    String value = HLBlurHashManager.shared.getHash(key);
    if (value.isNotEmpty) {
      return value;
    }
    var file = await DefaultCacheManager()
        .downloadFile(imageModel.thumbnail, key: key);
    final data = file.file.readAsBytesSync();
    final image = img.decodeImage(data);

    if (image == null) {
      return null;
    }

    final hash = BlurHash.encode(image, numCompX: 4, numCompY: 3).hash;
    await HLBlurHashManager.shared.addHash(key, hash);
    return hash;
  }
}

class HLBlurHashManager {
  static final HLBlurHashManager shared = HLBlurHashManager._internal();

  HLBlurHashManager._internal();

  Future<void> addHash(String key, String value) async {
    await PrefAssist.setString(key, value);
  }

  String getHash(String key) {
    return PrefAssist.getString(key, '');
  }
}
