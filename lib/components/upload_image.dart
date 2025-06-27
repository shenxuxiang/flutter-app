import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/utils/picker_image.dart';
import 'package:qm_agricultural_machinery_services/entity/response_data.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart' show queryUploadImage;
import 'package:qm_agricultural_machinery_services/utils/utils.dart'
    show generateUniqueString, getNetworkAssetURL, printLog;

/// 如果是后端返回的回显数据，url 必传，可以不传 image
/// 如果是用户上传行为，则 image 必传
class ImageData {
  String? url;
  final String id;
  final File? image;

  ImageData({this.image, this.url, required this.id})
    : assert(
        image != null || url != null,
        'url and image parameters cannot be empty at the same time',
      );
}

class UploadImage extends StatefulWidget {
  final int? maxFiles;
  final bool disabled;
  final List<ImageData> imageList;
  final void Function(List<ImageData> imageList)? onChanged;

  const UploadImage({
    super.key,
    this.maxFiles,
    this.onChanged,
    this.disabled = false,
    required this.imageList,
  });

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  @override
  initState() {
    super.initState();
  }

  handleAddImage(ImageSource type) async {
    final ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: type,
      // 拍照时压缩 50%
      imageQuality: type == ImageSource.camera ? 50 : 100,
    );
    if (file == null) return;

    final image = await File(file.path).create();

    widget.imageList.add(ImageData(image: image, id: generateUniqueString()));

    widget.onChanged?.call(widget.imageList);
  }

  _handleOpenModal() async {
    if (widget.disabled) return;

    FocusScope.of(context).unfocus();
    final image = await pickerImage();

    if (image == null) return;

    widget.imageList.add(ImageData(image: image, id: generateUniqueString()));

    widget.onChanged?.call(widget.imageList);
  }

  handleDeleteImage(ImageData source) {
    widget.imageList.remove(source);
    widget.onChanged?.call(widget.imageList);
  }

  handleUploadSuccess({required ImageData source, required ResponseData response}) {
    if (widget.imageList.contains(source)) {
      source.url = response.data['path'];
      widget.onChanged?.call(widget.imageList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          ...[
            for (ImageData item in widget.imageList)
              _RenderImage(
                source: item,
                disabled: widget.disabled,
                onDelete: handleDeleteImage,
                onCompleted: handleUploadSuccess,
              ),
          ],
          (widget.maxFiles ?? double.infinity) > widget.imageList.length
              ? GestureDetector(
                onTap: _handleOpenModal,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    border: Border.all(
                      color: widget.disabled ? const Color(0xFFE8E8E8) : const Color(0xFFCCCCCC),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Icon(
                    QmIcons.plus,
                    size: 36,
                    color: widget.disabled ? const Color(0xFFDDDDDD) : const Color(0xFF999999),
                  ),
                ),
              )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class _RenderImage extends StatefulWidget {
  final bool disabled;
  final ImageData source;
  final void Function(ImageData source) onDelete;
  final void Function({required ImageData source, required ResponseData response}) onCompleted;

  const _RenderImage({
    super.key,
    required this.source,
    this.disabled = false,
    required this.onDelete,
    required this.onCompleted,
  });

  @override
  State<_RenderImage> createState() => _RenderImageState();
}

class _RenderImageState extends State<_RenderImage> {
  bool _loading = false;

  @override
  void initState() {
    if (widget.source.image != null) handleUploadImage(widget.source.image!);
    super.initState();
  }

  handleUploadImage(File image) async {
    setState(() => _loading = true);
    final params = FormData.fromMap({'file': await MultipartFile.fromFile(image.path)});

    try {
      final resp = await queryUploadImage(query: params);

      /// 如果组件已经卸载,就不执行后续的逻辑
      if (!mounted) return;
      widget.onCompleted(source: widget.source, response: resp);
    } catch (error, stack) {
      /// 如果组件已经卸载,就不执行后续的逻辑
      if (!mounted) return;
      printLog(error);
      printLog(stack);
      Toast.show('文件上传失败');
      widget.onDelete(widget.source);
    }

    setState(() => _loading = false);
  }

  handleOpenModal() {
    if (widget.source.url == null) return;
    final opacity = Rx<double>(0);
    Future.delayed(const Duration(milliseconds: 20), () => opacity.value = 1);
    showDialog(
      context: context,
      useSafeArea: false,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Obx(
          () => AnimatedOpacity(
            curve: Curves.ease,
            opacity: opacity.value,
            duration: const Duration(milliseconds: 200),
            child: Stack(
              children: [
                Container(color: Colors.black),
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: InteractiveViewer(
                      child:
                          widget.source.image == null
                              ? CachedNetworkImage(
                                fit: BoxFit.contain,
                                imageUrl: getNetworkAssetURL(widget.source.url!),
                              )
                              : Image.file(widget.source.image!, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleOpenModal,
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          border: _loading ? null : Border.all(color: const Color(0xFFCCCCCC)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image:
                widget.source.image != null
                    ? FileImage(widget.source.image!)
                    : CachedNetworkImageProvider(getNetworkAssetURL(widget.source.url!)),
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _loading
                ? Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: const Align(
                    widthFactor: 1,
                    heightFactor: 1,
                    child: CircularProgressIndicator(
                      strokeCap: StrokeCap.round,
                      valueColor: AlwaysStoppedAnimation(Color(0xFFE0E0E0)),
                    ),
                  ),
                )
                : const SizedBox(),
            widget.disabled
                ? const SizedBox.shrink()
                : Positioned(
                  top: -10,
                  right: -10,
                  child: GestureDetector(
                    onTap: () {
                      widget.onDelete(widget.source);
                    },
                    child: Container(
                      // color 是多余的,但不这样写总是很难触发 ontap 事件
                      // 即使使用了 padding 增大接触面积也不行
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(bottom: 12, left: 12),
                      child: Icon(QmIcons.closeRoundFill, size: 20, color: const Color(0xFF999999)),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
