import 'page_item.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/keep_alive.dart';
import 'package:qm_agricultural_machinery_services/components/button_group.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';

class PolicyInformationPage extends BasePage {
  const PolicyInformationPage({super.key, required super.author, required super.title});

  @override
  State<PolicyInformationPage> createState() => _PolicyInformationPageState();
}

class _PolicyInformationPageState extends BasePageState<PolicyInformationPage> {
  int _tabIndex = 0;
  late final PageController _pageController;
  final _buttonList = [
    const ButtonGroupOption(value: '', label: '全部'),
    const ButtonGroupOption(value: '1', label: '新闻资讯'),
    const ButtonGroupOption(value: '2', label: '政策法规'),
  ];

  @override
  void initState() {
    _tabIndex = int.parse(Get.parameters['tab'] ?? '0');
    _pageController = PageController(initialPage: _tabIndex);
    super.initState();
  }

  handleButtonChange(int index) {
    setState(() {
      _tabIndex = index;
    });

    _pageController.animateToPage(
      index,
      curve: Curves.ease,
      duration: const Duration(milliseconds: 200),
    );
  }

  handlePageChange(int index) {
    if (index == _tabIndex) return;
    setState(() {
      _tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(
          title: widget.title,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(44.w),
            child: Container(
              height: 44.w,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
              child: ButtonGroup(
                onChanged: handleButtonChange,
                options: _buttonList,
                index: _tabIndex,
              ),
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: handlePageChange,
          children: [
            for (final item in _buttonList) KeepAliveWidget(child: PageItem(type: item.value)),
          ],
        ),
      ),
    );
  }
}
