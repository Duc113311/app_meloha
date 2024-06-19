import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/home/screens/components/screens/hinge_home.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/dtos/customers/customers_dto.dart';
import '../../bloc/explore/explore_detail_page/explore_detail_page_cubit.dart';

class BLindDateState2 extends StatefulWidget {
  const BLindDateState2({super.key, required this.idTopic});
  final String idTopic;

  @override
  State<BLindDateState2> createState() => _BLindDateState2State();
}

class _BLindDateState2State extends State<BLindDateState2> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool isJoinSuccess = false;

  int currentPage = 0;
  PageController pageController = PageController(initialPage: 0);
  String title1 = "Tôi không thể hẹn hò với người:";
  List<String> items1 = [
    "Người hút thuốc",
    "Không phải người yêu chó",
    "Không có tính lãng mạn",
    "Yêu thích tiểu thuyết",
  ];

  String title2 = "Bữa tối tuyệt vời nhất là ở:";
  List<String> items2 = [
    "Trong nhà hàng",
    "Trên khay và xem tivi",
    "Trên giường",
  ];

  //list customer
  List<CustomerDto> cardCustomer = [];

  @override
  void initState() {
    super.initState();
    Utils.toast(S.current.coming_soon);
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
        decoration: _decorationGradient() ,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _appBar(),
            body: isJoinSuccess
            ? swipeCards()
            : _signUpBlind(),
          ),
        ),
      );
  }

  Decoration? _decorationGradient()=>const BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.purple, Colors.pink, Colors.orange],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      tileMode: TileMode.clamp,
    ),
  );

  PreferredSizeWidget? _appBar()=>AppBar(
    leading: IconButton(
      onPressed: () => RouteService.pop(),
      icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),
    ),
    title: AutoSizeText(
      S.current.blind_date,
      style: ThemeUtils.getTitleStyle(color: Colors.white),
    ),
  );

  Widget _signUpBlind()=>Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(
        height: Get.height / 2,
        child: PageView(
          controller: pageController,
          onPageChanged: (int page) {
            setState(() {
              currentPage = page;
              if(currentPage == 2){
                //ToDo: lam sau
                //context.read<ExploreDetailPageCubit>().joinExplore(widget.idTopic);
              }
            });
          },
          physics: const NeverScrollableScrollPhysics(),
          children: [
            pageOne(),
            pageTwo(),
            pageThree(),
          ],
        ),
      ),
      if(isJoinSuccess = false)
        bottomScroll(),
    ].expand((e) => [e,_sizeBox(ThemeDimen.paddingNormal)]).toList(),
  );

  Widget pageOne()=>Container(
    margin: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
    decoration: BoxDecoration(
      color: ThemeUtils.getScaffoldBackgroundColor(),
      borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusNormal)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AutoSizeText(
          title1,
          style: ThemeUtils.getTitleStyle(),
        ),
        Column(
          children: items1.map((p) => _blindItem(p)).toList(),
        ),
      ].expand((e) => [e,_sizeBox(ThemeDimen.paddingNormal)]).toList(),
    ),
  );

  Widget pageTwo()=>Container(
    margin: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
    decoration: BoxDecoration(
      color: ThemeUtils.getScaffoldBackgroundColor(),
      borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusNormal)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AutoSizeText(
          title2,
          style: ThemeUtils.getTitleStyle(),
        ),
        Column(
          children: items2.map((p) {
            return _blindItem(p);
          }).toList(),
        ),
      ].expand((e) => [e,_sizeBox(ThemeDimen.paddingNormal)]).toList(),
    ),
  );

  Widget pageThree()=> BlocConsumer<ExploreDetailPageCubit, ExploreDetailPageState>(
    listener: (context, state){
      if(state is ExploreDetailPageSuccess){
        setState(() {
          isJoinSuccess = true;
          cardCustomer = state.customDto!;
        });
      }
    },
  builder: (context, state) {
    if(state is ExploreDetailPageLoading) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
        decoration: BoxDecoration(
          color: ThemeUtils.getScaffoldBackgroundColor(),
          borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusNormal)),
        ),
        child: AnimatedBuilder(
          animation: CurvedAnimation(parent: _controller, curve: Curves.fastLinearToSlowEaseIn),
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                _buildAnimationContainer(150 * _controller.value),
                _buildAnimationContainer(200 * _controller.value),
                _buildAnimationContainer(250 * _controller.value),
                _buildAnimationContainer(300 * _controller.value),
                _buildAnimationContainer(350 * _controller.value),
                const Align(
                    child: Icon(
                      Icons.phone_android,
                      size: 44,
                    )),
              ],
            );
          },
        ),
      );
    }

    return  const SizedBox.shrink();
  },
);

  Widget swipeCards()=> HingeHome(cardCustomers: cardCustomer);

  Widget _buildAnimationContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Color.fromRGBO(240, 169, 157, 1 - _controller.value)),
    );
  }

  Widget _blindItem(String str) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal, vertical: ThemeDimen.paddingSmall),
      child: WidgetGenerator.getRippleButton(
        colorBg: Colors.transparent,
        buttonHeight: ThemeDimen.buttonHeightNormal,
        buttonWidth: double.infinity,
        onClick: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => BLindDateState3()));
          pageController.animateToPage(pageController.page!.round() + 1,
              duration: const Duration(milliseconds: ThemeDimen.animMillisDuration), curve: Curves.easeIn);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusNormal)),
            border: Border.all(color: ThemeUtils.getTextStyle().color!),
          ),
          padding: EdgeInsets.all(ThemeDimen.paddingSmall),
          child: Center(
            child: AutoSizeText(
              str,
              style: ThemeUtils.getTitleStyle(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _sizeBox(double height) => SizedBox(height: height);

  Widget bottomScroll() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: ThemeDimen.iconSmall,
                  height: ThemeDimen.iconSmall,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: currentPage > 0
                        ? const Icon(
                            Icons.check,
                            color: Colors.orange,
                            size: 20,
                          )
                        : AutoSizeText(
                            "1",
                            style: ThemeUtils.getTitleStyle(color: Colors.orange),
                          ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    width: 50,
                    height: 1,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: ThemeDimen.iconSmall,
                  height: ThemeDimen.iconSmall,
                  decoration: BoxDecoration(
                    color: currentPage >= 1 ? Colors.white : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: currentPage > 1
                        ? const Icon(
                            Icons.check,
                            color: Colors.orange,
                            size: 20,
                          )
                        : AutoSizeText(
                            "2",
                            style: ThemeUtils.getTitleStyle(color: currentPage == 1 ? Colors.orange : Colors.white70),
                          ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    width: 50,
                    height: 1,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: ThemeDimen.iconSmall,
                  height: ThemeDimen.iconSmall,
                  decoration: BoxDecoration(
                    color: currentPage >= 2 ? Colors.white : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: AutoSizeText(
                      "3",
                      style: ThemeUtils.getTitleStyle(color: currentPage == 2 ? Colors.orange : Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: ThemeDimen.paddingNormal),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: AutoSizeText(
                    S.current.txtid_answer_question,
                    style: ThemeUtils.getTextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
              Expanded(
                child: Center(
                  child: AutoSizeText(
                    S.current.txtid_optimise_pairing,
                    style: ThemeUtils.getTextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
              Expanded(
                child: Center(
                  child: AutoSizeText(
                    S.current.txtid_connecting,
                    style: ThemeUtils.getTextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
