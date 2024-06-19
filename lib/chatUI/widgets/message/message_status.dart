import 'package:flutter/material.dart';
import '../../../src/domain/dtos/chat/chat_message_dto/message_received_type.dart';
import '../state/inherited_chat_theme.dart';

/// A class that represents a message status.
class MessageStatus extends StatelessWidget {
  /// Creates a message status widget.
  const MessageStatus({
    super.key,
    required this.status,
  });

  /// Status of the message.
  final MessageStatusType? status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MessageStatusType.delivered:
      case MessageStatusType.sent:
        return InheritedChatTheme.of(context).theme.deliveredIcon != null
            ? InheritedChatTheme.of(context).theme.deliveredIcon!
            : Row(
              children: [
                const Spacer(),
                Image.asset(
                    'assets/png/icon-delivered.png',
          width: 15, height: 15,
                    color: InheritedChatTheme.of(context).theme.primaryColor,
                  ),
                const SizedBox(width: 5,),
                const Text("received", style: TextStyle(color: Colors.deepPurple, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.right,),
              ],
            );
      case MessageStatusType.error:
        return InheritedChatTheme.of(context).theme.errorIcon != null
            ? InheritedChatTheme.of(context).theme.errorIcon!
            : Image.asset(
                'assets/png/icon-error.png',
          width: 15, height: 15,
                color: InheritedChatTheme.of(context).theme.errorColor,
              );
      case MessageStatusType.seen:
        return InheritedChatTheme.of(context).theme.seenIcon != null
            ? InheritedChatTheme.of(context).theme.seenIcon!
            : Row(
              children: [
                const Spacer(),
                Image.asset(
                    'assets/png/icon-seen.png',
                    width: 15, height: 15,
                    color: InheritedChatTheme.of(context).theme.primaryColor,
                  ),
                const SizedBox(width: 5,),
                const Text("seen", style: TextStyle(color: Colors.deepPurple, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.right,),
              ],
            );
      case MessageStatusType.sending:
        return InheritedChatTheme.of(context).theme.sendingIcon != null
            ? InheritedChatTheme.of(context).theme.sendingIcon!
            : Center(
                child: SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      InheritedChatTheme.of(context).theme.primaryColor,
                    ),
                  ),
                ),
              );
      default:
        return const SizedBox(width: 8);
    }
  }
}
