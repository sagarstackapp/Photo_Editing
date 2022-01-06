import 'package:flutter/material.dart';
import 'package:image_editing/common/widget/rotate_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum ImageType { network, asset, file, memory }

class _HomeScreenState extends State<HomeScreen> {
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
              decoration: const BoxDecoration(color: Colors.grey),
              child: Stack(
                children: [
                  RotateScreen(notifier: ValueNotifier(Matrix4.identity())),
                  RotateScreen(
                    imageType: ImageType.asset,
                    imageName: 'assets/images/slide_1.jpeg',
                    notifier: ValueNotifier(Matrix4.identity()),
                  ),
                  RotateScreen(
                    imageType: ImageType.network,
                    imageName: 'https://picsum.photos/id/117/1544/1024',
                    notifier: ValueNotifier(Matrix4.identity()),
                  ),
                  RotateScreen(
                    imageType: ImageType.network,
                    imageName: 'https://picsum.photos/id/118/1500/1000',
                    notifier: ValueNotifier(Matrix4.identity()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
