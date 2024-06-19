import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/cache_image_manager.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dating_app/src/utils/theme_notifier.dart';
import 'package:flutter/material.dart';

import '../../models/bubble_rtl_alignment.dart';
import '../../util.dart';
import '../state/inherited_chat_theme.dart';

/// Renders user's avatar or initials next to a message.
class UserAvatar extends StatelessWidget {
  /// Creates user avatar.
  const UserAvatar({
    super.key,
    required this.author,
    this.bubbleRtlAlignment,
    this.imageHeaders,
    this.onAvatarTap,
  });

  /// Author to show image and name initials from.
  final CustomerDto author;

  /// See [Message.bubbleRtlAlignment].
  final BubbleRtlAlignment? bubbleRtlAlignment;

  /// See [Chat.imageHeaders].
  final Map<String, String>? imageHeaders;

  /// Called when user taps on an avatar.
  final void Function(CustomerDto)? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final color = getUserAvatarNameColor(
      author.id,
      InheritedChatTheme.of(context).theme.userAvatarNameColors,
    );
    final hasImage = author.profiles?.avatars?.isNotEmpty ?? false;
    final initials = getUserInitials(author);

    return Container(
      margin: bubbleRtlAlignment == BubbleRtlAlignment.left
          ? const EdgeInsetsDirectional.only(end: 8)
          : const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => onAvatarTap?.call(author),
        child: CircleAvatar(
          backgroundColor: hasImage
              ? InheritedChatTheme.of(context)
                  .theme
                  .userAvatarImageBackgroundColor
              : color,
          backgroundImage: hasImage
              ? CachedNetworkImageProvider(author.getThumbnailAvatarUrl,
                  cacheKey: author.getThumbnailAvatarUrl.removeQuery, cacheManager: BHCacheImageManager.shared().cacheManager, headers: imageHeaders)
              : null,
          radius: 16,
          child: !hasImage
              ? ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ThemeUtils.borderColor,
                      ),
                      child: Center(
                        child: SvgPicture.asset(AppImages.icDeletedAccount,
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                ThemeUtils.getTextColor(), BlendMode.srcIn)),
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
