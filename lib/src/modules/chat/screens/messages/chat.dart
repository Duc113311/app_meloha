import 'dart:async';
import 'package:dating_app/chatUI/chat_type/preview_data.dart';
import 'package:dating_app/chatUI/widgets/input/input.dart';
import 'package:dating_app/src/data/datasource/chat_datasource/message_datasource.dart';
import 'package:dating_app/src/domain/dtos/chat/chat_message_dto/chat_message_dto.dart';
import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/general/inject_dependencies/inject_dependencies.dart';
import 'package:dating_app/src/modules/home/screens/components/screens/view_customer_page.dart';
import 'package:dating_app/src/modules/report/report_user_page.dart';
import 'package:dating_app/src/modules/subviews/default_user_avatar.dart';
import 'package:dating_app/src/utils/change_notifiers/update_message_notifier.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/printd.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../../../chatUI/bubble/bubble_type.dart';
import '../../../../../chatUI/bubble/chat_bubble.dart';
import '../../../../../chatUI/bubble/chat_bubble_clipper.dart';
import '../../../../../chatUI/chat_theme.dart';
import '../../../../../chatUI/util.dart';
import '../../../../../chatUI/widgets/chat.dart';
import '../../../../domain/dtos/chat/chat_message_dto/message_status_dto.dart';
import '../../../../domain/services/navigator/route_service.dart';
import '../../../../general/constants/app_image.dart';
import '../../../../utils/extensions/color_ext.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.channelID,
    this.friendDTO,
  });

  final CustomerDto? friendDTO;
  final String channelID;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin {
  _ChatPageState();
  MessageDataSource get messageDataSource => getIt<MessageDataSource>();

  bool limitItem = false;
  int currentPage = 0;
  final int pageSize = 50;
  bool hasChanged = false;
  bool oldStatus = false;

  final TextEditingController _controller = TextEditingController();
  CustomerDto currentUser = PrefAssist.getMyCustomer();
  CustomerDto friendDTO = CustomerDto.createEmptyCustomer();
  String channelID = "";
  final List<MessageDto> _messages = [];

  Timer? loadAPITimer;
  bool isLoading = false;
  int addMessageCounter = 0;

  @override
  void initState() {
    super.initState();
    channelID = widget.channelID;
    if (widget.friendDTO != null) {
      friendDTO = widget.friendDTO!;
    }
    oldStatus = friendDTO?.onlineNow ?? false;

    UpdateMessageNotifier.shared.addListener(handleNewMessage);
    _loadMessages(currentPage);
  }

  @override
  void dispose() {
    UpdateMessageNotifier.shared.removeListener(handleNewMessage);
    super.dispose();
  }

  Future<void> _insertMessage(MessageDto message) async {
    if (_messages.isEmpty) {
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
    final status = await messageDataSource.updateStatusMessage(updateMessage);

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
    final result = await messageDataSource.getMessages(
        channelID, pageSize, currentPage);

    if (result.data != null) {
      currentPage += 1;
    }

    List<MessageDto> messages = result.data?.listData ?? [];
    List<CustomerDto> clients = result.data?.clients ?? [];
    if (messages.isEmpty) {
      setState(() {
        limitItem = true;
        isLoading = false;
      });
      return;
    }

    var total = result.data?.total ?? 0;
    var count = result.data?.count ?? 0;

    _addMessages(messages);
    if (friendDTO.isEmpty && clients.isNotEmpty) {
      setState(() {
        friendDTO = clients
            .firstWhere((element) => element.id != currentUser.id);
      });
    }

    setState(() {
      isLoading = false;
      limitItem =
          messages.length + _messages.length > total || count == 0;

      if (limitItem) {
        printD(currentPage);
      }
    });
  }

  void _onTextChanged(String message) {
    //print(message);
  }

  void _handleWavePressed(String text) {
    MessageContent content = MessageContent(text: text);
    _handleSendPressed(content);
  }

  Future<void> _handleMessageLongPress(
      BuildContext context, MessageDto message) async {
    debugPrint(message.content.text);
  }

  void _handleMessageTap(BuildContext context, MessageDto message) {
    debugPrint(message.content.text);
  }

  Future<void> _onEndReached() async {
    if (limitItem) {
      return;
    }
    if (isLoading) {
      return;
    }

    loadAPITimer?.cancel();
    loadAPITimer = Timer(const Duration(milliseconds: 1000), () {
      // setState(() {
        isLoading = true;
      // });
      _loadMessages(currentPage);
    });
  }

  Future<void> _handleSendPressed(MessageContent content) async {
    if (content.text.isEmpty) {
      return;
    }
    final result = await messageDataSource.sendMessage(content, channelID);
    final message = result.data?.record;

    if (message != null) {
      _updateOrInsertMessage(message);
    }
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
          title: friendDTO.isNotEmpty
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
            friendDTO.isNotEmpty && friendDTO.id != Const.melohaID
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
        body: Stack(
              children: [
                Column(
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
                            backgroundColor: ThemeUtils.getChatBackgroundColor(),
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
                    ],
                  ),
                if (isLoading || friendDTO.isEmpty)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
              ],
            ),
      );

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
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
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
}
