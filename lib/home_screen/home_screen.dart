import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_editing/common/widget/rotate_widget.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum ImageType { network, asset, file, memory }

class _HomeScreenState extends State<HomeScreen> {
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
            Container(
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
                  // RotateScreen(
                  //   imageType: ImageType.asset,
                  //   imageName: 'assets/images/slide_1.jpeg',
                  //   notifier: ValueNotifier(Matrix4.identity()),
                  // ),
                  // RotateScreen(
                  //   imageType: ImageType.network,
                  //   imageName: 'https://picsum.photos/id/117/1544/1024',
                  //   notifier: ValueNotifier(Matrix4.identity()),
                  // ),
                ],
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

  void saveImage() {}
}
