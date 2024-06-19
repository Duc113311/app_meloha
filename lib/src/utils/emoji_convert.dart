
class EmojiUtils {
  static String getDatingPurposeEmoji(String item) {
    switch (item) {
      case 'item_1':
        return '💘';
      case 'item_2':
        return '😍';
      case 'item_3':
        return '👬';
      case 'item_4':
        return '🎉';
      case 'item_5':
        return '👋';
      case 'item_6':
        return '🤔';
      default:
        return '☺️';
    }
  }
}