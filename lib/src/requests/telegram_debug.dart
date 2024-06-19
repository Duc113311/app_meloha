import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class TelegramDebug {
  static TeleDart? teledart;
  static bool isDebug = false;

  static initTele() async {
    if (teledart == null) {
      var botToken = "5930912011:AAGn3KLjHxqfnKEjFSfXTeXhHyWJKf9eZR8";
      final username = (await Telegram(botToken).getMe()).username;
      teledart = TeleDart(botToken, Event(username!));

      teledart?.start();
    }
  }

  static Future<bool> debugMessage(String message) async {
    if (!kDebugMode || !isDebug) return false;
    await initTele();
    // Utils.logger(message);
    await teledart?.sendMessage(-817110675, message);
    return true;
  }

  static Future<bool> debugResponse(String response) async {
    if (!kDebugMode || !isDebug) return false;
    await initTele();
    // Utils.logger(response);
    final body = json.decode(response);
    String message = '';
    try {
      message += "${body['data'].length}\n${body['message']}";
    } catch (e) {
      message = e.toString();
    }
    // Utils.logger(message);
    await teledart?.sendMessage(-817110675, message);
    return true;
  }
}
