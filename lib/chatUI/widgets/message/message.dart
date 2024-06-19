import 'package:dating_app/src/domain/dtos/chat/chat_message_dto/chat_message_dto.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../src/domain/dtos/customers/customers_dto.dart';
import '../../chat_type/preview_data.dart';
import '../../conditional/conditional.dart';
import '../../models/bubble_rtl_alignment.dart';
import '../../models/emoji_enlargement_behavior.dart';
import '../../util.dart';
import '../state/inherited_chat_theme.dart';
import '../state/inherited_user.dart';
import 'message_status.dart';
import 'text_message.dart';
import 'user_avatar.dart';

/// Base widget for all message types in the chat. Renders bubbles around
/// messages and status. Sets maximum width for a message for
/// a nice look on larger screens.
class MessageWG extends StatelessWidget {
  /// Creates a particular message from any message type.
  const MessageWG({
    super.key,
    this.avatarBuilder,
    this.bubbleBuilder,
    this.bubbleRtlAlignment,
    this.customStatusBuilder,
    required this.emojiEnlargementBehavior,
    required this.hideBackgroundOnEmojiMessages,
    this.imageHeaders,
    this.imageProviderBuilder,
    required this.message,
    required this.messageWidth,
    this.nameBuilder,
    this.onAvatarTap,
    this.onMessageDoubleTap,
    this.onMessageLongPress,
    this.onMessageStatusLongPress,
    this.onMessageStatusTap,
    this.onMessageTap,
    this.onMessageVisibilityChanged,
    this.onPreviewDataFetched,
    required this.roundBorder,
    required this.showAvatar,
    required this.showName,
    required this.showStatus,
    required this.showUserAvatars,
    this.textMessageBuilder,
    required this.usePreviewData,
    required this.author,
    this.userAgent,
    required this.lastMessageInGroup,
    required this.onlyMessageInGroup
  });

  /// This is to allow custom user avatar builder
  /// By using this we can fetch newest user info based on id.
  final Widget Function(String userId)? avatarBuilder;

  /// Customize the default bubble using this function. `child` is a content
  /// you should render inside your bubble, `message` is a current message
  /// (contains `author` inside) and `firstMessageInGroup` allows you to see
  /// if the message is a part of a group (messages are grouped when written
  /// in quick succession by the same author).
  final Widget Function(
    Widget child, {
    required MessageDto message,
    required bool firstMessageInGroup,
    required bool lastMessageInGroup,
    required bool onlyMessageInGroup,
  })? bubbleBuilder;

  /// Determine the alignment of the bubble for RTL languages. Has no effect
  /// for the LTR languages.
  final BubbleRtlAlignment? bubbleRtlAlignment;

  /// Build a custom status widgets.
  final Widget Function(MessageDto message, {required BuildContext context})?
      customStatusBuilder;

  /// Controls the enlargement behavior of the emojis in the
  /// [TextMessage].
  /// Defaults to [EmojiEnlargementBehavior.multi].
  final EmojiEnlargementBehavior emojiEnlargementBehavior;

  /// Hide background for messages containing only emojis.
  final bool hideBackgroundOnEmojiMessages;

  /// See [Chat.imageHeaders].
  final Map<String, String>? imageHeaders;

  /// See [Chat.imageProviderBuilder].
  final ImageProvider Function({
    required String uri,
    required Map<String, String>? imageHeaders,
    required Conditional conditional,
  })? imageProviderBuilder;

  /// Any message type.
  final MessageDto message;

  /// Any message type.
  final CustomerDto author;

  /// Maximum message width.
  final int messageWidth;

  /// See [TextMessage.nameBuilder].
  final Widget Function(CustomerDto)? nameBuilder;

  /// See [UserAvatar.onAvatarTap].
  final void Function(CustomerDto)? onAvatarTap;

  /// Called when user double taps on any message.
  final void Function(BuildContext context, MessageDto)? onMessageDoubleTap;

