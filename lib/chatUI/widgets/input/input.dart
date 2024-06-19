import 'package:dating_app/generated/l10n.dart';
import 'package:dating_app/src/domain/dtos/chat/chat_message_dto/chat_message_dto.dart';
import 'package:dating_app/src/utils/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/input_clear_mode.dart';
import '../../models/send_button_visibility_mode.dart';
import '../../util.dart';
import '../state/inherited_chat_theme.dart';
import 'input_text_field_controller.dart';
import 'send_button.dart';

/// A class that represents bottom bar widget with a text field, attachment and
/// send buttons inside. By default hides send button when text field is empty.
class Input extends StatefulWidget {
  /// Creates [Input] widget.
  const Input({
    super.key,
    this.isAttachmentUploading,
    this.onAttachmentPressed,
    required this.onSendPressed,
    required this.onWavePressed,
    this.options = const InputOptions(),
  });

  /// Whether attachment is uploading. Will replace attachment button with a
  /// [CircularProgressIndicator]. Since we don't have libraries for
  /// managing media in dependencies we have no way of knowing if
  /// something is uploading so you need to set this manually.
  final bool? isAttachmentUploading;

  /// See [AttachmentButton.onPressed].
  final VoidCallback? onAttachmentPressed;

  /// Will be called on [SendButton] tap. Has [PartialText] which can
  /// be transformed to [TextMessage] and added to the messages list.
  final void Function(MessageContent) onSendPressed;
  final void Function(String) onWavePressed;

  /// Customisation options for the [Input].
  final InputOptions options;

  @override
  State<Input> createState() => _InputState();
}

