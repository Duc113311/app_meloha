
enum MessageStatusType { delivered, error, seen, sending, sent, created }

extension MessageStatusTypeExt on MessageStatusType {
  int get id {
    switch (this) {
      case MessageStatusType.delivered: return 1;
      case MessageStatusType.seen: return 2;
      default: return 0;
    }
  }
}
