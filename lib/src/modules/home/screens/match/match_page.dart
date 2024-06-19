import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/src/components/bloc/chat/send_message_cubit.dart';
import 'package:dating_app/src/components/bloc/get_channels/get_channel_id_cubit.dart';
import 'package:dating_app/src/domain/dtos/chat/chat_message_dto/chat_message_dto.dart';
import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/subviews/gradient_text.dart';
import 'package:dating_app/src/utils/extensions/color_ext.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MatchPage extends StatefulWidget {
  final CustomerDto customer;

  const MatchPage({super.key, required this.customer});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  final _kBannerOffset = 100.0;
  final _kAvatarSize = Get.width * 0.35;
  final _kMinAvatarSize = Get.width * 0.27;
  bool animationCompleted = false;
  final emojis = ["👋", "😉", "❤️", "😍"];
  final TextEditingController _textEditingController = TextEditingController();
  bool hasSentMessage = false;
  String channelID = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<GetChannelIdCubit>().getChannelId(widget.customer.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<SendMessageCubit, SendMessageState>(
            listener: (context, state) {
              setState(() {
                hasSentMessage = true;
              });
            },
          ),
          BlocListener<GetChannelIdCubit, GetChannelIdState>(
            listener: (context, state) {
              setState(() {
                channelID = state.result?.channelId ?? "";
              });
            },
          ),
        ],
        child: Stack(
          children: [
            Image.asset(
              ThemeUtils.isDarkModeSetting()
                  ? AppImages.bgLogin
                  : AppImages.bgLogin,
              height: Get.height,
              width: Get.width,
              fit: BoxFit.cover,
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Stack(children: [
                    Column(
                      children: [
                        SizedBox(
                          height: _kBannerOffset,
                        ),
                        SvgPicture.asset(AppImages.topbanner_match_page),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: _kBannerOffset + _kAvatarSize * 0.7,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: Get.width / 2 - 10,
                            ),
                            CircleAvatar(
                              backgroundColor: HexColor("FCFCFE"),
                              radius: _kAvatarSize / 2,
                              child: CachedNetworkImage(
                                imageUrl:
                                    PrefAssist.getMyCustomer().getAvatarUrl,
                                errorWidget: (context, url, error) =>
                                    const SizedBox(),
                                placeholder: (context, i) => SizedBox(
                                    width: _kAvatarSize,
                                    height: _kAvatarSize,
                                    child: const CircularProgressIndicator()),
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  radius: (_kAvatarSize - 8) / 2,
                                  backgroundImage: imageProvider,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: _kBannerOffset + _kAvatarSize * 0.7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              backgroundColor: HexColor("FCFCFE"),
                              radius: _kAvatarSize / 2,
                              child: CachedNetworkImage(
                                imageUrl: widget.customer.getAvatarUrl,
                                errorWidget: (context, url, error) =>
                                    const SizedBox(),
                                placeholder: (context, i) => SizedBox(
                                    width: _kAvatarSize,
                                    height: _kAvatarSize,
                                    child: const CircularProgressIndicator()),
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  radius: (_kAvatarSize - 8) / 2,
                                  backgroundImage: imageProvider,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Get.width / 2 - 10,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        GradientText(
                          S.current.txt_matched,
                          style: ThemeUtils.getTitleStyle(
                              fontSize: 32.toWidthRatio()),
                          gradient: LinearGradient(
                              colors: [
                                HexColor("4A88D9"),
                                HexColor("052DA6"),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                        ),
                        //     .animate(
                        //   delay: 1000.ms, // this delay only happens once at the very start
                        //   onPlay: (controller) => controller.repeat(), // loop
                        // ).fadeIn(delay: 500.ms),
                        AutoSizeText(
                          '${S.current.txt_you} ${S.current.txt_and.toLowerCase()} ${widget.customer.fullname} ${S.current.txt_have_like}',
                          style: ThemeUtils.getTextStyle(
                            color: HexColor("000410"),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                        ),
                        const SizedBox(
                          height: 64,
                        ),
                        hasSentMessage
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          HexColor("D3D3EE"),
                                          HexColor("E0E0F1")
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: SizedBox(
                                      width: Get.width * 0.86,
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          CircleAvatar(
                                            backgroundColor: HexColor("FCFCFE"),
                                            radius: _kMinAvatarSize / 2,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  widget.customer.getAvatarUrl,
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const SizedBox(),
                                              placeholder: (context, i) => SizedBox(
                                                  width: _kMinAvatarSize,
                                                  height: _kMinAvatarSize,
                                                  child:
                                                      const CircularProgressIndicator()),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      CircleAvatar(
                                                radius:
                                                    (_kMinAvatarSize - 4) / 2,
                                                backgroundImage: imageProvider,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(S.current.txt_you_are_sending, style: ThemeUtils.getTextStyle(color: HexColor("000410"), fontSize: 14),),
                                                  Text(' ${widget.customer.fullname}: ', style: ThemeUtils.getPopupTitleStyle(color: HexColor("000410"), fontSize: 14)),
                                                  Text(_textEditingController.text, style: ThemeUtils.getTextStyle(color: HexColor("000410"), fontSize: 14),),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                ThemeDimen.paddingSuper,
                                                ThemeDimen.paddingBig,
                                                ThemeDimen.paddingSuper,
                                                ThemeDimen.paddingBig),
                                            child: WidgetGenerator.bottomButton(
                                              selected: true,
                                              isShowRipple: true,
                                              buttonHeight:
                                                  ThemeDimen.buttonHeightNormal,
                                              buttonWidth: double.infinity,
                                              onClick: () {
                                                RouteService.pop();
                                              },
                                              child: SizedBox(
                                                height: ThemeDimen
                                                    .buttonHeightNormal,
                                                child: Center(
                                                    child: Text(
                                                  S.current.str_continue,
                                                  style: ThemeUtils
                                                      .getButtonStyle(),
                                                )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 32,
                                  ),
                                ],
                              ).animate(delay: 500.ms).fadeIn(delay: 500.ms)
                            : channelID.isEmpty
                                ? const SizedBox()
                                : AnimatedPadding(
                                    padding: MediaQuery.of(context).viewInsets,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.linear,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: emojis.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      _textEditingController.text = emojis[index];
                                                      _sendMessage(
                                                          emojis[index]);
                                                    },
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 4),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            gradient:
                                                                LinearGradient(
                                                              colors: [
                                                                HexColor(
                                                                    "C0D7F2"),
                                                                HexColor(
                                                                    "AFCAEB")
                                                              ],
                                                              begin: Alignment
                                                                  .topCenter,
                                                              end: Alignment
                                                                  .bottomCenter,
                                                            ),
                                                          ),
                                                          width: (((Get.width -
                                                                      64) /
                                                                  4)) -
                                                              8,
                                                          height: 50,
                                                          child: Center(
                                                              child: Text(
                                                            emojis[index],
                                                            style: ThemeUtils
                                                                .getTitleStyle(
                                                                    fontSize:
                                                                        30),
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        SizedBox(
                                          height: 50.toWidthRatio(),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              const SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: ThemeUtils
                                                        .getPrimaryColor(),
                                                  ),
                                                  child: TextField(
                                                    onTapOutside: (event) {
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                    },
                                                    controller:
                                                        _textEditingController,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    autofocus: false,
                                                    cursorColor:
                                                        HexColor("FCFCFE"),
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          S.current.txt_send_a_message,
                                                      hintStyle: ThemeUtils
                                                          .getPlaceholderTextStyle(
                                                              color: HexColor(
                                                                  "FCFCFE")),
                                                      labelStyle: ThemeUtils
                                                          .getTextFieldLabelStyle(
                                                              color: HexColor(
                                                                  "FCFCFE")),
                                                      border: InputBorder.none,
                                                    ),
                                                    style: TextStyle(
                                                        color:
                                                            HexColor("FCFCFE"),
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 16),
                                                    onChanged: (text) {
                                                      setState(() {});
                                                    },
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .sentences,
                                                    textAlignVertical:
                                                        TextAlignVertical.top,
                                                  ),
                                                ),
                                              ),
                                              Opacity(
                                                opacity: _textEditingController
                                                        .text
                                                        .trim()
                                                        .isEmpty
                                                    ? 0.5
                                                    : 1,
                                                child: InkWell(
                                                  onTap: () {
                                                    _sendMessage(
                                                        _textEditingController
                                                            .text);
                                                  },
                                                  child: SvgPicture.asset(
                                                    AppImages.btLike,
                                                    width: 50.toWidthRatio(),
                                                    height: 50.toWidthRatio(),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        SizedBox(
                                          child: Center(
                                            child: InkWell(
                                              onTap: () {
                                                RouteService.pop();
                                              },
                                              child: Text(
                                                S.current.txt_keep_looking,
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize:
                                                        14.toHeightRatio(),
                                                    color: HexColor("979798"),
                                                    fontFamily: ThemeNotifier
                                                        .fontSemiBold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 32,
                                        ),
                                      ],
                                    ),
                                  ).animate(delay: 500.ms),
                      ],
                    )
                  ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _sendMessage(String mess) {
    if (mess.isEmpty || channelID.isEmpty) {
      return;
    }

    final message = MessageContent(text: mess);
    context.read<SendMessageCubit>().sendMessage(message, channelID);
  }
}