/// [Input] widget state.
class _InputState extends State<Input> {
  late final _inputFocusNode = FocusNode(
    onKeyEvent: (node, event) {
      if (event.physicalKey == PhysicalKeyboardKey.enter &&
          !HardwareKeyboard.instance.physicalKeysPressed.any(
            (el) => <PhysicalKeyboardKey>{
              PhysicalKeyboardKey.shiftLeft,
              PhysicalKeyboardKey.shiftRight,
            }.contains(el),
          )) {
        if (event is KeyDownEvent) {
          _handleSendPressed();
        }
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );

  bool _sendButtonVisible = false;
  TextEditingController? _textController;

  @override
  void initState() {
    super.initState();
    print("mt input: initState");
    _textController =
        widget.options.textEditingController ?? InputTextFieldController();
    _handleSendButtonVisibilityModeChange();
  }

  void _handleSendButtonVisibilityModeChange() {
    print("mt input: _handleSendButtonVisibilityModeChange");
    if (_textController != null) {
      _textController!.removeListener(_handleTextControllerChange);
    }

    if (widget.options.sendButtonVisibilityMode ==
        SendButtonVisibilityMode.hidden) {
      _sendButtonVisible = false;
    } else if (widget.options.sendButtonVisibilityMode ==
        SendButtonVisibilityMode.editing) {
      _sendButtonVisible = _textController?.text.trim() != '';
      if (_textController != null) {
        _textController!.addListener(_handleTextControllerChange);
      }

    } else {
      _sendButtonVisible = true;
    }
  }

  void _handleSendPressed() {
    if (_textController == null) {
      return;
    }
    final trimmedText = _textController?.text.trim() ?? '';
    if (trimmedText != '') {
      final message = MessageContent(text: trimmedText);
      widget.onSendPressed(message);

      if (widget.options.inputClearMode == InputClearMode.always) {
        _textController?.clear();
      }
    }
  }

  void _handleWavePressed() {
    widget.onWavePressed('👋');
  }

  void _handleTextControllerChange() {
    setState(() {
      _sendButtonVisible = _textController?.text.trim() != '';
    });
  }

  Widget _inputBuilder() {
    final query = MediaQuery.of(context);
    final buttonPadding = InheritedChatTheme.of(context)
        .theme
        .inputPadding
        .copyWith(left: 16, right: 16);
    final safeAreaInsets = isMobile
        ? EdgeInsets.fromLTRB(
            query.padding.left,
            0,
            query.padding.right,
            query.viewInsets.bottom + query.padding.bottom,
          )
        : EdgeInsets.zero;

    return Focus(
      autofocus: !widget.options.autofocus,
      child: Padding(
        padding: InheritedChatTheme.of(context).theme.inputMargin,
        child: Material(
          color: InheritedChatTheme.of(context).theme.backgroundColor,
          child: Container(
            decoration:
                InheritedChatTheme.of(context).theme.inputContainerDecoration,
            padding: safeAreaInsets,
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                if (widget.onAttachmentPressed != null)
                  // TODO: CHƯA CÓ TÍNH NĂNG GỬI ANH GIF, GỬI FILES
                  // AttachmentButton(
                  //   isLoading: widget.isAttachmentUploading ?? false,
                  //   onPressed: widget.onAttachmentPressed,
                  //   padding: buttonPadding,
                  // ),
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                          child: IconButton(
                        onPressed: widget.onAttachmentPressed,
                        icon: const Text('🙇‍♂️', style: TextStyle(fontSize: 25)),
                      ))),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ThemeUtils.getTextFieldColor(),
                        borderRadius: InheritedChatTheme.of(context)
                            .theme
                            .inputBorderRadius,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: TextField(
                          enabled: widget.options.enabled,
                          autocorrect: widget.options.autocorrect,
                          autofocus: widget.options.autofocus,
                          enableSuggestions: widget.options.enableSuggestions,
                          controller: _textController,
                          cursorColor: InheritedChatTheme.of(context)
                              .theme
                              .inputTextCursorColor,
                          decoration: InheritedChatTheme.of(context)
                              .theme
                              .inputTextDecoration
                              .copyWith(
                                hintStyle: InheritedChatTheme.of(context)
                                    .theme
                                    .inputTextStyle
                                    .copyWith(
                                      color: ThemeUtils.getChatTextFieldColor(),
                                    ),
                                hintText: S.current.messages,
                              ),
                          focusNode: _inputFocusNode,
                          keyboardType: widget.options.keyboardType,
                          maxLines: 5,
                          minLines: 1,
                          onChanged: widget.options.onTextChanged,
                          onTap: widget.options.onTextFieldTap,
                          style: InheritedChatTheme.of(context)
                              .theme
                              .inputTextStyle
                              .copyWith(
                                color: ThemeUtils.getTextColor(),
                              ),
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: buttonPadding.bottom + buttonPadding.top + 24,
                    ),
                    child: _sendButtonVisible
                        ? SendButton(
                            onPressed: _handleSendPressed,
                            padding: buttonPadding,
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Center(
                                child: IconButton(
                              onPressed: _handleWavePressed,
                              icon: const Text('👋',
                                  style: TextStyle(fontSize: 25)),
                            )))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant Input oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.options.sendButtonVisibilityMode !=
        oldWidget.options.sendButtonVisibilityMode) {
      _handleSendButtonVisibilityModeChange();
    }
  }

  @override
  void dispose() {

    print("mt input: dispose");
    _inputFocusNode.dispose();
    _textController?.dispose();
    _textController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _inputFocusNode.requestFocus(),
        child: _inputBuilder(),
      );
}

@immutable
class InputOptions {
  const InputOptions({
    this.inputClearMode = InputClearMode.always,
    this.keyboardType = TextInputType.multiline,
    this.onTextChanged,
    this.onTextFieldTap,
    this.sendButtonVisibilityMode = SendButtonVisibilityMode.editing,
    this.textEditingController,
    this.autocorrect = true,
    this.autofocus = false,
    this.enableSuggestions = true,
    this.enabled = true,
  });

  /// Controls the [Input] clear behavior. Defaults to [InputClearMode.always].
  final InputClearMode inputClearMode;

  /// Controls the [Input] keyboard type. Defaults to [TextInputType.multiline].
  final TextInputType keyboardType;

  /// Will be called whenever the text inside [TextField] changes.
  final void Function(String)? onTextChanged;

  /// Will be called on [TextField] tap.
  final VoidCallback? onTextFieldTap;

  /// Controls the visibility behavior of the [SendButton] based on the
  /// [TextField] state inside the [Input] widget.
  /// Defaults to [SendButtonVisibilityMode.editing].
  final SendButtonVisibilityMode sendButtonVisibilityMode;

  /// Custom [TextEditingController]. If not provided, defaults to the
  /// [InputTextFieldController], which extends [TextEditingController] and has
  /// additional fatures like markdown support. If you want to keep additional
  /// features but still need some methods from the default [TextEditingController],
  /// you can create your own [InputTextFieldController] (imported from this lib)
  /// and pass it here.
  final TextEditingController? textEditingController;

  /// Controls the [TextInput] autocorrect behavior. Defaults to [true].
  final bool autocorrect;

  /// Whether [TextInput] should have focus. Defaults to [false].
  final bool autofocus;

  /// Controls the [TextInput] enableSuggestions behavior. Defaults to [true].
  final bool enableSuggestions;

  /// Controls the [TextInput] enabled behavior. Defaults to [true].
  final bool enabled;
}
