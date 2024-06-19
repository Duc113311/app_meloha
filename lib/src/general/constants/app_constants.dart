
import 'package:flutter/widgets.dart';
import '../../app_manager.dart';

abstract class AppConstants {
  static BuildContext? get context => AppManager.globalKeyRootMaterial.currentContext;

  static  double width = MediaQuery.of(context!).size.width;
  static  double height = MediaQuery.of(context!).size.height;


  static const int limitCard = 20;

  static const int MAX_NUMBER_PROMPT = 3;
  static const String androidPackageName = "com.dating.heartlink";

  static const String dynamicLink = "https://heartlink.page.link/verify";

  static String avt = 'https://scontent.fhan14-2.fna.fbcdn.net/v/t39.30808-6/336360696_1364202674358707_8744408560219576487_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=8bfeb9&_nc_ohc=RAEmtNKK0hMAX9PPmfI&_nc_ht=scontent.fhan14-2.fna&oh=00_AfClBD_zfp1aiJDS6uZcT_fe3TdmwUPQrjecPmaG5pnitw&oe=64437342';

  //radius
  static const double radius40 = 40;

  //New Match cell
 static double newMatchWidth = AppConstants.width / 6;

}