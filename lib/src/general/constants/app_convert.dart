import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as imglib;
import 'package:intl/intl.dart';

class Convert {
  static String? convertTempDate(int timeInMillis, String? style) {
    var date = DateTime.fromMicrosecondsSinceEpoch(timeInMillis * 1000000);
    var formattedDate = DateFormat(style, 'vi').format(date);
    return formattedDate;
  }

  static String? convertTempDate2(int timeInMillis, String? style) {
    var date = DateTime.fromMicrosecondsSinceEpoch(timeInMillis * 1000);
    var formattedDate = DateFormat(style, 'vi').format(date);
    return formattedDate;
  }

  static String? convertDateTime(DateTime? value, String? style) {
    var convertTime = DateFormat(style, 'vi').format(value!).toString();
    return convertTime;
  }

  // static String? convertDateTime2(DateTime? value, String? style) {
  //   DateFormat dateFormat;
  //   dateFormat =  DateFormat.yMMMMEEEEd('vi');
  //   var convertTime = dateFormat.format(value!);
  //
  //   return convertTime;
  // }

  static String? convertStringTime(String? timeString, String? style) {
    var inputFormat = DateFormat('MM/dd/yyyy HH:mm:ss');
    var inputDate = inputFormat.parse(timeString!);
    var convertTime = DateFormat(style).format(inputDate).toString();

    return convertTime;
  }

  static var f = NumberFormat("###.0#", "en_US");

  static List<int> convertImagetoPng(CameraImage image) {
    print('th1 ${DateTime?.now()}');
    try {
      imglib.Image? img;
      print('image.type: ${image.format.group}');
      if (image.format.group == ImageFormatGroup.yuv420) {
        print('th2 ${DateTime?.now()}');

        print('convertYUV420toImageColor');
        img = convertYUV420toImageColor(image);
      } else if (image.format.group == ImageFormatGroup.bgra8888) {
        print('_convertBGRA8888');
        img = convertBGRA8888(image);
      }
      print('th3 ${DateTime?.now()}');

      imglib.JpegEncoder jpegEncoder = imglib.JpegEncoder();
      print('th4 ${DateTime?.now()}');

      // Convert to png
      var jpeg = jpegEncoder.encode(img!);
      print('th5 ${DateTime?.now()}');

      return jpeg;
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:$e");
    }
    return [];
  }

  /// CameraImage BGRA8888 -> PNG
// Color
  static imglib.Image convertBGRA8888(CameraImage image) {
    return imglib.Image.fromBytes(
        width: image.width,
        height: image.height,
        bytes: image.planes[0].bytes.buffer,
        order: imglib.ChannelOrder.bgra);
  }

  /// CameraImage YUV420_888 -> PNG -> Image (compresion:0, filter: none)
// Black
//   imglib.Image _convertYUV420(CameraImage image) {
  static imglib.Image convertYUV420toImageColor(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int? uvPixelStride = image.planes[1].bytesPerPixel;

    print('image.width:${image.width}');
    print('image.height:${image.height}');
    const alpha255 = (0xFF << 24);

    // imgLib -> Image package from https://pub.dartlang.org/packages/image
    final img =
        imglib.Image(width: width, height: height); // Create Image buffer

    // Fill image buffer with plane[0] from YUV420_888
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex =
            uvPixelStride! * (x / 2).floor() + uvRowStride * (y / 2).floor();
        final int index = y * width + x;

        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        // Calculate pixel color
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        img.data?.setPixelRgb(x, y, r, g, b);
        // img.data[index] = alpha255 | (b << 16) | (g << 8) | r;
      }
    }
    return img;
  }

  //black
  static imglib.Image convertYUV420(CameraImage image) {
    var img = imglib.Image(
        width: image.width, height: image.height); // Create Image buffer

    Plane plane = image.planes[0];
    const int shift = (0xFF << 24);

    // Fill image buffer with plane[0] from YUV420_888
    for (int x = 0; x < image.width; x++) {
      for (int planeOffset = 0;
          planeOffset < image.height * image.width;
          planeOffset += image.width) {
        final pixelColor = plane.bytes[planeOffset + x];
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        // Calculate pixel color
        var newVal =
            shift | (pixelColor << 16) | (pixelColor << 8) | pixelColor;

        // img.data.[planeOffset + x] = newVal;
        img.data
            ?.setPixel(x, planeOffset ~/ image.width, imglib.ColorInt8(newVal));
      }
    }

    return img;
  }

  static imglib.Image decodeYUV420SP(
    InputImage image,
  ) {
    final width = image.metadata!.size.width.toInt();
    final height = image.metadata!.size.height.toInt();

    Uint8List yuv420sp = image.bytes!;
    var outImg =
        imglib.Image(width: width, height: height); // default numChannels is 3

    final int frameSize = width * height;

    for (int j = 0, yp = 0; j < height; j++) {
      int uvp = frameSize + (j >> 1) * width, u = 0, v = 0;
      for (int i = 0; i < width; i++, yp++) {
        int y = (0xff & yuv420sp[yp]) - 16;
        if (y < 0) y = 0;
        if ((i & 1) == 0) {
          v = (0xff & yuv420sp[uvp++]) - 128;
          u = (0xff & yuv420sp[uvp++]) - 128;
        }
        int y1192 = 1192 * y;
        int r = (y1192 + 1634 * v);
        int g = (y1192 - 833 * v - 400 * u);
        int b = (y1192 + 2066 * u);

        if (r < 0)
          r = 0;
        else if (r > 262143) r = 262143;
        if (g < 0)
          g = 0;
        else if (g > 262143) g = 262143;
        if (b < 0)
          b = 0;
        else if (b > 262143) b = 262143;

        outImg.setPixelRgb(i, j, ((r << 6) & 0xff0000) >> 16,
            ((g >> 2) & 0xff00) >> 8, (b >> 10) & 0xff);

        /*rgb[yp] = 0xff000000 |
            ((r << 6) & 0xff0000) |
            ((g >> 2) & 0xff00) |
            ((b >> 10) & 0xff);*/
      }
    }
    outImg = imglib.copyRotate(outImg, angle: -90);
    return outImg;
  }
}
