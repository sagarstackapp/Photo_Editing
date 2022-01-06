import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_editing/home_screen/home_screen.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class RotateScreen extends StatelessWidget {
  final ValueNotifier<Matrix4> notifier;
  final String imageName;
  final File fileName;
  final Uint8List bytes;
  final ImageType imageType;

  const RotateScreen(
      {Key key,
      this.notifier,
      this.imageName,
      this.imageType,
      this.fileName,
      this.bytes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MatrixGestureDetector(
      onMatrixUpdate: (m, tm, sm, rm) {
        notifier.value = m;
      },
      child: AnimatedBuilder(
        animation: notifier,
        builder: (ctx, child) {
          return Transform(
            transform: notifier.value,
            child: imageType == ImageType.asset
                ? Image.asset(
                    imageName,
                    height: size.height / 2,
                    width: double.infinity,
                  )
                : imageType == ImageType.network
                    ? Image.network(
                        imageName,
                        height: size.height / 2,
                        width: double.infinity,
                      )
                    : imageType == ImageType.file
                        ? Image.file(
                            fileName,
                            height: size.height / 2,
                            width: double.infinity,
                          )
                        : imageType == ImageType.memory
                            ? Image.memory(
                                bytes,
                                height: size.height / 2,
                                width: double.infinity,
                              )
                            : Container(
                                color: Colors.blueGrey,
                                height: size.height / 2,
                                width: double.infinity,
                              ),
          );
        },
      ),
    );
  }
}
