import 'package:dating_app/src/domain/dtos/chat/chat_message_dto/chat_message_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class UpdateMessageNotifier with ChangeNotifier {
  static final shared = UpdateMessageNotifier();

  MessageDto? messageDto;
  void updateStatus(MessageDto message) {
    messageDto = message;
    notifyListeners();
  }
}