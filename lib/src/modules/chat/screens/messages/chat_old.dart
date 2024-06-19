import 'dart:async';

import 'package:dating_app/chatUI/chat_type/preview_data.dart';
import 'package:dating_app/chatUI/widgets/input/input.dart';
import 'package:dating_app/src/components/bloc/chat/send_message_cubit.dart';
import 'package:dating_app/src/components/bloc/get_channels/remove_channel_cubit.dart';
import 'package:dating_app/src/domain/dtos/chat/chat_message_dto/chat_message_dto.dart';
import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/modules/home/screens/components/screens/view_customer_page.dart';
import 'package:dating_app/src/modules/report/report_user_page.dart';
import 'package:dating_app/src/modules/subviews/default_user_avatar.dart';
import 'package:dating_app/src/utils/change_notifiers/update_message_notifier.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../../../chatUI/bubble/bubble_type.dart';
import '../../../../../chatUI/bubble/chat_bubble.dart';
import '../../../../../chatUI/bubble/chat_bubble_clipper.dart';
import '../../../../../chatUI/chat_theme.dart';
import '../../../../../chatUI/util.dart';
import '../../../../../chatUI/widgets/chat.dart';
import '../../../../components/bloc/messages/get_messages_cubit.dart';
import '../../../../domain/dtos/chat/chat_message_dto/message_status_dto.dart';
import '../../../../domain/services/navigator/route_service.dart';
import '../../../../general/constants/app_image.dart';
import '../../../../utils/extensions/color_ext.dart';
import '../../../../utils/socket_manager.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.friendDTO,
    required this.channelID,
  });

  final CustomerDto? friendDTO;
  final String channelID;

  @override
  State<ChatPage> createState() => _ChatPageState(friendDTO, channelID);
}

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin {
  _ChatPageState(this.tempFriendDTO, this.channelID);

  bool limitItem = false;
  int currentPage = 0;
  final int pageSize = 20;
  bool hasChanged = false;
  bool oldStatus = false;

  final TextEditingController _controller = TextEditingController();
  final bool _emojiShowing = false;
  final bool _keyboardShowing = false;
  late StreamSubscription<bool> keyboardSubscription;
  CustomerDto currentUser = PrefAssist.getMyCustomer();
  CustomerDto? tempFriendDTO;
  late CustomerDto friendDTO;
  late String channelID;
  Timer? loadAPITimer;
  late final List<MessageDto> _messages = [];
  bool friendNotNull = false;
  bool isLoading = false;
  int addMessageCounter = 0;

  @override
  void initState() {
    super.initState();
    friendNotNull = tempFriendDTO != null;
    if (tempFriendDTO != null) {
      friendDTO = tempFriendDTO!;
      oldStatus = tempFriendDTO!.onlineNow ?? false;
    }

    UpdateMessageNotifier.shared.addListener(handleNewMessage);
    _loadMessages(currentPage);

    /// Keyboard
    // var keyboardVisibilityController = KeyboardVisibilityController();
    // keyboardSubscription =
    //     keyboardVisibilityController.onChange.listen((bool visible) {
    //   _keyboardShowing = visible;
    //   if (visible) {
    //     setState(() {
    //       _emojiShowing = false;
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    UpdateMessageNotifier.shared.removeListener(handleNewMessage);
    super.dispose();
  }

  Future<void> _insertMessage(MessageDto message) async {
    if(_messages.isEmpty){
      setState(() {
        _messages.add(message);
      });
      return;
    }

    int index = _messages.indexWhere((element) => element.id == message.id);
    if (index >= 0) {
      debugPrint("duplicate: $index");
      return;
    }

    int messIndex = _messages.indexWhere((e) =>
    e.insert.date.millisecondsSinceEpoch <
        message.insert.date.millisecondsSinceEpoch);
    setState(() {
      _messages.insert(messIndex, message);
    });
    addMessageCounter += 1;
    if (addMessageCounter == pageSize) {
      currentPage += 1;
      addMessageCounter = 0;
    }

    if ((message.listUserSeen?.isEmpty ?? true) &&
        (message.senderId != currentUser.id)) {
      sendAPIUpdateMessages([message.id]);
    }
  }

  Future<void> _updateMessage(MessageDto message) async {
    int index = _messages.lastIndexWhere((element) => element.id == message.id);
    if (index >= 0) {
      setState(() {
        _messages[index] = message;
      });
    }
  }

  void _addMessages(List<MessageDto> messages) {
    //TODO: save to local DB
    setState(() {
      _messages.addAll(messages);
    });

    final listUpdate = messages
        .where((element) =>
    (element.senderId != currentUser.id) &&
        (element.listUserSeen?.isEmpty ?? false))
        .map((e) => e.id)
        .toList();
    if (listUpdate.isEmpty) {
      return;
    }
    sendAPIUpdateMessages(listUpdate);
  }

  Future<void> sendAPIUpdateMessages(List<String> msgIds) async {
    UpdateMessageDTO updateMessage =
    UpdateMessageDTO(msgIds: msgIds, status: 2);
    context.read<MessagesCubit>().updateStatusMessage(updateMessage);
    hasChanged = true;
  }

  void _removeMessage(MessageDto message) {
    //TODO: save to local DB
    setState(() {
      _messages.remove(message);
    });
  }

  void _removeMessageAt(int index) {
    //TODO: save to local DB
    setState(() {
      _messages.removeAt(index);
    });
  }

  void _removeAllMessages() {
    //TODO: save to local DB
    setState(() {
      _messages.clear();
    });
  }

  Future<void> _updateOrInsertMessage(MessageDto message) async {
    if (_messages.isEmpty) {
      _insertMessage(message);
      return;
    }
    final messageDto =
    _messages.firstWhereOrNull((element) => element.id == message.id);
    if (messageDto == null) {
      _insertMessage(message);
    } else if (message.getSort() > messageDto.getSort()) {
      _updateMessage(message);
    }
  }

  Future<void> _loadMessages(int currentPage) async {
    context.read<MessagesCubit>().getMessages(channelID, pageSize, currentPage);
  }

  // void _handleAttachmentPressed() {
  //   // _fakeAddMessage();
  //
  //   int miliseconds = _keyboardShowing ? 200 : 0;
  //   // Ẩn bàn phím trước
  //   if (_keyboardShowing) {
  //     FocusScope.of(context).unfocus();
  //   }
  //
  //   //sau đó mới hiện emoji
  //   Timer(Duration(milliseconds: miliseconds), () {
  //     setState(() {
  //       _emojiShowing = !_emojiShowing;
  //     });
  //   });
  // }

  void _onTextChanged(String message) {
    //print(message);
  }

  void _handleWavePressed(String text) {
    MessageContent content = MessageContent(text: text);
    _handleSendPressed(content);
  }

  Future<void> _handleMessageLongPress(
      BuildContext context, MessageDto message) async {
    //await Clipboard.setData(ClipboardData(text: message.content.text));
    // _removeMessage(message);
    // UpdateMessageDTO updateMessage =
    //     UpdateMessageDTO(msgIds: [message.id], status: 1);
    // context.read<MessagesCubit>().updateStatusMessage(updateMessage);
  }

  void _handleMessageTap(BuildContext context, MessageDto message) {
    // _removeMessage(message);
    // UpdateMessageDTO updateMessage =
    //     UpdateMessageDTO(msgIds: [message.id], status: 2);
    // context.read<MessagesCubit>().updateStatusMessage(updateMessage);
  }

  Future<void> _onEndReached() async {
    if (limitItem) {
      //Utils.logger('đã hết item rồi');
      return;
    }
    if (isLoading) {
      //debugPrint("dang load tin nhan");
      return;
    }
    isLoading = true;
    currentPage += 1;
    _loadMessages(currentPage);

    // loadAPITimer?.cancel();
    // loadAPITimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //
    //   timer.cancel();
    // });
  }

  Future<void> _handleSendPressed(MessageContent content) async {
    context.read<SendMessageCubit>().sendMessage(content, channelID);
  }

  Future<void> _handlePreviewDataFetched(
      String messageID, PreviewData preview) async {
    final messageIndex =
    _messages.indexWhere((element) => element.id == messageID);
    if (messageIndex >= 0) {
      setState(() {
        _messages[messageIndex].previewData = preview;
      });
    }
  }

  void handleNewMessage() {
    final message = UpdateMessageNotifier.shared.messageDto;

    if (message != null && message?.channelId == channelID) {
      _updateOrInsertMessage(message!);
      hasChanged = true;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
        title: friendNotNull
            ? GestureDetector(
          onTap: () {
            if (friendDTO.id == Const.deletedAccount ||
                friendDTO.id == Const.melohaID) return;
            RouteService.routeGoOnePage(ViewCustomerPage(
              customerDto: friendDTO,
              isFriend: true,
            ));
          },
          child: Transform(
            transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                friendDTO.id == Const.deletedAccount
                    ? ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(20),
                    child: Container(
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
                    ),
                  ),
                )
                    : ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(20),
                    child: friendDTO.getAvatarUrl.isEmpty
                        ? const DefaultUserAvatar()
                        : CacheImageView(
                      imageURL: friendDTO.getAvatarUrl,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          friendDTO.fullname!,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: ThemeUtils.getTextColor()),
                        ),
                        if (friendDTO.id == Const.melohaID)
                          const SizedBox(
                            width: 5,
                          ),
                        if (friendDTO.id == Const.melohaID)
                          SvgPicture.asset(
                            ThemeUtils.isDarkModeSetting()
                                ? AppImages.icVerifiedEnableDark
                                : AppImages.icVerifiedEnable,
                            fit: BoxFit.cover,
                          ),
                      ],
                    ),
                    UserStateView(
                      customer: friendDTO,
                    ),
                  ],
                ),
                // check verify
              ],
            ),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(20),
                child: const CircularProgressIndicator(),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              S.current.txtid_loading,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: <Widget>[
          friendNotNull && friendDTO.id != Const.melohaID
              ? IconButton(
              onPressed: () => _actionSafety(),
              icon: SvgPicture.asset(
                AppImages.icSafety,
                height: 28,
                width: 28,
                allowDrawingOutsideViewBox: true,
                colorFilter: ColorFilter.mode(
                    ThemeUtils.getPrimaryColor(), BlendMode.srcIn),
              ))
              : const SizedBox(),
        ],
        leading: IconButton(
          onPressed: () {
            RouteService.pop(result: hasChanged);
          },
          icon: SvgPicture.asset(
            AppImages.icArrowBack,
            colorFilter:
            ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SendMessageCubit, SendMessageState>(
            listener: (context, state) {
              final result = state.result;
              final message = result?.data?.record;
              if (result != null) {
                Utils.logger('send message: ${result.message}');
              }
              if (message != null) {
                _updateOrInsertMessage(message);
              }
            },
          ),
          BlocListener<MessagesCubit, GetMessagesState>(
            listener: (context, state) {
              if (state is GetMessagesInitial) {
                //show loading
              }
              if (state is GetMessagesSuccess) {
                isLoading = false;
              }
              if (state is GetMessagesFailed) {
                isLoading = false;
                Utils.toast(state.failure?.message ??
                    S.current.txtid_opps_something_went_wrong);
              }
              final messages = state.result?.data?.listData;
              if ((messages?.length ?? 0) == 0) {
                limitItem = true;
                Utils.hideLoading();
              } else {
                var total = state.result?.data?.total ?? 0;
                var count = state.result?.data?.count ?? 0;
                limitItem =
                    messages!.length + _messages.length > total || count == 0;

                _addMessages(messages);
                if (state.result?.data != null) {
                  tempFriendDTO = state.result!.data!.clients
                      .firstWhere((element) => element.id != currentUser.id);
                  if (tempFriendDTO != null) {
                    friendDTO = tempFriendDTO!;
                    setState(() {
                      friendNotNull = true;
                    });
                  }
                }

                Utils.hideLoading();
              }

            },
          ),
          BlocListener<RemoveChannelCubit, RemoveChannelState>(
            listener: (context, state) {
              final result = state.result;
              if (result != null) {
                Utils.logger('remove channel: ${result.message}');
                _removeAllMessages();
              }
            },
          ),
        ],
        child: friendNotNull
            ? isLoading
            ? Container(
          color: ThemeUtils.getScaffoldBackgroundColor(),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        )
            : Column(
          children: [
            Expanded(
              child: Chat(
                scrollController: AutoScrollController(),
                messages: _messages,
                onAvatarTap: (customer) {
                  if (customer.id == Const.deletedAccount ||
                      friendDTO.id == Const.melohaID) return;
                  RouteService.routeGoOnePage(ViewCustomerPage(
                    customerDto: customer,
                    isFriend: true,
                  ));
                },

                onMessageTap: _handleMessageTap,
                onSendPressed: _handleSendPressed,
                onWavePressed: _handleWavePressed,
                onMessageLongPress: _handleMessageLongPress,
                onMessageDoubleTap: _handleMessageTap,
                onEndReached: _onEndReached,
                onPreviewDataFetched: _handlePreviewDataFetched,
                hideBackgroundOnEmojiMessages: true,
                inputOptions: InputOptions(
                  onTextChanged: _onTextChanged,
                  textEditingController: _controller,
                ),
                showUserAvatars: true,
                showUserNames: false,
                user: currentUser,
                friend: friendDTO,
                theme: DefaultChatTheme(
                  backgroundColor:
                  ThemeUtils.getChatBackgroundColor(),
                  inputBorderRadius: BorderRadius.circular(30),
                  inputBackgroundColor: const Color(0xff242a38),
                ),
                bubbleBuilder: _bubbleBuilder,
                groupMessagesThreshold: 60000,
                // 5 phut
                // Đơn vị ms. = 1 phút
                dateHeaderThreshold: 1000 * 3600 * 24,
                // 1 ngay
                dateIsUtc: true,
                showInput: friendDTO.id != Const.deletedAccount,
                isLastPage: limitItem,
              ),
            ),
            // if (_emojiShowing) // chua handle
            //   SizedBox(
            //       height: 250,
            //       child: EmojiPicker(
            //         textEditingController: _controller,
            //         config: Config(
            //           columns: 7,
            //           emojiSizeMax:
            //               32 * (Platform.isIOS ? 1.30 : 1.0),
            //           verticalSpacing: 0,
            //           horizontalSpacing: 0,
            //           gridPadding: EdgeInsets.zero,
            //           initCategory: Category.RECENT,
            //           bgColor: const Color(0xFFF2F2F2),
            //           indicatorColor: Colors.blue,
            //           iconColor: Colors.grey,
            //           iconColorSelected: Colors.blue,
            //           backspaceColor: Colors.blue,
            //           skinToneDialogBgColor: Colors.white,
            //           skinToneIndicatorColor: Colors.grey,
            //           enableSkinTones: true,
            //           recentTabBehavior: RecentTabBehavior.RECENT,
            //           recentsLimit: 28,
            //           replaceEmojiOnLimitExceed: false,
            //           noRecents: const Text(
            //             'No Recents',
            //             style: TextStyle(
            //                 fontSize: 20, color: Colors.black26),
            //             textAlign: TextAlign.center,
            //           ),
            //           loadingIndicator: const SizedBox.shrink(),
            //           tabIndicatorAnimDuration: kTabScrollDuration,
            //           categoryIcons: const CategoryIcons(),
            //           buttonMode: ButtonMode.MATERIAL,
            //           checkPlatformCompatibility: true,
            //         ),
            //       )),
          ],
        )
            : Container(
          color: const Color(0xff242a38),
        ),
      ));

  Widget _bubbleBuilder(
      Widget bubble, {
        required message,
        required firstMessageInGroup,
        required lastMessageInGroup,
        required onlyMessageInGroup,
      }) =>
      ChatBubble(
        clipper: currentUser.id == message.senderId
            ? ChatBubbleClipper(
            type: BubbleType.sendBubble,
            firstMessageInGroup: firstMessageInGroup,
            lastMessageInGroup: lastMessageInGroup,
            onlyMessageInGroup: onlyMessageInGroup)
            : ChatBubbleClipper(
            type: BubbleType.receiverBubble,
            firstMessageInGroup: firstMessageInGroup,
            lastMessageInGroup: lastMessageInGroup,
            onlyMessageInGroup: onlyMessageInGroup),
        margin: EdgeInsets.zero,
        alignment: currentUser.id == message.senderId
            ? Alignment.bottomRight
            : Alignment.bottomLeft,
        backGroundColor: isEmoji(message.content.text)
            ? Colors.transparent
            : currentUser.id == message.senderId
            ? HexColor("4A88D9")
            : HexColor("ececec"),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: bubble,
        ),
      );

  Future<void> _actionSafety() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ReportUserPage(
          userId: friendDTO.id,
          callback: (success) {
            Utils.toast(S.current.success);
          },
        );
      },
      backgroundColor: ThemeUtils.getScaffoldBackgroundColor(),
      isScrollControlled: true,
    );
    // final Uri url = Uri.parse('https://google.com/');
    // if (!await launchUrl(url)) {
    //   throw Exception('Could not launch $url');
    // }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

String getTextFromState(CustomerDto customer) {
  if (customer.id == Const.melohaID) {
    return S.current.txt_service_notification;
  }
  if (customer.onlineNow ?? false) {
    return S.current.txt_online;
  } else {
    return S.current.txt_offline;
  }
}

Color getColorFromState(CustomerDto customer) {
  if (customer.id == Const.melohaID) {
    return Colors.grey;
  }

  if (customer.onlineNow ?? false) {
    return Colors.green;
  } else {
    return Colors.grey;
  }
}

class UserStateView extends StatelessWidget {
  UserStateView({super.key, required this.customer});

  CustomerDto customer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          getTextFromState(customer),
          style: TextStyle(color: getColorFromState(customer), fontSize: 13),
        ),
      ),
    );
  }
}
