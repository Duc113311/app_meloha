import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:dating_app/src/domain/dtos/chat/chat_message_dto/message_status_dto.dart';
import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/domain/dtos/socket_dto/socket_dto.dart';
import 'package:dating_app/src/requests/api_update_profile_setting.dart';
import 'package:dating_app/src/utils/change_notifiers/new_like_notifier.dart';
import 'package:dating_app/src/utils/change_notifiers/update_message_notifier.dart';
import 'package:dating_app/src/utils/change_notifiers/verify_account_notifier.dart';
import 'package:dating_app/src/utils/location_manager.dart';
import 'package:dating_app/src/utils/notification_manager.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_center/notification_center.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../components/bloc/messages/get_messages_cubit.dart';
import '../domain/dtos/chat/chat_message_dto/chat_message_dto.dart';
import '../domain/services/navigator/route_service.dart';
import '../general/constants/app_enum.dart';

class SocketManager {
  static final SocketManager _shared = SocketManager._internal();

  SocketManager._internal();

  static SocketManager shared() => _shared;

  //Variables
  String hostProd = 'wss://chat.heartlinkdating.com/';
  Socket? socket;
  String oldToken = "";

  CustomerDto _currentUser = PrefAssist.getMyCustomer();
  List<String> listNewMessages = [];
  Timer? updateStatusTimer;

  MessagesCubit messagesCubit = Get.context!.read<MessagesCubit>();

  Future<void> updateAuth(String token) async {
    if (oldToken == token) {
      return;
    }
    oldToken = token;

    dynamic auth = {"token": token};

    if (socket == null) {
      final headers = await getExtraHeader();
      socket = io(
          hostProd,
          OptionBuilder()
              .enableForceNew()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .setAuth(auth)
              .setExtraHeaders(headers)
              .build());

      _listenersAndConnect();
    } else {
      socket!.auth = auth;
      socket!.io
        ..disconnect()
        ..connect();

      Utils.logger('Socket Client: update auth and reconnect');
    }

    ///reload current user
    _currentUser = PrefAssist.getMyCustomer();
  }

  Future<Map<String, String>> getExtraHeader() async {
    Map<String, String> headers = {};

    headers["EIO"] = "4";
    headers["b64"] = "1";
    headers["fcmToken"] = PrefAssist.getString("fcmToken");

    final packageInfo = await PackageInfo.fromPlatform();
    Map<String, dynamic> pkInfo = {
      "packageVersion": packageInfo.version,
      "packageName": packageInfo.packageName,
      "buildNumber": packageInfo.buildNumber,
      "environment": AppEnvironment.DEVELOPMENT.name,
    };
    headers["package-info"] = jsonEncode(pkInfo);

    //IP Info
    final countryCode =
        WidgetsBinding.instance.platformDispatcher.locale.countryCode;
    final languageCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final location = await LocationManager.shared().getCurrentLocation();

    final ipv4 = await Ipify.ipv4();
    Map<String, dynamic> ipInfo = {
      "ip": ipv4,
      "timezone": DateTime.now().timeZoneName,
      "countryCode": countryCode,
      "languageCode": languageCode,
      "location": location != null ? [location.lat, location.long] : [],
    };

    headers["ip-info"] = jsonEncode(ipInfo);

    //Device Info
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      Map<String, dynamic> info = {
        "model": androidInfo.model,
        "device": androidInfo.device,
        "product": androidInfo.product,
        "serialNumber": androidInfo.serialNumber,
        "host": androidInfo.host,
        "brand": androidInfo.brand,
        "hardware": androidInfo.hardware,
        "version": androidInfo.version.sdkInt,
        "id": androidInfo.id,
      };
      headers["device-info"] = jsonEncode(info);
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      Map<String, dynamic> info = {
        "model": iosInfo.model,
        "localizedModel": iosInfo.localizedModel,
        "systemName": iosInfo.systemName,
        "systemVersion": iosInfo.systemVersion,
        "identifierForVendor": iosInfo.identifierForVendor,
      };

      headers["device-info"] = jsonEncode(info);
    } else {
      final deviceInfo = await deviceInfoPlugin.deviceInfo;
      Map<String, dynamic> info = {
        "deviceInfo": deviceInfo.toString(),
      };

      headers["device-info"] = jsonEncode(info);
    }

