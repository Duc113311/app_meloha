import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/premium/screens/premium_page.dart';
import 'package:flutter/material.dart';

class UpgradeButton extends StatelessWidget {
  UpgradeButton({super.key, required this.isPremium});

  bool isPremium;

  @override
  Widget build(BuildContext context) {
    return isPremium
        ? const SizedBox()
        : TextButton(
            onPressed: () {
              RouteService.routeGoOnePage(const PremiumPage());
            },
            child: SvgPicture.asset(
              height: 32,
              width: 73,
              AppImages.rightActionUpgrade,
              allowDrawingOutsideViewBox: true,
            ),
          );
  }
}
