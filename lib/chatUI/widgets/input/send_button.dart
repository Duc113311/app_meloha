import 'package:dating_app/generated/l10n.dart';
import 'package:flutter/material.dart';

import '../../../src/utils/theme_notifier.dart';
import '../state/inherited_chat_theme.dart';

/// A class that represents send button widget.
class SendButton extends StatelessWidget {
  /// Creates send button widget.
  const SendButton({
    super.key,
    required this.onPressed,
    this.padding = EdgeInsets.zero,
  });

  /// Callback for send button tap event.
  final VoidCallback onPressed;

  /// Padding around the button.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
        margin: InheritedChatTheme.of(context).theme.sendButtonMargin ??
            const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
        child: IconButton(
          constraints: const BoxConstraints(
            minHeight: 24,
            minWidth: 24,
          ),
          icon: InheritedChatTheme.of(context).theme.sendButtonIcon ??
              Image.asset(
                ThemeUtils.isDarkModeSetting() ? "assets/png/ic_send_darkMode.png" : "assets/png/ic_send_lightMode.png",
                width: 27,
                height: 27,
              ),
          onPressed: onPressed,
          padding: padding,
          splashRadius: 13,
          tooltip: S.current.sendButtonAccessibilityLabel,
        ),
      );
}
