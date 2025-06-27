import 'dart:math';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';

class CameraPage extends BasePage {
  const CameraPage({super.key, required super.title, required super.author});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends BasePageState<CameraPage> {
  late CameraController _controller;
  bool _isCameraReady = false;

  @override
  onLoad() {
    _initializeCamera();
  }

  @override
  void onUnload() {
    _controller.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();

      /// 匹配后置摄像头
      final camera = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back);

      /// ResolutionPreset 设置拍照画面的质量
      _controller = CameraController(camera, ResolutionPreset.high, enableAudio: false);
      await _controller.initialize();
      setState(() => _isCameraReady = true);
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
    }
  }

  Future<String?> _takePhoto() async {
    if (!_isCameraReady) return null;
    final file = await _controller.takePicture();

    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      color: Colors.black,
      child: Stack(
        children: [
          _isCameraReady
              ? Positioned.fill(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: CameraPreview(_controller),
                ),
              )
              : const SizedBox(),

          /// 自定义身份证辅助框
          Positioned.fill(child: CustomPaint(painter: IDCardOverlayPainter())),

          /// 拍照按钮
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: () async {
                  final path = await _takePhoto();
                  if (path != null) {
                    Get.back(result: path);
                  }
                },
                child: const Icon(Icons.camera),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IDCardOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    /// 绘制边框
    final paint =
        Paint()
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..color = const Color(0xFF3AC786);

    final height = size.width * 0.75;
    final width = height / 0.63;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      height: width,
      width: height,
    );
    canvas.drawRect(rect, paint);

    /// 旋转 Canvas 坐标系
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.save();
    canvas.rotate(pi / 2);

    /// 绘制提示文本
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: const TextSpan(
        text: '请见身份证放入框内拍摄',
        style: TextStyle(fontSize: 26, color: Color(0x993AC786)),
      ),
    );

    textPainter.layout();
    final textWidth = textPainter.width;
    final textHeight = textPainter.height;
    textPainter.paint(canvas, Offset(textWidth / 2 * -1, textHeight / 2 * -1));

    /// 回复 Canvas 坐标系
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
