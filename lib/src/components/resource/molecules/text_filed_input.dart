import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/theme_const.dart';
import '../../../utils/theme_notifier.dart';

class TextFiledInput extends StatefulWidget {
  const TextFiledInput({Key? key,this.controller,
    this.obscureText = false,
    this.enable = true,
    this.validator,
    this.inputFormatters,
    this.inputType = TextInputType.text,
    this.onChange, this.placeholder, this.errorMaxLines, this.maxLength, this.maxLine, this.autovalidateMode, this.scrollPadding, this.height, this.textStyle, this.errorStyle}) : super(key: key);
  final TextEditingController? controller;
  final bool obscureText;
  final bool? enable;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String value)? onChange;
  final String? placeholder;
  final int? errorMaxLines;
  final int? maxLength;
  final int? maxLine;
  final AutovalidateMode? autovalidateMode;
  final EdgeInsets? scrollPadding;
  final double? height;

  final TextInputType? inputType;
  final TextStyle? textStyle;
  final TextStyle? errorStyle;

  @override
  State<TextFiledInput> createState() => _TextFiledInputState();
}

class _TextFiledInputState extends State<TextFiledInput> {
  final FocusNode _focus = FocusNode();
  bool isFocus = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {
      isFocus = _focus.hasFocus;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: widget.height ?? double.infinity,
      ),
      margin: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall, vertical: ThemeDimen.paddingSmall),
      decoration: BoxDecoration(
        color: ThemeUtils.getShadowColor(),
        borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusSmall)),
      ),
      child: TextFormField(
        maxLines: widget.maxLine,
        maxLength: widget.maxLength,
        keyboardType: widget.inputType,
        enabled: widget.enable,
        focusNode: _focus,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(ThemeDimen.paddingSmall),
          hintText: widget.placeholder,
          hintStyle: ThemeUtils.getPlaceholderTextStyle(),
        ),
        style: ThemeUtils.getTextStyle(),
        controller: widget.controller,
        textAlign: TextAlign.left,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChange,
      ),
    );
  }
}
