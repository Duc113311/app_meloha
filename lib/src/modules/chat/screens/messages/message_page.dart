import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/data/datasource/chat_datasource/get_channels_datasource.dart';
import 'package:dating_app/src/data/datasource/chat_datasource/get_friends_datasource.dart';
import 'package:dating_app/src/data/datasource/like_and_for_you/like_and_for_you_datasource.dart';
import 'package:dating_app/src/data/object_request_api/likes_and_for_you/likes_request.dart';
import 'package:dating_app/src/domain/dtos/chat/channel/get_channels_dto.dart';
import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/domain/dtos/socket_dto/socket_dto.dart';
import 'package:dating_app/src/general/inject_dependencies/inject_dependencies.dart';
import 'package:dating_app/src/modules/subviews/default_user_avatar.dart';
import 'package:dating_app/src/modules/subviews/upgrade_button.dart';
import 'package:dating_app/src/utils/change_notifiers/new_like_notifier.dart';
import 'package:dating_app/src/utils/change_notifiers/premium_notifier.dart';
import 'package:dating_app/src/utils/change_notifiers/update_message_notifier.dart';
import 'package:dating_app/src/utils/extensions/color_ext.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notification_center/notification_center.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../domain/dtos/chat/chat_message_dto/chat_message_dto.dart';
import '../../../../domain/dtos/like_and_top_pick/customers_like_top_dto.dart';
import '../../../../domain/services/navigator/route_service.dart';
import '../../../../general/constants/app_image.dart';
import '../../../../utils/pref_assist.dart';
import '../../../../utils/socket_manager.dart';
import '../../../likes_and_tops_pick/screens/like/like_page.dart';
import '../../widget/conversation_item.dart';
import 'chat.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with AutomaticKeepAliveClientMixin {
  final GetChannelsDataSource _getChannelsDataSource =
      getIt<GetChannelsDataSource>();
  final LikeAndForYouDataSource _likeAndForYouDataSource =
      getIt<LikeAndForYouDataSource>();
  final GetFriendsDataSource _getFriendsDataSource =
      getIt<GetFriendsDataSource>();

  List<ChannelDto> listChannels = [];
  List<CustomerDto> listNewFriends = [];
  LikeTopDto otherLikeYouDTO = LikeTopDto();

  CustomerDto currentUser = PrefAssist.getMyCustomer();

  final kNewConnectionWidth = 90.toWidthRatio();
  final kNewConnectionContainerHeight = 90.toWidthRatio();
  final kNewConnectionHeight = 130.toWidthRatio();
  final getChannelPageSize = 10;
  int getChannelCurrentPage = 0;

  final getNewMatchesPageSize = -1;
  int getNewMatchesCurrentPage = 0;

  final getOtherLikesPageSize = 20;
  int getOtherLikesCurrentPage = 0;

  bool showLoading = true;
  bool isEndData = false;
  bool loadMore = false;

  final ScrollController _messageController = ScrollController();
  TextEditingController controller = TextEditingController();

  GlobalKey refreshKey = GlobalKey();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  Timer? loadAllMessagesTimer;

  void Function(BuildContext context, MessageDto)? onMessageTap;

  @override
  void initState() {
    super.initState();

    UpdateMessageNotifier.shared.addListener(loadAllWithTimer);
    NewLikeNotifier.shared.addListener(loadAllWithTimer);

    ThemeNotifier.themeModeRef.addListener(() {
      if(mounted) {
        setState(() {});
      }
    });

    PremiumNotifier.shared.addListener(() {
      if(mounted) {
        setState(() {});
        debugPrint(PremiumNotifier.shared.isPremium.toString());
      }
    });

    _loadAllDatas();
  }

  @override
  void dispose() {
    _removeNotifications();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              S.current.app_title.toUpperCase(),
              style: ThemeUtils.getTitleStyle(
                  color: ThemeUtils.getTextColor()),
            ),
            const Spacer(),
          ],
        ),
        actions: [
          UpgradeButton(
            isPremium: PremiumNotifier.shared.isPremium,
          ),
        ],
      ),
      body: showLoading
          ? SizedBox(
              width: context.width,
              height: context.height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SmartRefresher(
              key: refreshKey,
              enablePullDown: true,
              enablePullUp: !isEndData,
              header: const WaterDropHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus? mode) {
                  return mode == LoadStatus.loading
                      ? const SizedBox(
                          height: 55.0, child: CupertinoActivityIndicator())
                      : const SizedBox();
                },
              ),
              controller: refreshController,
              onRefresh: refreshScreen,
              onLoading: _loadMoreMessage,
              //physics: const BouncingScrollPhysics(),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: _messageController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _newMatches(),
                    _unreadMessages(),
                    _listMessage(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _newMatches() => Padding(
        padding: EdgeInsets.all(ThemeDimen.paddingSmall),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: ThemeDimen.paddingSmall),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    SizedBox(
                      width: ThemeDimen.paddingNormal,
                    ),
                    Text(
                      S.current.new_connection,
                      style: ThemeUtils.getTitleStyle(),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    listNewFriends.isNotEmpty
                        ? Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: ThemeUtils.getPrimaryColor(),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                            child: Center(
                              child: Text(newConnectionString(),
                                  style: ThemeTextStyle.kDatingMediumFontStyle(
                                      13, Colors.white)),
                            ),
                          )
                        : Container(
                            color: Colors.yellow,
                          ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: ThemeDimen.paddingSmall),
              child: SizedBox(
                height: kNewConnectionHeight + ThemeDimen.paddingNormal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    listNewFriends.isEmpty
                        ? _newConnectionShimmers()
                        : _newConnectionWidget()
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _newConnectionWidget() => Expanded(
        child: ListView.separated(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemCount: listNewFriends.length + 1,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.toWidthRatio()),
            child: index == 0
                ? _likesYouItem()
                : _newMatchItem(listNewFriends[index - 1]),
          ),
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(),
        ),
      );

  Widget _newConnectionShimmers() {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: 9,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.toWidthRatio()),
          child: index == 0 ? _likesYouItem() : _connectionShimmer(),
        ),
        separatorBuilder: (BuildContext context, int index) => const SizedBox(),
      ),
    );
  }

  Widget _newMatchItem(CustomerDto customer) {
    return GestureDetector(
      onTap: () {
        newMatchTapHandle(customer);
      },
      child: SizedBox(
        width: kNewConnectionWidth,
        height: kNewConnectionHeight,
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.toWidthRatio()),
                  color: HexColor("D9D9D9"),
                ),
                width: kNewConnectionWidth,
                height: kNewConnectionContainerHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.toWidthRatio()),
                  child: customer.id == Const.deletedAccount
                      ? Container(
                          decoration: BoxDecoration(
                            color: ThemeUtils.borderColor,
                          ),
                          child: Center(
                            child: SvgPicture.asset(AppImages.icDeletedAccount,
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    ThemeUtils.getTextColor(),
                                    BlendMode.srcIn)),
                          ),
                        )
                      : customer.getAvatarUrl.isEmpty
                          ? const DefaultUserAvatar()
                          : CacheImageView(
                              animationColor: ThemeUtils.getPrimaryColor(),
                              width: kNewConnectionWidth,
                              height: kNewConnectionContainerHeight,
                              imageURL: customer.getAvatarUrl,
                              fit: BoxFit.cover,
                            ),
                )),
            SizedBox(
              height: 4.toWidthRatio(),
            ),
            Text(
              customer.fullname,
              style: ThemeUtils.getTextStyle(),
            )
          ],
        ),
      ),
    );
  }

  Widget _likesYouItem() {
    return GestureDetector(
      onTap: likeUHandle,
      child: SizedBox(
        width: kNewConnectionWidth,
        height: kNewConnectionHeight,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.toWidthRatio()),
                    color: HexColor("D9D9D9"),
                  ),
                  width: kNewConnectionWidth,
                  height: kNewConnectionContainerHeight,
                  child: Center(
                    child: Container(
                      width: 40.toWidthRatio(),
                      height: 40.toWidthRatio(),
                      decoration: BoxDecoration(
                        color: ThemeUtils.getPrimaryColor(),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.toWidthRatio()),
                        ),
                      ),
                      child: Center(
                        child: Text(likeYouString,
                            style: ThemeTextStyle.kDatingMediumFontStyle(
                                13, Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4.toWidthRatio(),
            ),
            Text(
              S.current.txtid_likes,
              style: ThemeUtils.getTextStyle(),
            )
          ],
        ),
      ),
    );
  }

  String get likeYouString {
    final total = otherLikeYouDTO.total ?? 0;
    return total > 99 ? "99+" : total.toString();
  }

  Widget _connectionShimmer() {
    return SizedBox(
      width: kNewConnectionWidth,
      height: kNewConnectionHeight,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.toWidthRatio()),
              color: HexColor("D9D9D9"),
            ),
            width: kNewConnectionWidth,
            height: kNewConnectionContainerHeight,
          ),
          const Spacer(),
          //Text(S.current.like, style: ThemeUtils.getTextStyle(),)
        ],
      ),
    );
  }

  Widget _unreadMessages() {
    final unread = getTotalUnread();
    return Padding(
      padding: EdgeInsets.all(ThemeDimen.paddingNormal),
      child: Row(
        children: [
          Text(
            S.current.txt_new_message,
            style: ThemeUtils.getTitleStyle(),
          ),
          const SizedBox(
            width: 4,
          ),
          unread == 0
              ? const SizedBox()
              : Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                      color: ThemeUtils.getPrimaryColor(),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(14))),
                  child: Center(
                    child: Text(
                      unread > 99 ? "99+" : unread.toString(),
                      style: ThemeTextStyle.kDatingMediumFontStyle(
                          13, Colors.white),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  String conversationID(int index) {
    if (listChannels[index].lastMessage == null) {
      return listChannels[index].channelId;
    } else {
      final friendDto = listChannels[index].clients.firstWhereOrNull(
              (element) => element?.id != PrefAssist.getMyCustomer().id) ??
          CustomerDto.deletedAccount();

      final message = listChannels[index].lastMessage!;
      return message.id +
          [message.listUserSeen ?? []].length.toString() +
          friendDto.getAvatarUrl +
          (friendDto.getAvatarModel?.isVerified ?? false).toString();
    }
  }

  int getTotalUnread() {
    final friendMessages = listChannels.where((element) =>
        ((element.lastMessage?.senderId ?? "") != currentUser.id) &&
        ((element.lastMessage?.listUserSeen ?? []).isEmpty));
    return friendMessages.length;
  }

  Widget _listMessage() => Container(
        padding: const EdgeInsets.only(top: 8, bottom: 20),
        width: double.maxFinite,
        child: listChannels.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    S.current.you_have_no_messages_yet,
                    style: ThemeUtils.getCaptionStyle(fontSize: 16),
                  ),
                ),
              )
            : SingleChildScrollView(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: listChannels.length,
                  separatorBuilder: (context, index) => const SizedBox(),
                  itemBuilder: (context, index) {
                    return ConversationItem(
                      key: ValueKey(conversationID(index)),
                      channelDto: listChannels[index],
                    );
                  },
                ),
              ),
      );

  Future<String?> refreshScreen() async {
    showLoading = true;
    await _loadAllDatas();
    refreshController.refreshCompleted();
    return 'Loading Success . . .';
  }

  String newConnectionString() {
    var total = listNewFriends.length;
    if (total == 0) {
      return "";
    }
    return total > 99 ? "99+" : total.toString();
  }

  void onSearchText(String value) async {}

  void likeUHandle() {
    RouteService.routeGoOnePage(LikePage(
      showTitle: true,
    ));
  }

  Future<void> newMatchTapHandle(CustomerDto customer) async {
    final page = ChatPage(
      friendDTO: customer,
      channelID: customer.channelId!,
    );
    final result = await RouteService.routePageSetting(page, RSPageName.chatPage.name,
        {RSArgumentName.channelID.name: customer.channelId!});
    if (result is bool && result) {
      _loadAllDatas();
    }
  }

  Future<void> _removeNotifications() async {
    UpdateMessageNotifier.shared.removeListener(loadAllWithTimer);
    NewLikeNotifier.shared.removeListener(loadAllWithTimer);
  }


  void loadAllWithTimer() {
    if (!mounted) {
      return;
    }
    loadAllMessagesTimer?.cancel();
    loadAllMessagesTimer =
        Timer(const Duration(milliseconds: 1000), () async {
      await _loadAllDatas();
    });
  }

  Future<void> _loadMoreMessage() async {
    if (isEndData || loadMore) {
      return;
    }
    loadMore = true;
    getChannelCurrentPage += 1;
    final newData = await _getChannelsDataSource.getChannels(
        getChannelPageSize, getChannelCurrentPage);
    listChannels.addAll(newData.listData);

    isEndData = newData.total <= listChannels.length;
    loadMore = false;
    refreshController.loadComplete();
    setState(() {});
  }

  Future<void> _loadAllDatas() async {
    if (listChannels.isEmpty) {
      setState(() {
        showLoading = true;
      });
    }

    getChannelCurrentPage = 0;
    final channels = await _getChannelsDataSource.getChannels(
        getChannelPageSize, getChannelCurrentPage);
    listChannels = channels.listData;
    isEndData = channels.total <= channels.listData.length;

    final newFriends = await _getFriendsDataSource.getNewFriends(
        getNewMatchesPageSize, getNewMatchesCurrentPage);
    listNewFriends = newFriends.listData ?? [];

    final likeU =
        await _likeAndForYouDataSource.getLikes(LikesRequest(10, 0, "like"));
    otherLikeYouDTO = likeU;

    showLoading = false;
    setState(() {});
  }

// safety action
  void actionSafety() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 28, left: 16, bottom: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  S.current.txtid_safety_toolkit,
                  style: ThemeUtils.getTextStyle(),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Utils.toast(S.current.coming_soon);
              },
              leading: const Icon(
                Icons.flag,
                color: Colors.red,
              ),
              title: Text(S.current.txtid_report),
            ),
            ListTile(
              onTap: () {
                Utils.toast(S.current.coming_soon);
              },
              leading: const Icon(
                Icons.safety_check,
                color: Colors.blue,
              ),
              title: Text(S.current.txtid_safety_center),
            ),
            Container(
              height: 20,
              color: Colors.transparent,
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
