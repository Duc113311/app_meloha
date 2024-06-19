// import 'package:dating_app/src/components/widgets/dating_button.dart';
// import 'package:dating_app/src/domain/services/navigator/route_service.dart';
// import 'package:dating_app/src/general/constants/app_image.dart';
// import 'package:dating_app/src/modules/explore/screens/verifyPhoto/verify_detail.dart';
// import 'package:dating_app/src/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class VerifiedJoin extends StatefulWidget {
//   const VerifiedJoin({super.key});
//
//   @override
//   State<VerifiedJoin> createState() => _VerifiedJoinState();
// }
//
// class _VerifiedJoinState extends State<VerifiedJoin> {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Image.asset(
//           AppImages.match9,
//           height: double.infinity,
//           width: double.infinity,
//           fit: BoxFit.cover,
//         ),
//         Container(
//           color: Colors.black.withOpacity(0.3),
//         ),
//         SafeArea(
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             appBar: AppBar(
//               toolbarHeight: 0,
//               automaticallyImplyLeading: false,
//               systemOverlayStyle: SystemUiOverlayStyle(
//                 statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
//                 statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
//                     ? Brightness.light
//                     : Brightness.dark,
//               ),
//               leading: IconButton(
//                 onPressed: () => RouteService.pop(),
//                 icon: const Icon(
//                   Icons.arrow_back_ios_new_rounded,
//                   color: Colors.white,
//                 ),
//               ),
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(
//                     Icons.verified_user,
//                     color: Colors.blue,
//                     size: 20,
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   Text(
//                     S.current.txtid_photo_verified,
//                     style: ThemeUtils.getTitleStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//             body: Padding(
//               padding:
//                   EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Column(
//                     children: [
//                       DatingButton.generalButton(
//                           S.current.txtid_join_now,
//                           ThemeUtils.getPrimaryColor(),
//                           Colors.white,
//                           _joinBlindDate),
//                       SizedBox(height: ThemeDimen.paddingSmall),
//                       WidgetGenerator.getRippleButton(
//                         colorBg: Colors.transparent,
//                         buttonHeight: ThemeDimen.buttonHeightNormal,
//                         buttonWidth: double.infinity,
//                         onClick: () {
//                           RouteService.pop();
//                         },
//                         child: Center(
//                           child: Text(
//                             "NO THANKS",
//                             style: Theme.of(Get.context!)
//                                 .textTheme
//                                 .displaySmall
//                                 ?.copyWith(color: Colors.white),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: ThemeDimen.paddingSuper),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   _joinBlindDate() async {
//     RouteService.routeGoOnePage(const VerifyDetailPage());
//   }
// }
