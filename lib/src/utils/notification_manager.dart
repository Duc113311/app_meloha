import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:alert_banner/types/enums.dart';
import 'package:alert_banner/widgets/alert.dart';
import 'package:dating_app/src/general/constants/app_constants.dart';
import 'package:dating_app/src/modules/chat/screens/messages/chat.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../components/widgets/alert_banner/alert_banner_item.dart';
import '../domain/dtos/customers/customers_dto.dart';
import '../domain/services/navigator/route_service.dart';
import '../general/constants/app_image.dart';

class LocalNotificationManager {
  static final LocalNotificationManager _shared =
      LocalNotificationManager._internal();

  LocalNotificationManager._internal();

  Timer? alertTimer;

  static LocalNotificationManager shared() => _shared;

  //Variables
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //Functions
  void _notificationHandle(NotificationResponse details) {
    final json = jsonDecode(details.payload ?? "");
    final channelId = json["channelId"];

    if (channelId != null && channelId.isNotEmpty) {
      final page = ChatPage(friendDTO: null, channelID: channelId);

      var currentRoute = RouteService.getCurrentRoute();

      if (currentRoute?.settings?.name == RSPageName.chatPage.name) {
        RouteService.pop();
        final context = RouteService.context;
        final newRoute = RouteService.routePageSetting(
            page,
            RSPageName.chatPage.name,
            {RSArgumentName.channelID.name: channelId});

        Navigator.replace(context, oldRoute: currentRoute!, newRoute: newRoute);
      } else {
        RouteService.routePageSetting(page, RSPageName.chatPage.name,
            {RSArgumentName.channelID.name: channelId});
      }
    }
  }

  Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (status == PermissionStatus.granted ||
          status == PermissionStatus.denied) {
        return;
      }

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } else {}
  }

  Future<void> show(String title, String message, {String? payload}) async {
    final state = WidgetsBinding.instance.lifecycleState;
    if (state == AppLifecycleState.resumed) {
      return;
    }
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/launcher_icon');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: _notificationHandle);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails('0', title,
        importance: Importance.max, priority: Priority.high);
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(112, title, message, platformChannelSpecifics, payload: payload);
  }

  void showAlertInAPP(String title, String message,
      {CustomerDto? friendDTO, String? channelID, String? payload}) {
    alertTimer?.cancel();
    alertTimer = Timer(const Duration(milliseconds: 500), () {
      showAlertBanner(Get.context!, () {
        if (channelID != null && channelID.isNotEmpty) {
          final page = ChatPage(friendDTO: friendDTO, channelID: channelID);

          var currentRoute = RouteService.getCurrentRoute();

          if (currentRoute?.settings?.name == RSPageName.chatPage.name) {
            RouteService.pop();
            final context = RouteService.context;
            final newRoute = RouteService.routePageSetting(
                page,
                RSPageName.chatPage.name,
                {RSArgumentName.channelID.name: channelID});

            Navigator.replace(context,
                oldRoute: currentRoute!, newRoute: newRoute);
          } else {
            RouteService.routePageSetting(page, RSPageName.chatPage.name,
                {RSArgumentName.channelID.name: channelID});
          }
        }
      },
          AlertBannerItem(
            title: title,
            message: message,
            imageName: AppImages.appIcon,
          ),
          alertBannerLocation: AlertBannerLocation.top,
          durationOfStayingOnScreen: const Duration(seconds: 5),
          curveTranslateAnim: Curves.bounceOut,
          maxLength: AppConstants.width);
    });
  }
}
