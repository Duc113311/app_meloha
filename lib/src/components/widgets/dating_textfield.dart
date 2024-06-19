import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

class DatingTextField {
  static Widget textField(hint, controller, errorText, onChange, inputType) {
    return TextField(
      controller: controller,
      onChanged: onChange,
      // cursorColor: HeartColor.mainColor,
      keyboardType: inputType,
      style: Theme.of(Get.context!).textTheme.headlineMedium,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: ThemeUtils.getPlaceholderTextStyle(),
        errorText: errorText,
        // errorStyle: _errorText.toString().isNotEmpty
        //     ? const TextStyle(color: Colors.red)
        //     : const TextStyle(color: Colors.black),
        labelStyle: ThemeUtils.getTextFieldLabelStyle(),
        // enabledBorder: const UnderlineInputBorder(
        //     borderSide: BorderSide(color: Color(0xfffe3c72))),
        // focusedBorder: const UnderlineInputBorder(
        //     borderSide: BorderSide(color: Color(0xfffe3c72))),
        // border: const UnderlineInputBorder(
        //     borderSide: BorderSide(color: Color(0xfffe3c72)))
      ),
    );
  }

  //
  static Widget darkInputField(hint, controller, errorText, onChange, inputType, autofocus) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
      height: ThemeDimen.buttonHeightBig,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal),
        color: Theme.of(Get.context!).shadowColor,
      ),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          onChanged: onChange,
          autofocus: autofocus,
          cursorColor: Theme.of(Get.context!).indicatorColor,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            hintStyle: ThemeUtils.getPlaceholderTextStyle(),
            labelStyle: ThemeUtils.getTextFieldLabelStyle(),
            border: InputBorder.none,
          ),
          style: Theme.of(Get.context!).textTheme.displaySmall,
        ),
      ),
    );
  }
}
