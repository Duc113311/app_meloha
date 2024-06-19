import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:flutter/material.dart';

class Buttonboder extends StatefulWidget {
  const Buttonboder({Key? key, this.onTap, this.textBtn = 'TIẾP TỤC'}) : super(key: key);
  final String? textBtn;
  final void Function()? onTap;

  @override
  State<Buttonboder> createState() => _ButtonboderState();
}

class _ButtonboderState extends State<Buttonboder> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.maxFinite,
        height: 48 ,
        decoration:  BoxDecoration(
          borderRadius:
          BorderRadius.circular(100),
          color: AppColors.white,
          border: Border.all(width: 2,color: AppColors.color585858)
        ),
        child: Center(
          child: Text(
            widget.textBtn!,
            style: const TextStyle(
                color: AppColors.black
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
