import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/components/button_group.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/models/measure_land.dart';
import 'package:qm_agricultural_machinery_services/utils/event_bus.dart';
import '../../utils/alert.dart';
import 'constant.dart';
import 'panel_1.dart';
import 'panel_2.dart';
import 'panel_3.dart';
import 'package:get/get.dart';

class MeasureLandPage extends BasePage {
  const MeasureLandPage({super.key, required super.title, required super.author});

  @override
  State<MeasureLandPage> createState() => _MeasureLandPageState();
}

class _MeasureLandPageState extends BasePageState<MeasureLandPage> {
  final measureLandModel = Get.find<MeasureLandModel>();
  final pageController = PageController();
  final buttonGroupOptions = const [
    ButtonGroupOption(value: '1', label: '绕地模式'),
    ButtonGroupOption(value: '2', label: '定点模式'),
    ButtonGroupOption(value: '3', label: '点选模式'),
  ];

  int tabIndex = 0;

  @override
  void onLoad() {
    tabIndex = 0;
    super.onLoad();
  }

  @override
  void onUnload() {
    pageController.dispose();
    super.onUnload();
  }

  handleButtonGroupChanged(int tabKey) async {
    final oldIndex = tabIndex;
    if (measureLandModel.canPop.value) {
      setState(() => tabIndex = tabKey);
      pageController.animateToPage(
        tabKey,
        curve: Curves.ease,
        duration: const Duration(milliseconds: 10),
      );
    } else {
      setState(() => tabIndex = tabKey);
      await Future.delayed(const Duration(milliseconds: 20));
      setState(() => tabIndex = oldIndex);
      Alert.confirm(title: '正在测量中，不能切换模式！', barrierDismissible: true);
    }
  }

  handleNavigateBack() async {
    if (measureLandModel.canPop.value) {
      Get.back();
    } else {
      handleListenNavBack();
    }
  }

  /// 对返回按钮进行监听
  handleListenNavBack() {
    Alert.confirm(
      builder: (BuildContext context, close) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              width: constraints.maxWidth,
              padding: EdgeInsets.fromLTRB(18.w, 36.w, 18.w, 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '确定要退出吗？',
                    style: TextStyle(
                      height: 1,
                      fontSize: 18.sp,
                      color: const Color(0xFF333333),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.w),
                  Text(
                    '退出后测量数据将无法恢复',
                    style: TextStyle(height: 1, fontSize: 15.sp, color: const Color(0xFF333333)),
                  ),
                ],
              ),
            );
          },
        );
      },
      cancelText: '取消',
      confirmText: '确定',
      onConfirm: () async {
        eventBus.emit(navBackEvent);
        await Future.delayed(const Duration(milliseconds: 100));
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        if (!didPop) {
          if (measureLandModel.canPop.value) {
            await Future.delayed(const Duration(milliseconds: 100));
            Get.back();
          } else {
            handleListenNavBack();
          }
        }
      },
      child: PageWidget(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: HeaderNavBar(title: widget.title, onBack: handleNavigateBack),
          body: Stack(
            alignment: Alignment.topLeft,
            children: [
              Positioned.fill(
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [const Panel1(), const Panel2(), const Panel3()],
                ),
              ),
              Positioned(
                top: 12.w,
                left: 12.w,
                width: 336.w,
                height: 28.w,
                child: ButtonGroup(
                  onChanged: handleButtonGroupChanged,
                  options: buttonGroupOptions,
                  index: tabIndex,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