  /// Called when user makes a long press on any message.
  final void Function(BuildContext context, MessageDto)? onMessageLongPress;

  /// Called when user makes a long press on status icon in any message.
  final void Function(BuildContext context, MessageDto)?
      onMessageStatusLongPress;

  /// Called when user taps on status icon in any message.
  final void Function(BuildContext context, MessageDto)? onMessageStatusTap;

  /// Called when user taps on any message.
  final void Function(BuildContext context, MessageDto)? onMessageTap;

  /// Called when the message's visibility changes.
  final void Function(MessageDto, bool visible)? onMessageVisibilityChanged;

  /// See [TextMessage.onPreviewDataFetched].
  final void Function(String, PreviewData)? onPreviewDataFetched;

  /// Rounds border of the message to visually group messages together.
  final bool roundBorder;

  /// Show user avatar for the received message. Useful for a group chat.
  final bool showAvatar;

  /// See [TextMessage.showName].
  final bool showName;

  /// Show message's status.
  final bool showStatus;

  /// Show user avatars for received messages. Useful for a group chat.
  final bool showUserAvatars;

  /// Show user avatars for received messages. Useful for a group chat.
  final bool lastMessageInGroup;

  /// Show user avatars for received messages. Useful for a group chat.
  final bool onlyMessageInGroup;

  /// Build a text message inside predefined bubble.
  final Widget Function(
    MessageContent, {
    required int messageWidth,
    required bool showName,
  })? textMessageBuilder;

  /// See [TextMessage.usePreviewData].
  final bool usePreviewData;

  /// See [TextMessage.userAgent].
  final String? userAgent;

  Widget _avatarBuilder() {
    return showAvatar
        ? avatarBuilder?.call(message.senderId ?? '') ??
            UserAvatar(
              author: author,
              bubbleRtlAlignment: bubbleRtlAlignment,
              imageHeaders: imageHeaders,
              onAvatarTap: onAvatarTap,
            )
        : const SizedBox(width: 40);
  }

