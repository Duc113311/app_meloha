import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/src/domain/dtos/topics/topic_dto.dart';
import 'package:dating_app/src/modules/home/screens/components/screens/hinge_home.dart';
import 'package:dating_app/src/utils/cache_image_manager.dart';
import 'package:dating_app/src/utils/explore_manager.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../domain/dtos/customers/customers_dto.dart';
import '../../../../domain/services/navigator/route_service.dart';
import '../../../../general/constants/app_image.dart';

class ExploreDetailPage extends StatefulWidget {
  final TopicDto topic;

  const ExploreDetailPage(this.topic, {super.key});

  @override
  State<ExploreDetailPage> createState() => _ExploreDetailPageState();
}

class _ExploreDetailPageState extends State<ExploreDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  var hHeight = Get.height / 1.3;

  int pageSize = 20;
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ExploreManager.shared().topicColor(widget.topic.id),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,

        ),
        toolbarHeight: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: ExploreManager.shared().topicColor(widget.topic.id),
        ),
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.yellow,
                statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
                    ? Brightness.light
                    : Brightness.dark,
              ),
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () async {
                  await ExploreManager.shared().outTopic(widget.topic.id);
                  RouteService.pop();
                },
                icon: SvgPicture.asset(
                  AppImages.icArrowBack,
                  colorFilter: ColorFilter.mode(ThemeUtils.getTitleColor(), BlendMode.srcIn),
                ),
              ),
              title: Text(
                widget.topic.name,
                style: ThemeUtils.getTitleStyle(fontSize: 20.toWidthRatio()),
              ),
            ),
            backgroundColor: Colors.transparent,
            body: isLoading
                ? _buildAnimation()
                : isEndData
                    ? _endDataView()
                    : Container(
                        color: ThemeUtils.getScaffoldBackgroundColor(),
                        child: HingeHome(
                          cardCustomers: customerCards,
                          onEndArray: onEndArray,
                        ),
                      ),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.toWidthRatio()),
                  child: CachedNetworkImage(
                    imageUrl: widget.topic.image,
                    fit: BoxFit.cover,
                    height: 100.toWidthRatio(),
                    width: 100.toWidthRatio(),
                    cacheManager: BHCacheImageManager.shared().cacheManager,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 350),
                child: Text(S.current.finding_people_near_you,
                    style: ThemeUtils.getTextStyle()),
              )
            ],
          );
        });
  }

  Widget _endDataView() => Center(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  S.current.txtid_no_more_data,
                  style: ThemeUtils.getTextStyle(),
                ),
              ),
            )),
      );

  Future<void> loadData({int currentPage = 0}) async {
    setState(() {
      isLoading = true;
    });
    final cards = await ExploreManager.shared()
        .getTopicCards(widget.topic.id, pageSize, currentPage);
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
        color: Colors.white.withOpacity(1 - _controller.value),
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
