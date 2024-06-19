import 'package:camera/camera.dart';
import 'package:dating_app/src/modules/verify/screens/video_preview_page.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../general/constants/app_constants.dart';

class GetYouVerifiedPage extends StatefulWidget {
  const GetYouVerifiedPage({super.key});

  @override
  State<GetYouVerifiedPage> createState() => _GetYouVerifiedPageState();
}

class _GetYouVerifiedPageState extends State<GetYouVerifiedPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          width: 40/375*AppConstants.width,
          height: 40,
          color: Colors.transparent,
          child: const Icon(
            Icons.close_rounded,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        color: Colors.white,
        child: SingleChildScrollView(
            child: _isLoading
                ? Container(
                    color: Colors.white,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Center(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CameraPreview(_cameraController),
                        Padding(
                          padding: EdgeInsets.all(ThemeDimen.paddingBig),
                          child: FloatingActionButton(
                            backgroundColor: Colors.red,
                            child: Icon(_isRecording ? Icons.stop : Icons.circle),
                            onPressed: () => _recordVideo(),
                          ),
                        )
                      ],
                    ),
                  )),
      ),
    );
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
      Navigator.push(Get.context!, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }
}
