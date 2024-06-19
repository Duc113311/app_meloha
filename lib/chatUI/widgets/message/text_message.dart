import 'package:dating_app/src/domain/dtos/chat/chat_message_dto/chat_message_dto.dart';
import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../chat_type/preview_data.dart';
import '../../link_review/utils.dart';
import '../../link_review/widgets/link_preview.dart';
import '../../models/emoji_enlargement_behavior.dart';
import '../../models/pattern_style.dart';
import '../../util.dart';
import '../state/inherited_chat_theme.dart';
import '../state/inherited_user.dart';

/// A class that represents text message widget with optional link preview.
class TextMessageWG extends StatelessWidget {
  /// Creates a text message widget from a [TextMessage] class.
  const TextMessageWG({
    super.key,
    required this.emojiEnlargementBehavior,
    required this.hideBackgroundOnEmojiMessages,
    required this.message,
    required this.author,
    this.nameBuilder,
    this.onPreviewDataFetched,
    this.options = const TextMessageOptions(),
    required this.showName,
    required this.usePreviewData,
    this.userAgent,
  });

  /// See [Message.emojiEnlargementBehavior].
  final EmojiEnlargementBehavior emojiEnlargementBehavior;

  /// See [Message.hideBackgroundOnEmojiMessages].
  final bool hideBackgroundOnEmojiMessages;

  /// [TextMessage].
  final MessageDto message;

  /// [TextMessage].
  final CustomerDto author;

  /// This is to allow custom user name builder
  /// By using this we can fetch newest user info based on id.
  final Widget Function(CustomerDto)? nameBuilder;

  /// See [LinkPreview.onPreviewDataFetched].
  final void Function(String, PreviewData)? onPreviewDataFetched;

  /// Customisation options for the [TextMessage].
  final TextMessageOptions options;

  /// Show user name for the received message. Useful for a group chat.
  final bool showName;

  /// Enables link (URL) preview.
  final bool usePreviewData;

  /// User agent to fetch preview data with.
  final String? userAgent;

  Widget _linkPreview(
    CustomerDto user,
    double width,
    BuildContext context,
  ) {
    final linkDescriptionTextStyle = user.id == message.senderId
        ? InheritedChatTheme.of(context)
            .theme
            .sentMessageLinkDescriptionTextStyle
        : InheritedChatTheme.of(context)
            .theme
            .receivedMessageLinkDescriptionTextStyle;
    final linkTitleTextStyle = user.id == message.senderId
        ? InheritedChatTheme.of(context).theme.sentMessageLinkTitleTextStyle
        : InheritedChatTheme.of(context)
            .theme
            .receivedMessageLinkTitleTextStyle;

    return LinkPreview(
      enableAnimation: true,
      metadataTextStyle: linkDescriptionTextStyle,
      metadataTitleStyle: linkTitleTextStyle,
      onLinkPressed: options.onLinkPressed,
      onPreviewDataFetched: _onPreviewDataFetched,
      openOnPreviewImageTap: options.openOnPreviewImageTap,
      openOnPreviewTitleTap: options.openOnPreviewTitleTap,
      padding: EdgeInsets.symmetric(
        horizontal:
            InheritedChatTheme.of(context).theme.messageInsetsHorizontal,
        vertical: InheritedChatTheme.of(context).theme.messageInsetsVertical,
      ),
      previewData: message.previewData,
      text: message.content.text,
      textWidget: _textWidgetBuilder(user, context, false),
      userAgent: userAgent,
      width: width,
    );
  }

  void _onPreviewDataFetched(PreviewData previewData) {
    if (message.previewData == null) {
      onPreviewDataFetched?.call(message.id, previewData);
    }
  }

  Widget _textWidgetBuilder(
    CustomerDto user,
    BuildContext context,
    bool enlargeEmojis,
  ) {
    final theme = InheritedChatTheme.of(context).theme;
    final bodyLinkTextStyle = user.id == message.senderId
        ? InheritedChatTheme.of(context).theme.sentMessageBodyLinkTextStyle
        : InheritedChatTheme.of(context).theme.receivedMessageBodyLinkTextStyle;
    final bodyTextStyle = user.id == message.senderId
        ? theme.sentMessageBodyTextStyle
        : theme.receivedMessageBodyTextStyle;
    final boldTextStyle = user.id == message.senderId
        ? theme.sentMessageBodyBoldTextStyle
        : theme.receivedMessageBodyBoldTextStyle;
    final codeTextStyle = user.id == message.senderId
        ? theme.sentMessageBodyCodeTextStyle
        : theme.receivedMessageBodyCodeTextStyle;
    final emojiCustomTextStyle = user.id == message.senderId
        ? theme.emojiCustomStyle
        : theme.emojiCustomStyle;

    final emojiTextStyle = theme.emojiTextStyle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //if (showName) nameBuilder?.call(author) ?? UserName(author: author),
        if (enlargeEmojis)
          if (options.isTextSelectable)
            SelectableText(message.content.text, style: emojiCustomTextStyle)
          else
            Text(message.content.text, style: emojiCustomTextStyle)
        else
          TextMessageText(
            bodyLinkTextStyle: bodyLinkTextStyle,
            bodyTextStyle:
                isEmoji(message.content.text) ? emojiTextStyle : bodyTextStyle,
            boldTextStyle: boldTextStyle,
            codeTextStyle: codeTextStyle,
            options: options,
            text: message.content.text,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final enlargeEmojis =
        isConsistsOfEmojis(emojiEnlargementBehavior, message.content);
    final theme = InheritedChatTheme.of(context).theme;
    final user = InheritedUser.of(context).user;
    final width = MediaQuery.of(context).size.width;

    if (usePreviewData && onPreviewDataFetched != null) {
      final urlRegexp = RegExp(regexLink, caseSensitive: false);
      final matches = urlRegexp.allMatches(message.content.text);

      if (matches.isNotEmpty) {
        return _linkPreview(user, width, context);
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal:
            InheritedChatTheme.of(context).theme.messageInsetsHorizontal,
        vertical: InheritedChatTheme.of(context).theme.messageInsetsVertical,
      ),
      child: _textWidgetBuilder(user, context, enlargeEmojis),
    );
  }
}

/// Widget to reuse the markdown capabilities, e.g., for previews.
class TextMessageText extends StatelessWidget {
  const TextMessageText({
    super.key,
    this.bodyLinkTextStyle,
    required this.bodyTextStyle,
    this.boldTextStyle,
    this.codeTextStyle,
    this.maxLines,
    this.options = const TextMessageOptions(),
    this.overflow = TextOverflow.clip,
    required this.text,
  });

