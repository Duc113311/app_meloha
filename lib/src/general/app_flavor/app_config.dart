import 'package:flutter/cupertino.dart';

import '../constants/app_enum.dart';

class AppConfig extends  InheritedWidget{
  const AppConfig({super.key, required super.child, required this.environment});
  final AppEnvironment environment;

  static AppConfig? of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}