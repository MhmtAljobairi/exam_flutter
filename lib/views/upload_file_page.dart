import 'dart:io';
import 'package:exam_project_flutter/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class UploadFilePage extends StatefulWidget {
  const UploadFilePage({super.key});

  @override
  State<UploadFilePage> createState() => _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  File? _file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Image")),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _file != null
                ? Image.file(
                    _file!,
                    width: 150,
                    height: 150,
                  )
                : Container(),
            ElevatedButton(
                onPressed: () {
                  _handleShowOptions();
                },
                child: Text("Choose an image"))
          ],
        ),
      ),
    );
  }

  _handleShowOptions() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              padding: const EdgeInsets.all(12.0),
              height: 170,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Choose your method",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    ListTile(
                      onTap: () {
                        handleGetImageAction(ImageSource.gallery);
                      },
                      leading: const Icon(Icons.image),
                      title: const Text("Gallery"),
                    ),
                    ListTile(
                      onTap: () {
                        handleGetImageAction(ImageSource.camera);
                      },
                      leading: const Icon(Icons.camera),
                      title: const Text("Camera"),
                    )
                  ]),
            ));
  }

  handleGetImageAction(ImageSource selectedSource) async {
    if (Platform.isAndroid || Platform.isIOS) {
      ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: selectedSource);
      Navigator.pop(context);
      setState(() {
        _file = File(image!.path);
      });
      EasyLoading.show(status: "Loading");
      UserController().uploadImage(File(image!.path)).then((value) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess(value);
      }).catchError((ex) {
        EasyLoading.dismiss();
        EasyLoading.showError(ex.toString());
      });
    } else {
      EasyLoading.showError("Not Supported");
    }
  }
}