  /// Style to apply to anything that matches a link.
  final TextStyle? bodyLinkTextStyle;

  /// Regular style to use for any unmatched text. Also used as basis for the fallback options.
  final TextStyle bodyTextStyle;

  /// Style to apply to anything that matches bold markdown.
  final TextStyle? boldTextStyle;

  /// Style to apply to anything that matches code markdown.
  final TextStyle? codeTextStyle;

  /// See [ParsedText.maxLines].
  final int? maxLines;

  /// See [TextMessage.options].
  final TextMessageOptions options;

  /// See [ParsedText.overflow].
  final TextOverflow overflow;

  /// Text that is shown as markdown.
  final String text;

  @override
  Widget build(BuildContext context) => ParsedText(
        parse: [
          ...options.matchers,
          MatchText(
            onTap: (mail) async {
              final url = Uri(scheme: 'mailto', path: mail);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
            pattern: regexEmail,
            style: bodyLinkTextStyle ??
                bodyTextStyle.copyWith(
                  decoration: TextDecoration.underline,
                ),
          ),
          MatchText(
            onTap: (urlText) async {
              final protocolIdentifierRegex = RegExp(
                r'^((http|ftp|https):\/\/)',
                caseSensitive: false,
              );
              if (!urlText.startsWith(protocolIdentifierRegex)) {
                urlText = 'https://$urlText';
              }
              if (options.onLinkPressed != null) {
                options.onLinkPressed!(urlText);
              } else {
                final url = Uri.tryParse(urlText);
                if (url != null && await canLaunchUrl(url)) {
                  await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                }
              }
            },
            pattern: regexLink,
            style: bodyLinkTextStyle ??
                bodyTextStyle.copyWith(
                  decoration: TextDecoration.underline,
                ),
          ),
          MatchText(
            pattern: PatternStyle.bold.pattern,
            style: boldTextStyle ??
                bodyTextStyle.merge(PatternStyle.bold.textStyle),
            renderText: ({required String str, required String pattern}) => {
              'display': str.replaceAll(
                PatternStyle.bold.from,
                PatternStyle.bold.replace,
              ),
            },
          ),
          MatchText(
            pattern: PatternStyle.italic.pattern,
            style: bodyTextStyle.merge(PatternStyle.italic.textStyle),
            renderText: ({required String str, required String pattern}) => {
              'display': str.replaceAll(
                PatternStyle.italic.from,
                PatternStyle.italic.replace,
              ),
            },
          ),
          MatchText(
            pattern: PatternStyle.lineThrough.pattern,
            style: bodyTextStyle.merge(PatternStyle.lineThrough.textStyle),
            renderText: ({required String str, required String pattern}) => {
              'display': str.replaceAll(
                PatternStyle.lineThrough.from,
                PatternStyle.lineThrough.replace,
              ),
            },
          ),
          MatchText(
            pattern: PatternStyle.code.pattern,
            style: codeTextStyle ??
                bodyTextStyle.merge(PatternStyle.code.textStyle),
            renderText: ({required String str, required String pattern}) => {
              'display': str.replaceAll(
                PatternStyle.code.from,
                PatternStyle.code.replace,
              ),
            },
          ),
        ],
        maxLines: maxLines,
        overflow: overflow,
        regexOptions: const RegexOptions(multiLine: true, dotAll: true),
        selectable: options.isTextSelectable,
        style: bodyTextStyle,
        text: text,
        textWidthBasis: TextWidthBasis.longestLine,
      );
}

@immutable
class TextMessageOptions {
  const TextMessageOptions({
    this.isTextSelectable = true,
    this.onLinkPressed,
    this.openOnPreviewImageTap = false,
    this.openOnPreviewTitleTap = false,
    this.matchers = const [],
  });

  /// Whether user can tap and hold to select a text content.
  final bool isTextSelectable;

  /// Custom link press handler.
  final void Function(String)? onLinkPressed;

  /// See [LinkPreview.openOnPreviewImageTap].
  final bool openOnPreviewImageTap;

  /// See [LinkPreview.openOnPreviewTitleTap].
  final bool openOnPreviewTitleTap;

  /// Additional matchers to parse the text.
  final List<MatchText> matchers;
}
