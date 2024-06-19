import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/likes_and_tops_pick/screens/like/like_page.dart';
import 'package:dating_app/src/modules/likes_and_tops_pick/screens/top_picks/top_pick_page.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LikePickTabBar extends StatefulWidget {
  LikePickTabBar({super.key, this.backHandle});

  final void Function()? backHandle;

  @override
  State<LikePickTabBar> createState() => _LikePickTabBarState();
}

class _LikePickTabBarState extends State<LikePickTabBar>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _nestedTabController;

  @override
  bool wantKeepAlive = true;

  @override
  void initState() {
    super.initState();
    _nestedTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    String uid = PrefAssist.getMyCustomer().id;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (widget.backHandle != null) {
              widget.backHandle!();
            }
          },
          icon: SvgPicture.asset(
            AppImages.icArrowBack,
            colorFilter:
                ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),
          ),
        ),
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _nestedTabController,
              labelStyle: ThemeUtils.getTitleStyle(fontSize: 14.toWidthRatio()),
              labelColor: ThemeUtils.getTextColor(),
              unselectedLabelColor: ThemeUtils.getTextColor(),
              unselectedLabelStyle: ThemeUtils.getTextStyle(),
              indicatorColor: ThemeUtils.getTextColor(),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 1,
              // indicator: const CustomTabIndicator(),

              physics: const NeverScrollableScrollPhysics(),
              tabs: [
                Tab(
                  text: S.current.txtid_likes,

                ),
                Tab(
                  text: S.current.for_you,
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _nestedTabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  LikePage(
                    showTitle: false,
                  ),
                  TopPickPage(key: Key(uid),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTabIndicator extends Decoration {
  final double radius;
  final Color color;
  final double indicatorHeight;

  const CustomTabIndicator({
    this.radius = 1,
    this.indicatorHeight = 2,
    this.color = Colors.red,
  });

  @override
  _CustomPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(
      this,
      onChanged,
      radius,
      color,
      indicatorHeight,
    );
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;
  final double radius;
  final Color color;
  final double indicatorHeight;

  _CustomPainter(
    this.decoration,
    VoidCallback? onChanged,
    this.radius,
    this.color,
    this.indicatorHeight,
  ) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    final Paint paint = Paint();
    double xAxisPos = offset.dx + configuration.size!.width / 2;
    double yAxisPos =
        offset.dy + configuration.size!.height - indicatorHeight / 2;
    paint.color = color;

    RRect fullRect = RRect.fromRectAndCorners(
      Rect.fromCenter(
        center: Offset(xAxisPos, yAxisPos),
        width: configuration.size!.width / 1.2,
        height: indicatorHeight,
      ),

      // topLeft: Radius.circular(radius),
      // topRight: Radius.circular(radius),
    );

    canvas.drawRRect(fullRect, paint);
  }
}
