import 'package:flutter/material.dart';

class DatingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Text title;
  final AppBar appbar;
  final List<Widget> widgets;
  const DatingAppBar(this.title, this.appbar, this.widgets, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      
      title: title,
      // backgroundColor: Colors.white,
      actions: widgets,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appbar.preferredSize.height);
}
