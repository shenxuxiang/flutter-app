import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/components/image.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart' show getNetworkAssetURL;

class EmbedBuilderImage extends EmbedBuilder {
  @override
  final String key = 'image';

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    String imageUrl = embedContext.node.value.data;
    // if (!imageUrl.startsWith('http')) imageUrl = getNetworkAssetURL(imageUrl);
    // return CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.contain);
    return ImageWidget(image: imageUrl, fit: BoxFit.contain);
  }
}

class RichTextEditor extends StatefulWidget {
  final String value;
  final bool readOnly;

  const RichTextEditor({super.key, this.readOnly = true, required this.value});

  @override
  State<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  final QuillController _controller = QuillController.basic();

  @override
  void initState() {
    _controller.readOnly = widget.readOnly;

    dynamic content = jsonDecode(widget.value);
    _controller.document = Document.fromJson(content['ops']);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QuillEditor.basic(
      controller: _controller,
      config: QuillEditorConfig(
        showCursor: !widget.readOnly,
        disableClipboard: widget.readOnly,
        enableInteractiveSelection: false,
        embedBuilders: [EmbedBuilderImage()],
        customStyles: DefaultStyles(
          paragraph: DefaultTextBlockStyle(
            TextStyle(height: 1, fontSize: 14.sp, color: Colors.black87),
            HorizontalSpacing.zero,
            VerticalSpacing(3.5.w, 3.5.w),
            VerticalSpacing.zero,
            null,
          ),
          h1: DefaultTextBlockStyle(
            TextStyle(fontSize: 22.sp, color: Colors.black, fontWeight: FontWeight.bold),
            HorizontalSpacing.zero,
            VerticalSpacing(5.5.w, 5.5.w),
            VerticalSpacing.zero,
            null,
          ),
          h2: DefaultTextBlockStyle(
            TextStyle(fontSize: 20.sp, color: Colors.black, fontWeight: FontWeight.bold),
            HorizontalSpacing.zero,
            VerticalSpacing(5.w, 5.w),
            VerticalSpacing.zero,
            null,
          ),
          h3: DefaultTextBlockStyle(
            TextStyle(fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.bold),
            HorizontalSpacing.zero,
            VerticalSpacing(4.5.w, 4.5.w),
            VerticalSpacing.zero,
            null,
          ),
          h4: DefaultTextBlockStyle(
            TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.bold),
            HorizontalSpacing.zero,
            VerticalSpacing(4.w, 4.w),
            VerticalSpacing.zero,
            null,
          ),
          lists: DefaultListBlockStyle(
            TextStyle(height: 1.25, fontSize: 14.sp, color: Colors.black87),
            HorizontalSpacing.zero,
            VerticalSpacing(2.w, 2.w),
            VerticalSpacing.zero,
            null,
            null,
          ),
        ),
      ),
    );
  }
}
