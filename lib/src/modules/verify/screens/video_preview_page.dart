import 'dart:io';

import 'package:dating_app/src/components/widgets/dating_button.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/modules/verify/bloc/verify_cubit.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewPage extends StatefulWidget {
  final String filePath;

  const VideoPreviewPage({Key? key, required this.filePath}) : super(key: key);

  @override
  State<VideoPreviewPage> createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewPage> {
  late VideoPlayerController _videoPlayerController;
  late final VerifyCubit _cubit;

  bool uploadedSuccess = false;
  bool isVerifySuccess = false;

  @override
  void initState() {
    _cubit = VerifyCubit();
    _initVideoPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: Scaffold(
        appBar: AppBar(backgroundColor: ThemeColor.darkMainColor
            // actions: [
            //   IconButton(
            //     icon: const Icon(Icons.check),
            //     onPressed: () {
            //       debugPrint('do something with the file : ${widget.filePath}');
            //       // Upload file to firebase
            //       _uploadVideo(widget.filePath);
            //     },
            //   )
            // ],
            ),
        body: Container(
          width: Get.width,
          height: Get.height,
          color: ThemeColor.darkMainColor,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: ThemeDimen.paddingBig),
                child: Container(
                  height: Get.height / 2.2,
                  width: Get.width - 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusSmall)),
                  ),
                  child: AspectRatio(aspectRatio: _videoPlayerController.value.aspectRatio, child: VideoPlayer(_videoPlayerController)),
                ),
              ),
              BlocListener<VerifyCubit, VerifyState>(
                listener: (context, state) {
                  if (state is VerifyLoading) {
                    Utils.showLoading();
                  }else if(state is VerifySuccess){
                    Utils.hideLoading();
                    RouteService.popToRootPage();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
                  child: DatingButton.darkButton("Verify", true, doVerifyVideo),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
                child: DatingButton.darkButton("Cancel", true, doCancel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  doVerifyVideo() async {
    // _cubit.uploadFile(widget.filePath);
    // upload video init state
    // verifi call video
  }

  doCancel() async {
    RouteService.pop();
  }

// final firebaseStorage = FirebaseStorage.instance;
// Future<void> _uploadFile(String filePath) async {
//   Reference ref = firebaseStorage.ref().child(filePath);
//   await ref.putFile(File(filePath));
//   String url = await ref.getDownloadURL();
//   if (url.isNotEmpty) {
//     _verifyVideo(url);
//   }
//   debugPrint("URL DOWNLOAD : $url");
// }
//
// Future<void> _verifyVideo(String videoUrl) async {
//   // call video verify
//   AuthVerify verify = await RequestApi().verifyPhotos(videoUrl);
//
//   if (true) {
//     debugPrint("verify success");
//     Fluttertoast.showToast(msg: "Verify Success", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 3);
//   } else {
//     debugPrint("verify failed");
//     Fluttertoast.showToast(msg: "Verify Failed", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 3);
//   }
// }
}
