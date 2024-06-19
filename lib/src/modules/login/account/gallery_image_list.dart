import 'package:dating_app/src/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/services/navigator/route_service.dart';

class GalleryList extends StatefulWidget {
  const GalleryList({Key? key}) : super(key: key);

  @override
  State<GalleryList> createState() => _GalleryListState();
}

class _GalleryListState extends State<GalleryList> {
  late String fileName;
  late String filePath;
  late Map<String, String> mapPaths;
  late List<String> fileExtensions;
  bool isLoadingFilePath = false;
  bool isMultipleFilePick = false;
  late FileType fileType;
  late FilePickerResult filePickerResult;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            S.current.txtid_gallery,
            style: ThemeUtils.getTitleStyle(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () => RouteService.pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          )),
      body: Container(),
    );
  }

  final picker = ImagePicker();

  Future getImage(int index) async {
    final image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      // _images[index] = File(image!.path);
    });
  }

  Future<void> _pickFileFromGallery() async {
    setState(() {
      isLoadingFilePath = true;
    });

    try {
      if (isMultipleFilePick) {
        filePath = "";
        // filePickerResult = (await FilePicker().pickFiles(
        //     type: fileType ? fileType : FileType.any,
        //     allowCompression: fileExtensions))!;
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
//https://newbycoder.com/flutter/file_picker