  Widget _bubbleBuilder(
    BuildContext context,
    BorderRadius borderRadius,
    bool currentUserIsAuthor,
    bool enlargeEmojis,
  ) =>
      bubbleBuilder != null
          ? bubbleBuilder!(_messageBuilder(),
              message: message,
              firstMessageInGroup: roundBorder,
              lastMessageInGroup: lastMessageInGroup,
              onlyMessageInGroup: onlyMessageInGroup)
          : enlargeEmojis && hideBackgroundOnEmojiMessages
              ? Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: _messageBuilder(),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: !currentUserIsAuthor
                        ? InheritedChatTheme.of(context).theme.secondaryColor
                        : InheritedChatTheme.of(context).theme.primaryColor,
                  ),
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: _messageBuilder(),
                  ),
                );

  Widget _messageBuilder() {
    return textMessageBuilder != null
        ? textMessageBuilder!(
            message.content,
            messageWidth: messageWidth,
            showName: showName,
          )
        : TextMessageWG(
            emojiEnlargementBehavior: emojiEnlargementBehavior,
            hideBackgroundOnEmojiMessages: hideBackgroundOnEmojiMessages,
            message: message,
            nameBuilder: nameBuilder,
            onPreviewDataFetched: onPreviewDataFetched,
            showName: showName,
            usePreviewData: usePreviewData,
            userAgent: userAgent,
            author: author,
          );
  }

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final user = InheritedUser.of(context).user;
    final currentUserIsAuthor = user.id == author.id;

    final messageBorderRadius =
        InheritedChatTheme.of(context).theme.messageBorderRadius;
    final borderRadius = bubbleRtlAlignment == BubbleRtlAlignment.left
        ? BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(
              !currentUserIsAuthor || roundBorder ? messageBorderRadius : 0,
            ),
            bottomStart: Radius.circular(
              currentUserIsAuthor || roundBorder ? messageBorderRadius : 0,
            ),
            topEnd: Radius.circular(messageBorderRadius),
            topStart: Radius.circular(messageBorderRadius),
          )
        : BorderRadius.only(
            bottomLeft: Radius.circular(
              currentUserIsAuthor || roundBorder ? messageBorderRadius : 0,
            ),
            bottomRight: Radius.circular(
              !currentUserIsAuthor || roundBorder ? messageBorderRadius : 0,
            ),
            topLeft: Radius.circular(messageBorderRadius),
            topRight: Radius.circular(messageBorderRadius),
          );

    return Container(
      alignment: bubbleRtlAlignment == BubbleRtlAlignment.left
          ? currentUserIsAuthor
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart
          : currentUserIsAuthor
              ? Alignment.centerRight
              : Alignment.centerLeft,
      margin: bubbleRtlAlignment == BubbleRtlAlignment.left
          ? EdgeInsetsDirectional.only(
              bottom: 4,
              end: isMobile ? query.padding.right : 0,
              start: 20 + (isMobile ? query.padding.left : 0),
            )
          : EdgeInsets.only(
              bottom: 4,
              left: 20 + (isMobile ? query.padding.left : 0),
              right: isMobile ? query.padding.right : 0,
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        textDirection: bubbleRtlAlignment == BubbleRtlAlignment.left
            ? null
            : TextDirection.ltr,
        children: [
          if (!currentUserIsAuthor && showUserAvatars) _avatarBuilder(),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: messageWidth.toDouble(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (showName)
                  currentUserIsAuthor
                      ? Row(
                          children: [
                            const Spacer(),
                            SizedBox(
                              width: messageWidth.toDouble() - 50,
                              height: 25,
                              child: Text(
                                "You",
                                textAlign: currentUserIsAuthor
                                    ? TextAlign.right
                                    : TextAlign.left,
                                maxLines: 1,
                                style: TextStyle(
                                  color: getUserAvatarNameColor(
                                      author.id, chatNameColors),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            )
                          ],
                        )
                      : Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: messageWidth.toDouble() - 50,
                              height: 25,
                              child: Text(
                                author.fullname ?? "",
                                textAlign: currentUserIsAuthor
                                    ? TextAlign.right
                                    : TextAlign.left,
                                maxLines: 1,
                                style: TextStyle(
                                  color: getUserAvatarNameColor(
                                      author.id, chatNameColors),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                GestureDetector(
                  onDoubleTap: () => onMessageDoubleTap?.call(context, message),
                  onLongPress: () {
                    onMessageLongPress?.call(context, message);
                  },
                  onTap: () => onMessageTap?.call(context, message),
                  child: onMessageVisibilityChanged != null
                      ? VisibilityDetector(
                          key: Key(message.id ?? message.content.text),
                          onVisibilityChanged: (visibilityInfo) =>
                              onMessageVisibilityChanged!(
                            message,
                            visibilityInfo.visibleFraction > 0.1,
                          ),
                          child: _bubbleBuilder(
                              context,
                              borderRadius.resolve(Directionality.of(context)),
                              currentUserIsAuthor,
                              true),
                        )
                      : _bubbleBuilder(
                          context,
                          borderRadius.resolve(Directionality.of(context)),
                          currentUserIsAuthor,
                          true),
                ),
                if (currentUserIsAuthor)
                  Padding(
                    padding:
                        InheritedChatTheme.of(context).theme.statusIconPadding,
                    child: showStatus
                        ? GestureDetector(
                            onLongPress: () => onMessageStatusLongPress?.call(
                                context, message),
                            onTap: () =>
                                onMessageStatusTap?.call(context, message),
                            child: customStatusBuilder != null
                                ? customStatusBuilder!(message,
                                    context: context)
                                : SizedBox(
                                    width: 79,
                                    height: 39,
                                    child: MessageStatus(
                                        status: message.getStatus()),
                                  ), //MessageStatus(status: message.getStatus()),
                          )
                        : null,
                  ),
              ],
            ),
          ),
          const SizedBox(
            width: 8,
          )
        ],
      ),
    );
  }
}
