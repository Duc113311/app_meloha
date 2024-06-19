import 'package:camera/camera.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/verify/screens/video_preview_page.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class SelfieVerifiedStep1 extends StatefulWidget {
  const SelfieVerifiedStep1({super.key});

  @override
  State<SelfieVerifiedStep1> createState() => _SelfieVerifiedStep1State();
}

class _SelfieVerifiedStep1State extends State<SelfieVerifiedStep1> with TickerProviderStateMixin {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;

  // Video demo sample
  final String sampleVideo =
      "https://firebasestorage.googleapis.com/v0/b/heartlink-dating-project.appspot.com/o/dating%2F190355755526304958.mp4?alt=media&token=cf07dd28-4175-467b-a838-c9274c54be24";
  late VideoPlayerController _videoPlayerController;

  // countdown timmer
  AnimationController? _animationController;
  int levelClock = 15;

  @override
  void initState() {
    super.initState();
    _loadVideoSample();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _videoPlayerController.dispose();
    _videoPlayerController.pause();
    _animationController?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
      final route = MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => VideoPreviewPage(
                filePath: file.path,
              ));
      Navigator.push(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  Future _loadVideoSample() async {
    _videoPlayerController = VideoPlayerController.asset(AppImages.gif)..addListener(() {setState(() {

    });})..setLooping(true)..initialize().then((_) => _videoPlayerController.play());

    // _videoPlayerController.addListener(() {
    //   setState(() {});
    // });
    // _videoPlayerController.initialize().then((value) async{
    //  setState(() {
    //    _videoPlayerController.setLooping(true);
    //    _videoPlayerController.play();
    //  });
    // });
  }

  // _initAnimation() {
  //   _animationController = AnimationController(
  //       vsync: this, duration: Duration(seconds: levelClock));
  //   _animationController?.forward();
  //   debugPrint(_animationController?.value.toString());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.all(0),
              child: _isLoading
                  ? Container(
                      color: Colors.white,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Center(
                      child: CameraPreview(_cameraController),
                    )),
          Padding(
            padding: EdgeInsets.only(top: Get.height / 16, left: 10),
            child: InkWell(
              onTap: () {
                RouteService.pop();
              },
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          // timmer
          // _isRecording
          //     ? Align(
          //         alignment: Alignment.topCenter,
          //         child: Padding(
          //           padding: EdgeInsets.only(top: ThemeDimen.paddingBig),
          //           child: Countdown(
          //               animation: StepTween(begin: levelClock, end: 0)
          //                   .animate(_animationController!)),
          //         ),
          //       )
          //     : Container(),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: Get.height / 16, right: 20),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.transparent,
                child:
                AspectRatio(aspectRatio: _videoPlayerController.value.aspectRatio, child: VideoPlayer(_videoPlayerController)),
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(ThemeDimen.paddingNormal),
                width: 40,
                height: 40,
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Icon(_isRecording ? Icons.stop : Icons.circle),
                  onPressed: () => _recordVideo(),
                ),
              ))
        ],
      ),
    );
  }
}

class Countdown extends AnimatedWidget {
  Countdown({super.key, required this.animation}) : super(listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText = '00 : ${clockTimer.inSeconds.remainder(8).toString().padLeft(2, '0')}';

    return Text(
      timerText,
      style: Theme.of(Get.context!).textTheme.displaySmall!.copyWith(color: Colors.red),
      textAlign: TextAlign.center,
    );
  }
}
