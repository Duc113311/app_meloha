import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

class LikePickPage extends StatefulWidget {
  const LikePickPage({Key? key}) : super(key: key);

  @override
  State<LikePickPage> createState() => _LikePickPageState();
}

class _LikePickPageState extends State<LikePickPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        color: ThemeColor.darkMainColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Text(
                "Like & Picks",
                style: Theme.of(Get.context!).textTheme.displaySmall,
              ),
            )
          ],
        ),
      ),
    );
  }
}
