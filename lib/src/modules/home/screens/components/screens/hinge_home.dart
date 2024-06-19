import 'dart:async';
import 'package:dating_app/src/domain/dtos/profiles/avatar_dto.dart';
import 'package:dating_app/src/domain/dtos/profiles/prompt_dto.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/home/screens/components/widget/hinge_card.dart';
import 'package:dating_app/src/modules/home/screens/match/match_page.dart';
import 'package:dating_app/src/requests/api_main_home.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:flutter/material.dart';
import '../../../../../domain/dtos/customers/customers_dto.dart';
import '../../../../../domain/services/navigator/route_service.dart';
import '../../../../../utils/utils.dart';

class HingeHome extends StatefulWidget {
  const HingeHome(
      {Key? key, required this.cardCustomers, this.onEndArray, this.onChanged})
      : super(key: key);
  final List<CustomerDto> cardCustomers;

  final void Function(List<CustomerDto> customers, int index)? onEndArray;
  final void Function(int index)? onChanged;

  @override
  State<HingeHome> createState() => _HingeHomeState();
}

class _HingeHomeState extends State<HingeHome>
    with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  bool _canBackCard = false;
  String? _actionImage;
  Timer? btTimer;
  bool disableButton = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void displayMatch(CustomerDto customer, int imgIndex) {
    RouteService.presentPage(MatchPage(
      customer: customer,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final nextUser = widget.cardCustomers.length > _currentIndex + 1
        ? widget.cardCustomers[_currentIndex + 1]
        : null;
    return Container(
      color: ThemeUtils.getScaffoldBackgroundColor(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: widget.cardCustomers.isEmpty
                    ? const SizedBox()
                    : HingeCard(
                        key: Key(widget.cardCustomers[_currentIndex].id),
                        customer: widget.cardCustomers[_currentIndex],
                        cardActionHandle: _cardActionHandle,
                        backCardHandle: _backCardHandle,
                        canBackCard: _canBackCard,
                        actionImage: _actionImage,
                        nextUser: nextUser,
                      ),
              ),
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
                      if (disableButton) {
                        return;
                      }
                      if (widget.cardCustomers.isEmpty) {
                        widget.onEndArray!(widget.cardCustomers, _currentIndex);
                      } else {
                        _cardActionHandle(widget.cardCustomers[_currentIndex],
                            Const.kNopeAction);
                      }
                    },
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _cardActionHandle(CustomerDto customer, int action,
      {AvatarDto? avatar, PromptDto? promptDto}) async {
    if (disableButton) {
      return;
    }
    // setState(() {
    disableButton = true;
    // });

    _canBackCard = action == Const.kNopeAction;

    switch (action) {
      case Const.kLikeAction:
        _actionImage = AppImages.btLike;
        final promptImageId = promptDto == null ? avatar?.id : promptDto?.id;
        if (promptImageId != null) {
          final type =
              promptDto == null ? 0 : 1; //0: Image , 1: Prompt, 2: user
          final model = await ApiMainHome.cardsActionLike(
              customer.id, promptImageId, type);
          if (model?.isMatched == true) {
            RouteService.presentPage(MatchPage(customer: customer));
          }
        } else {}
        break;
      case Const.kNopeAction:
        _actionImage = AppImages.btNope;
        final codeResult = await ApiMainHome.cardsActionNope(customer.id);
        debugPrint("cardsActionNope: $codeResult");
        break;
      case Const.kReportAction:
        _actionImage = AppImages.btNope;
        final codeResult = await ApiMainHome.cardsActionNope(customer.id);
        debugPrint("cardsActionNope: $codeResult");
        break;
      case Const.kSuperLikeAction:
        _actionImage = AppImages.btSuperLike;
        //supper like
        break;
      default:
        break;
    }

    if (_currentIndex + 1 < widget.cardCustomers.length) {
      setState(() {
        _currentIndex += 1;
      });

      int offset = (widget.cardCustomers.length / 10).toInt();

      if (_currentIndex >= widget.cardCustomers.length - offset &&
          widget.onEndArray != null) {
        widget.onEndArray!(widget.cardCustomers, _currentIndex);
      }
    } else if (widget.onEndArray != null) {
      widget.onEndArray!(widget.cardCustomers, _currentIndex);
    }
    if (widget.onChanged != null) {
      widget.onChanged!(_currentIndex);
    }

    btTimer?.cancel();
    btTimer = Timer(const Duration(milliseconds: 700), () {
      // setState(() {
      disableButton = false;
      // });
      btTimer?.cancel();
    });
  }

  Future<void> _backCardHandle() async {
    if (_canBackCard && _currentIndex - 1 >= 0 && widget.cardCustomers.isNotEmpty) {
      _canBackCard = false;
      final customer = widget.cardCustomers[_currentIndex - 1];
      final model = await ApiMainHome.cardsActionBack(
          customer.id);
      debugPrint("back status code: $model");

      setState(() {
        _currentIndex -= 1;
      });
    }

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
