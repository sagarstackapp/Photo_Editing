import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_editing/common/widget/rotate_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum ImageType { network, asset, file, memory }

class _HomeScreenState extends State<HomeScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  final ImagePicker imagePicker = ImagePicker();
  List<Widget> uploadedImage = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Image Editing')),
      body: SafeArea(
        child: ListView(
          primary: false,
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/background_eraser.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: [
                    RotateScreen(notifier: ValueNotifier(Matrix4.identity())),
                    ...uploadedImage,
                  ],
                ),
              ),
            ),
            Row(
              children: [
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: selectImage,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Select Image'),
                ),
                const Spacer(),
                if (uploadedImage.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: saveImage,
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('Download Image'),
                  ),
                if (uploadedImage.isNotEmpty) const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void selectImage() async {
    XFile galleryImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (galleryImage != null) {
      File profileImage = File(galleryImage.path);
      uploadedImage.add(
        RotateScreen(
          imageType: ImageType.file,
          fileName: profileImage,
          notifier: ValueNotifier(Matrix4.identity()),
        ),
      );
      setState(() {});
    }
  }

  saveImage() async {
    await screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((Uint8List image) async {
      final status = await Permission.storage.request();
      if (image != null && status.isGranted) {
        final imagePath = Platform.isIOS
            ? await getApplicationDocumentsDirectory()
            : await Directory('/storage/emulated/0/Photo Edit/')
                .create(recursive: true);
        String imagePaths =
            imagePath.path + 'PhotoEdit${DateTime.now().toIso8601String()}.png';
        log('Image Paths --> $imagePaths');
        File file2 = File(imagePaths);
        file2.writeAsBytesSync(image);
      }
    });
  }
}
