import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../app_manager.dart';

//Handle Navigator Route to any Page
@singleton
class RouteService {
  static BuildContext get context => AppManager.globalKeyRootMaterial.currentContext!;

  static dynamic pop<T>({T? result}) {
    return Navigator.pop(context,result);
  }

  static dynamic routeGoOnePage(Widget page) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
  static dynamic presentPage(Widget page) {
    return Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => page,
      ),
    );
  }


  static dynamic popToRootPage() {
    return Navigator.popUntil(context, (route) => route.isFirst);
  }

  static dynamic popToSettingName(String settingName) {
    Navigator.of(context).popUntil((route){
      return route.settings.name == settingName;
    });
  }

  static dynamic routePushReplacementPage(Widget page) {
    MaterialPageRoute route = MaterialPageRoute(
        builder: (context) {
          return page;
        });
    return Navigator.pushReplacement(
      context,
      route,
    );
  }

  static Route? getCurrentRoute() {
    Route? currentRoute;
    Navigator.popUntil(context, (route) {
      currentRoute = route;
      return true;
    });
    return currentRoute;
  }

  static dynamic routePageSetting(Widget page, String settingName, Object? arguments) {
    MaterialPageRoute route = MaterialPageRoute(
        settings: RouteSettings(arguments: arguments, name: settingName),
        builder: (context) {
          return page;
        });
    return Navigator.push(
      context,
      route,
    );
  }

  static MaterialPageRoute routeSetting(Widget page, String settingName, Object? arguments) {
    MaterialPageRoute route = MaterialPageRoute(
        settings: RouteSettings(arguments: arguments, name: settingName),
        builder: (context) {
          return page;
        });
    return route;
  }
}

enum RSPageName {
  chatPage, reportPage, userSwipePage
}

enum RSArgumentName {
  channelID;
}