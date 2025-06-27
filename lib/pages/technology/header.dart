import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/components/menu_list.dart';

final _menus =
    [
      {
        'title': '知识库',
        'icon': 'assets/images/technology/knowledge_base.png',
        'link': '/knowledge_base',
      },
      {
        'title': '农技视频',
        'icon': 'assets/images/technology/video.png',
        // 'icon': 'assets/images/disabled/video_disable.png',
      },
      {
        'title': '问答库',
        'icon': 'assets/images/technology/library.png',
        // 'icon': 'assets/images/disabled/answer_library_disable.png',
      },
      {
        'title': '专家问诊',
        'icon': 'assets/images/home/ic_home_expert.png',
        // 'icon': 'assets/images/disabled/expert_disable.png',
      },
    ].map((item) => MenuItemOption.fromJson(item)).toList();

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuListWidget(menus: _menus);
  }
}