    return headers;
  }

  Future<void> _listenersAndConnect() async {
    if (socket == null) {
      return;
    }

    socket!.onAny((event, data) =>
        {Utils.logger('Socket Client any event: $event - $data')});

    socket!.onError((state) {
      Utils.logger('Socket Client onError: $state');
    });
    socket!.onConnect((state) {
      Utils.logger('Socket Client onConnect: $state');
    });

    socket!
        .on(SocketEventName.newMessage, (data) => _handleReceivedMessage(data));
    socket!.on(SocketEventName.updateMessageStatus,
        (data) => _handleStatusMessage(data));
    socket!.on(SocketEventName.newLike, (data) => _handleNewLike(data));
    socket!.on(
        SocketEventName.verifyAccount, (data) => _handleVerifyAccount(data));
    socket!.onDisconnect((_) => Utils.logger('disconnect'));

    socket!.connect();

    Utils.logger('Socket Client: _listenersAndConnect');
  }

  void emitValue(String eventName, dynamic value) {
    if (socket == null) {
      return;
    }
    socket!.emit(eventName, value);
    Utils.logger('Socket Client: Sent $eventName with value $value');
  }

  void send(dynamic value) {
    if (socket == null) {
      return;
    }
    socket!.send(value);
    Utils.logger('Socket Client: sent value $value');
  }

  Future<void> reConnect() async {
    if (socket != null && socket!.disconnected) {
      socket!.io.connect();
    }
  }

  bool get isConnect {
    if (socket == null) {
      return false;
    }
    return socket!.connected;
  }

  void closeSocket() {
    if (socket == null) {
      return;
    }
    socket!.dispose();
    oldToken = "";
    socket = null;
    Utils.logger('Socket Client closed!');
  }

  String getStatusString() {
    if (socket != null) {
      return "Socket connected: ${socket!.connected}";
    } else {
      return "Socket is null";
    }
  }

  void _handleReceivedMessage(dynamic data) {
    Utils.logger('Socket Client: new message: $data');
    final json = data as Map<String, dynamic>;
    var message = MessageDto.fromJson(json);

    final state = WidgetsBinding.instance.lifecycleState;
    // switch (state) {
    //   case AppLifecycleState.resumed:
    //     NotificationCenter()
    //         .notify(SocketNotification.newMessage.name, data: message);
    //     LocalNotificationManager.shared().showAlertInAPP('title', 'message', "payload");
    //     break;
    //   case AppLifecycleState.paused:
    //     Utils.logger("xx: paused");
    //     break;
    //   case AppLifecycleState.inactive:
    //     Utils.logger("xx: inactive");
    //     break;
    //   case AppLifecycleState.detached:
    //     Utils.logger("xx: detached");
    //     break;
    // }

    UpdateMessageNotifier.shared.updateStatus(message);
    if (message.senderId == _currentUser.id) {
      return;
    }

    listNewMessages.add(message.id);

    updateStatusTimer?.cancel();
    updateStatusTimer = Timer(const Duration(milliseconds: 300), () {
      UpdateMessageDTO updateMessage =
          UpdateMessageDTO(msgIds: listNewMessages, status: 1);
      messagesCubit.updateStatusMessage(updateMessage);
      listNewMessages = [];
    });

    if (state == AppLifecycleState.resumed) {
      var currentRoute = RouteService.getCurrentRoute()?.settings;

      if (currentRoute?.name == RSPageName.chatPage.name &&
          currentRoute?.arguments != null) {
        var arguments = currentRoute!.arguments as Map<String, String?>;
        if (message.channelId == arguments[RSArgumentName.channelID.name]) {
          Utils.logger('Đang trong màn hình chat');
        } else {
          ///Local inapp noti
          LocalNotificationManager.shared().showAlertInAPP(S.current.txt_new_message,
              message.content.text, channelID: message.channelId, payload: message.senderId);
        }
      } else {
        ///Local inapp noti
        LocalNotificationManager.shared().showAlertInAPP(S.current.txt_new_message,
            message.content.text, channelID: message.channelId, payload: message.senderId);
      }
    } else {
      ///Local noti
      final payload = {"channelId": message.channelId, "senderId": message.senderId};
      LocalNotificationManager.shared()
          .show(S.current.txt_new_message, message.content.text, payload: jsonEncode(payload));
    }
  }

  void _handleStatusMessage(dynamic data) {
    Utils.logger('Socket Client: update status: $data');
    final messages = data as List<dynamic>;
    for (var element in messages) {
      final json = element as Map<String, dynamic>;
      final message = MessageDto.fromJson(json);

      if (message.senderId == _currentUser.id) {
        UpdateMessageNotifier.shared.updateStatus(message);
        // NotificationCenter()
        //     .notify(SocketEventName.updateMessageStatus, data: message);
      }
    }
  }

  void _handleNewLike(dynamic data) {
    Utils.logger('Socket Client: received new like: $data');
    final json = data as Map<String, dynamic>;
    final likeModel = SocketNewLikeDto.fromJson(json);
    if (likeModel.actionType == SocketActionType.like) {
      if (likeModel.isMatched) {
        final state = WidgetsBinding.instance.lifecycleState;
        if (state == AppLifecycleState.resumed) {
          LocalNotificationManager.shared().showAlertInAPP(
              S.current.app_title, S.current.txt_you_got_a_new_match);
        } else {
          LocalNotificationManager.shared().show(S.current.app_title, S.current.txt_you_got_a_new_match);
        }
        //Send notification
      }
    } else if (likeModel.actionType == SocketActionType.superLike) {
      //day la super like
    } else {
      debugPrint('Định dạng mới chưa được xử lý');
    }

    NewLikeNotifier.shared.gotNewLike();
  }

  Future<void> _handleVerifyAccount(dynamic data) async {
    final json = data as Map<String, dynamic>;
    Utils.logger('Socket Client: received status: $data');
    final status = json["verified"];
    VerifyAccountNotifier.shared.updateStatus(status);
    await ApiProfileSetting.getProfile(force: true);
  }
}

class SocketEventName {
  static const String newMessage = 'new-message';
  static const String updateMessageStatus = 'message-update-status';

  static const String newLike = 'got-new-like';
  static const String verifyAccount = 'user-verified';
}
