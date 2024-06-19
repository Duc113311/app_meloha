import 'package:dating_app/src/modules/home/screens/components/screens/hinge_home.dart';
import 'package:dating_app/src/utils/explore_manager.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../domain/dtos/customers/customers_dto.dart';
import '../../../../domain/services/navigator/route_service.dart';
import '../../../../general/constants/app_constants.dart';
import '../../../../general/constants/app_image.dart';

class VerifyDetailPage extends StatefulWidget {
  const VerifyDetailPage({super.key});

  @override
  State<VerifyDetailPage> createState() => _VerifyDetailPageState();
}

class _VerifyDetailPageState extends State<VerifyDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  var hHeight = Get.height / 1.3;

  int pageSize = 5;
  int currentPage = 0;
  bool isLoading = false;
  bool isEndData = false;

  //list customer
  List<CustomerDto> customerCards = [];

  @override
  void initState() {
    super.initState();
    loadData();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purpleAccent, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.clamp,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
              statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
                  ? Brightness.light
                  : Brightness.dark,
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () async {
                RouteService.pop();
              },
              icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
            ),
            title: Text(
              "Verified",
              style: ThemeUtils.getTitleStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: isLoading
              ? _buildAnimation()
              : isEndData
                  ? _endDataView()
                  : HingeHome(
                      cardCustomers: customerCards,
                      onEndArray: onEndArray,
                    ),
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    return AnimatedBuilder(
        animation: CurvedAnimation(
            parent: _controller, curve: Curves.fastLinearToSlowEaseIn),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              _buildAnimationContainer(150 * _controller.value),
              _buildAnimationContainer(200 * _controller.value),
              _buildAnimationContainer(250 * _controller.value),
              _buildAnimationContainer(300 * _controller.value),
              _buildAnimationContainer(350 * _controller.value),
              Align(
                child: Image.asset(
                  AppImages.iconCoffeDate,
                  width: 100 / 375 * AppConstants.width,
                  height: 100,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 140),
                child: Text(S.current.finding_people_near_you,
                    style: ThemeUtils.getTextStyle()
                        .copyWith(color: Colors.white)),
              )
            ],
          );
        });
  }

  Widget _endDataView() => Center(
        child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  S.current.txtid_no_more_data,
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              ),
            )),
      );

  Future<void> loadData({int currentPage = 0}) async {
    setState(() {
      isLoading = true;
    });
    final cards =
        await ExploreManager.shared().getVerifiedCards(pageSize, currentPage);
    setState(() {
      customerCards = cards ?? [];
      isLoading = false;
      isEndData = customerCards.isEmpty;
    });
  }

  Future<void> onEndArray(List<CustomerDto> customers, int index) async {
    debugPrint("customers: ${customers.length} - index: $index");
    if (customers.length - index == 1) {
      loadData(currentPage: currentPage);
      return;
    }
    //currentPage += 1;
  }

  Widget _buildAnimationContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.pink.withOpacity(1 - _controller.value),
      ),
    );
  }

  void swipeMethod() {}

  Future<void> filterExploreUsers() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      swipeMethod();
    });
  }
}
