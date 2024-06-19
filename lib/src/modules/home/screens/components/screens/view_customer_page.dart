import 'dart:math';

import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/domain/dtos/profiles/avatar_dto.dart';
import 'package:dating_app/src/domain/dtos/profiles/prompt_dto.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/home/screens/components/widget/hinge_card.dart';
import 'package:dating_app/src/modules/home/screens/match/match_page.dart';
import 'package:dating_app/src/requests/api_main_home.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ViewCustomerPage extends StatefulWidget {
  const ViewCustomerPage(
      {super.key, required this.customerDto, this.isFriend = false});

  final CustomerDto customerDto;
  final bool isFriend;

  @override
  State<ViewCustomerPage> createState() => _ViewCustomerPageState();
}

class _ViewCustomerPageState extends State<ViewCustomerPage> {
  double titleOpacity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => RouteService.pop(),
          icon: SvgPicture.asset(
            AppImages.icArrowBack,
            colorFilter:
                ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),
          ),
        ),
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Opacity(
            opacity: titleOpacity,
            child: Container(
              color: ThemeUtils.getCaptionColor(),
              height: 0.5,
            ),
          ),
        ),
        centerTitle: false,
        title: Opacity(
          opacity: titleOpacity,
          child: Text(
            widget.customerDto.fullname,
            maxLines: 1,
            style: ThemeUtils.getTitleStyle(fontSize: 18)
                .copyWith(overflow: TextOverflow.ellipsis),
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
      body: Stack(
        children: [
          HingeCard(
            key: Key(widget.customerDto.id),
            customer: widget.customerDto,
            cardActionHandle: _cardActionHandle,
            backCardHandle: _backCardHandle,
            canBackCard: false,
            isFriend: widget.isFriend,
            showBackCard: false,
            scrollOffset: _scrollOffset,
          ),
          if (!widget.isFriend)
            Positioned(
                bottom: 0,
                left: 16,
                child: IconButton(
                  icon: Image.asset(
                    AppImages.btNopePNG,
                    height: 79.toWidthRatio(),
                    width: 79.toWidthRatio(),
                    fit: BoxFit.contain,
                  ),
                  onPressed: () async {
                    _cardActionHandle(widget.customerDto, Const.kNopeAction);
                  },
                )),
        ],
      ),
    );
  }

  void _scrollOffset(double offset) {
    setState(() {
      titleOpacity = min(offset / 200, 1);
    });
  }

  Future<void> _cardActionHandle(CustomerDto customer, int action,
      {AvatarDto? avatar, PromptDto? promptDto, BuildContext? context}) async {
    switch (action) {
      case Const.kLikeAction:
        final promptImageId = promptDto == null ? avatar?.id : promptDto?.id;
        if (promptImageId != null) {
          final type =
              promptDto == null ? 0 : 1; //0: Image , 1: Prompt, 2: user
          final model = await ApiMainHome.cardsActionLike(
              customer.id, promptImageId, type);
          debugPrint("like codeResult: $model");

          if (model?.isMatched == true) {
            await RouteService.presentPage(MatchPage(customer: customer));
            RouteService.pop(result: customer);
          } else {}
        } else {
          debugPrint("VKL -- id is null");
        }
        break;
      case Const.kNopeAction:
        final codeResult = await ApiMainHome.cardsActionNope(customer.id);
        debugPrint("nope codeResult: $codeResult");
        RouteService.pop();
        break;
      case Const.kSuperLikeAction:
        //supper like
        break;
      default:
        break;
    }
  }

  void _backCardHandle() {}
}
