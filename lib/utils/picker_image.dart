import 'dart:io';
import 'dart:async';
import 'bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'utils.dart' show compressImage, printLog;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

/// 选择图像
Future<File?> pickerImageHandle(ImageSource type) async {
  final ImagePicker picker = ImagePicker();
  XFile? file = await picker.pickImage(source: type);

  if (file == null) return null;
  // 存储文件到手机相册
  if (type == ImageSource.camera) ImageGallerySaverPlus.saveImage(await file.readAsBytes());
  return compressImage(file.path, quality: type == ImageSource.camera ? 50 : 80);
}

/// 展示 BottomSheet 弹框
Future<String?> showPickImageSheet() async {
  final Completer<String?> completer = Completer();

  QmBottomSheet.showSimpleSheet(
    builder: (BuildContext context, Future<void> Function() onClose) {
      final primaryColor = Theme.of(context).primaryColor;
      return SizedBox(
        width: 336,
        height: 148.5,
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                await onClose();
                completer.complete('camera');
              },
              child: Container(
                width: 336,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                  boxShadow: [
                    BoxShadow(blurRadius: 5.33, color: Color(0xFFF1FBF5), offset: Offset(0, 0.67)),
                  ],
                ),
                child: Text('拍照', style: TextStyle(fontSize: 16, color: primaryColor)),
              ),
            ),
            const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFE0E0E0)),
            GestureDetector(
              onTap: () async {
                await onClose();
                completer.complete('gallery');
              },
              child: Container(
                width: 336,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                  boxShadow: [
                    BoxShadow(blurRadius: 5.33, color: Color(0xFFF1FBF5), offset: Offset(0, 0.67)),
                  ],
                ),
                child: Text('从相册中选择', style: TextStyle(fontSize: 16, color: primaryColor)),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onClose,
              child: Container(
                width: 336,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: const [
                    BoxShadow(blurRadius: 5.33, offset: Offset(0, 0.67), color: Color(0xFFF1FBF5)),
                  ],
                ),
                child: Text('取消', style: TextStyle(fontSize: 16, color: primaryColor)),
              ),
            ),
          ],
        ),
      );
    },
  );

  return completer.future;
}

/// 综合 showPickImageSheet + pickerImageHandle
Future<File?> pickerImage() async {
  try {
    final type = await showPickImageSheet();
    if (type == 'camera') {
      return pickerImageHandle(ImageSource.camera);
    } else if (type == 'gallery') {
      return pickerImageHandle(ImageSource.gallery);
    }
    return null;
  } catch (error, stack) {
    printLog(error);
    printLog(stack);
    return null;
  }
}
