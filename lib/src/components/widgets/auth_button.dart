import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';


class AuthButton {
  static Widget button(text, clr1, clr2, clr3, clr4) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(ThemeDimen.borderRadiusNormal),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              clr4,
              clr3,
              clr2,
              clr1,
            ],
          ),
        ),
        height: Get.height / 15,
        width: Get.width / 1.3,
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: Get.height / 45, fontFamily: ""),
          ),
        ),
      ),
    );
  }
}
