import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/components/widgets/dialogs/dialog_remove.dart';
import 'package:dating_app/src/domain/dtos/chat/channel/get_channels_dto.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/general/constants/app_constants.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/subviews/default_user_avatar.dart';
import 'package:dating_app/src/utils/extensions/color_ext.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/socket_manager.dart';
import 'package:dating_app/src/utils/theme_notifier.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../domain/dtos/customers/customers_dto.dart';
import '../screens/messages/chat.dart';

class ConversationItem extends StatefulWidget {
  const ConversationItem({
    super.key,
    required this.channelDto,
  });

  final ChannelDto channelDto;

  @override
  State<ConversationItem> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  late final ChannelDto channelDTO;
  late final CustomerDto clientDTO;
  late ValueKey<String> keySlidable;

  @override
  void initState() {
    super.initState();
    channelDTO = widget.channelDto;
    clientDTO = channelDTO.clients.firstWhereOrNull(
            (element) => element?.id != PrefAssist.getMyCustomer().id) ??
        CustomerDto.deletedAccount();
    keySlidable = ValueKey(channelDTO.channelId);
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: keySlidable,
      //endActionPane: _actionPage(),
      child: _child(),
    );
  }

  ActionPane? _actionPage() => ActionPane(
        dragDismissible: false,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            autoClose: true,
            flex: 1,
            onPressed: (value) => onPressedReport(value),
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Trình Báo',
            padding: EdgeInsets.symmetric(
              vertical: 10 / 667 * AppConstants.height,
            ),
          ),
          SlidableAction(
            autoClose: true,
            flex: 1,
            onPressed: (value) => onPressedUnMatch(value),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Deleted',
          ),
        ],
      );

  Widget _child() => InkWell(
        onTap: onTapNavigator,
        child: Container(
          color: Colors.transparent,
          height: 70 / 667 * AppConstants.height,
          width: Get.width,
          margin: EdgeInsets.only(left: ThemeDimen.paddingNormal),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _avtMess(),
              const SizedBox(width: 8,),
              _containerMess(),
            ],
          ),
        ),
      );

  Widget _avtMess() => SizedBox(
        height: AppConstants.newMatchWidth + 8,
        width: AppConstants.newMatchWidth + 8,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: AppConstants.newMatchWidth,
                    width: AppConstants.newMatchWidth,
                    child: ClipOval(
                      child: SizedBox.fromSize(
                          size: Size.fromRadius(AppConstants.newMatchWidth / 2),
                          child: clientDTO.id == Const.deletedAccount
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: ThemeUtils.borderColor,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                        AppImages.icDeletedAccount,
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                            ThemeUtils.getTextColor(),
                                            BlendMode.srcIn)),
                                  ),
                                )
                              : clientDTO.getAvatarUrl.isEmpty
                                  ? const DefaultUserAvatar()
                                  : CacheImageView(
                                      imageURL: clientDTO.getAvatarUrl,
                                      fit: BoxFit.cover,
                                    )),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 3 / 667 * AppConstants.height,
              bottom: 26 / 667 * AppConstants.height,
              child: isUserOnline
                  ? Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                          color: isUserOnline
                              ? AppColors.color3AD27C
                              : Colors.transparent,
                          borderRadius: BorderRadius.all(
                              Radius.circular(ThemeDimen.borderRadiusNormal)),
                          border: Border.all(color: AppColors.white)),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      );

  bool get isUserOnline {
    if (clientDTO.id == Const.melohaID) {
      return SocketManager.shared().isConnect;
    } else {
      return clientDTO.onlineNow ?? false;
    }
  }

  Widget _containerMess() => Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      clientDTO.fullname!,
                      style: ThemeUtils.getTitleStyle(
                          color: ThemeUtils.chatFullnameColor,
                          fontSize: 16.toWidthRatio()),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  channelDTO.lastMessage?.senderId ==
                              PrefAssist.getMyCustomer().id ||
                          channelDTO.lastMessage?.senderId == Const.melohaID
                      ? const SizedBox()
                      : _yourTurn(),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      channelDTO.lastMessage?.content.text ?? '',
                      style: TextStyle(
                          color: (channelDTO
                                          .lastMessage?.listUserSeen?.isEmpty ??
                                      true) &&
                                  ((channelDTO.lastMessage?.senderId ?? "") !=
                                      PrefAssist.getMyCustomer().id)
                              ? ThemeUtils.getTextColor()
                              : ThemeUtils.getTextColor().withOpacity(0.79),
                          fontSize: 14.toWidthRatio(),
                          fontWeight: (channelDTO
                                          .lastMessage?.listUserSeen?.isEmpty ??
                                      true) &&
                                  ((channelDTO.lastMessage?.senderId ?? "") !=
                                      PrefAssist.getMyCustomer().id)
                              ? FontWeight.bold
                              : FontWeight.normal),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      );

  Widget _yourTurn() => Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.centerRight,
                width: 80 / 375 * AppConstants.width,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: ThemeUtils.getTextColor(),
                ),
                child: Center(
                    child: Text(
                  S.current.txt_your_turn,
                  style: ThemeUtils.getTextStyle(
                      color: ThemeUtils.getScaffoldBackgroundColor()),
                )),
              ),
            ],
          )
        ],
      );

  void onTapNavigator() {
    final page = ChatPage(
      friendDTO: clientDTO,
      channelID: channelDTO.channelId,
    );
    RouteService.routePageSetting(page, RSPageName.chatPage.name,
        {RSArgumentName.channelID.name: channelDTO.channelId});
  }

  void onPressedUnMatch(BuildContext context) {
    Utils.showDialogRemove(
      context,
      DialogRemove(
        onTapSubmit: () async {
          await RouteService.pop();
          //widget.bloc.unMatch(clientDto.id ?? '');
        },
        onTapBack: () {
          RouteService.pop();
        },
      ),
    );
  }

  void onPressedReport(BuildContext context) {}
}
