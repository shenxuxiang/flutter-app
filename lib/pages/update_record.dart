import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/api/app_version.dart' show queryAppVersionList;

class UpdateRecordPage extends BasePage {
  const UpdateRecordPage({super.key, required super.title, required super.author});

  @override
  State<UpdateRecordPage> createState() => _UpdateRecordPageState();
}

class _UpdateRecordPageState extends BasePageState<UpdateRecordPage> {
  final List<dynamic> _versionList = [];

  @override
  void initState() {
    queryAppVersionList({'clientType': '1'}).then((resp) {
      setState(() {
        _versionList.addAll(resp.data);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        appBar: HeaderNavBar(title: widget.title),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: CustomScrollView(
            slivers: [
              for (final item in _versionList)
                SliverToBoxAdapter(
                  child: RecordItem(version: item['version'], content: item['content']),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecordItem extends StatefulWidget {
  final String version;
  final String content;

  const RecordItem({super.key, required this.version, required this.content});

  @override
  State<RecordItem> createState() => _RecordItemState();
}

class _RecordItemState extends State<RecordItem> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.ease);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (_controller.status == AnimationStatus.dismissed) {
              _controller.forward();
            } else if (_controller.status == AnimationStatus.completed) {
              _controller.reverse();
            }
          },
          child: Container(
            height: 48.w,
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                MatrixTransition(
                  animation: _animation,
                  onTransform: (double value) {
                    return Matrix4Tween(
                      begin: Matrix4.rotationZ(pi / 180 * 270),
                      end: Matrix4.rotationZ(pi / 180 * 90),
                    ).lerp(value);
                  },
                  child: Icon(QmIcons.back),
                ),
                Text(
                  'V${widget.version} 版本',
                  style: TextStyle(height: 1, fontSize: 14.sp, color: const Color(0xFF4A4A4A)),
                ),
              ],
            ),
          ),
        ),
        const Divider(thickness: 0.5, height: 0.5, color: Color(0xFFE0E0E0)),
        SizeTransition(
          sizeFactor: _animation,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.w),
            child: Text(
              widget.content,
              style: TextStyle(height: 1.5, fontSize: 13.sp, color: const Color(0xFF999999)),
            ),
          ),
        ),
      ],
    );
  }
}
