import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:dating_app/src/components/widgets/dating_button.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_convert.dart';
import 'package:dating_app/src/requests/auth_services.dart';
import 'package:dating_app/src/utils/change_notifiers/verify_account_notifier.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';
import '../../../data/datasource/verify/verify_datasource.dart';
import 'package:image/image.dart' as imglib;
import 'detector_view.dart';

class LetYouVerified extends StatefulWidget {
  const LetYouVerified({
    super.key,
  });

  @override
  State<LetYouVerified> createState() => _LetYouVerifiedState();
}

class _LetYouVerifiedState extends State<LetYouVerified> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );
  String _text = S.current.let_verified_notice;
  var _cameraLensDirection = CameraLensDirection.front;

  bool startVerify = false;
  File? detectImageFile;
  bool canPop = true;
  bool isChecking = false;
  bool isDone = false;

  VerifyDataSource verifyDataSource = VerifyDataSource();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          body: Stack(
        fit: StackFit.expand,
        children: [
          _faceOval(),
          _colorFiltered(),
          _textVerified(),
          //_positionText(),
          if (canPop) _positionIcon(),
          _alignBtn(),
          _alignColorFilterBorder(),
        ],
      )),
    );
  }

  Widget _faceOval() {
    return detectImageFile != null
        ? Stack(
            children: [
              Center(
                child: Container(
                    color: Colors.transparent,
                    child: Image.file(detectImageFile!, fit: BoxFit.cover,),),
              ),
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  color: Colors.deepPurple.withOpacity(0.39),
                ),
              ),
            ],
          )
        : DetectorView(
            title: S.current.txt_face_detector,
            customPaint: null,
            text: _text,
            onImage: processImage,
            initialCameraLensDirection: _cameraLensDirection,
            onCameraLensDirectionChanged: (value) =>
                _cameraLensDirection = value,
          );
  }

  Widget _colorFiltered() => ColorFiltered(
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.srcOut),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode
                      .dstOut), // This one will handle background + difference out
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 400,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.all(Radius.elliptical(200, 250)),
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _textVerified() => Padding(
        padding: EdgeInsets.fromLTRB(16, Get.height / 1.5, 16, 0),
        child: Center(
          child: AutoSizeText(
            _text,
            style: ThemeUtils.getTextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );

  Widget _positionIcon() => Positioned(
        top: 60,
        left: 16,
        child: InkWell(
          onTap: () async {
            if (!canPop) {
              return;
            }
            await RouteService.pop();
          },
          child: const Icon(
            Icons.close_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
      );

  Widget _alignBtn() => !startVerify
      ? Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.all(ThemeDimen.paddingNormal),
            width: double.infinity,
            height: 40,
            child: DatingButton.darkButton(
                S.current.i_am_ready.toCapitalized, true, () async {
              setState(() {
                startVerify = true;
                setState(() {
                  _text = '';
                });
              });
            }),
          ),
        )
      : const SizedBox();

  Widget _alignColorFilterBorder() => Align(
        alignment: Alignment.center,
        child: Container(
          height: 400,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.elliptical(200, 250)),
            border: Border.all(
              color: Colors.red,
              width: 2,
            ),
          ),
        ),
      );

  String textVerify(int i) {
    switch (i) {
      case 0:
        return S.current.txt_please_keep_ur_face;
      case 1:
        return S.current.txt_let_put_ur_face_oval;
      case 2:
        return S.current.txt_move_ur_face;
      default:
        return S.current.txt_prepare_auth;
    }
  }

  Future processImage(final InputImage inputImage) async {
    if (startVerify) {
      if (isChecking) return;
      isChecking = true;

      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isNotEmpty && inputImage.bytes != null) {
        for (var face in faces) {
          if (checkFullFace(face) && !isDone) {
            isDone = true;

            final image = Convert.decodeYUV420SP(inputImage);

            String fileName = "HL_${DateTime.now().millisecondsSinceEpoch}";
            final orientedImage = imglib.flipHorizontal(image);
            final file = await File('${await _getTempPath()}/$fileName')
                .writeAsBytes(imglib.encodeJpg(orientedImage));

            setState(() {
              detectImageFile = file;
              canPop = false;
              _text = S.current.txt_processing;
              _faceDetector.close();
            });

            await sendVerifyImage(file);

            await RouteService.pop();
          } else {
            isChecking = false;
          }
        }
        isChecking = false;
      } else {
        isChecking = false;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> sendVerifyImage(File file) async {
    final lastStatus = PrefAssist.getMyCustomer().verified;
    VerifyAccountNotifier.shared.updateStatus(Const.kVerifyAccountPending);

    final url = await AuthServices()
        .uploadMedia(file, FireStorePathType.profiles, ProfilePathType.verify);
    if (mounted) {
      setState(() {
        _text = S.current.txt_scan_success;
      });
    }
    Utils.toast(S.current.txt_we_reviewing_ur_photo);
    if (url != null) {
      final status = await verifyDataSource.verifyPhotos([url]);
      if (!status) {
        VerifyAccountNotifier.shared.updateStatus(lastStatus);
      }
      debugPrint('send api verify status: $status');
    }
  }

  Future<String> _getTempPath() async {
    final tempPath = (await getTemporaryDirectory()).path;
    return tempPath;
  }

  bool checkFullFace(Face face) {
    final leftEye = face.landmarks[FaceLandmarkType.leftEye];
    final rightEye = face.landmarks[FaceLandmarkType.rightEye];
    final leftMouth = face.landmarks[FaceLandmarkType.leftMouth];
    final rightMouth = face.landmarks[FaceLandmarkType.rightMouth];
    final bottomMouth = face.landmarks[FaceLandmarkType.bottomMouth];
    final leftCheek = face.landmarks[FaceLandmarkType.leftCheek];
    final rightCheek = face.landmarks[FaceLandmarkType.rightCheek];
    final noseBase = face.landmarks[FaceLandmarkType.noseBase];
    return (leftEye != null &&
        rightEye != null &&
        leftMouth != null &&
        rightMouth != null &&
        bottomMouth != null &&
        leftCheek != null &&
        rightCheek != null &&
        noseBase != null);
  }
}
