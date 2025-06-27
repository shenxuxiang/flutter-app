import 'dart:async';
import 'step_two.dart';
import 'time_line.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/models/home.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/models/publish.dart';
import 'package:qm_agricultural_machinery_services/components/badge.dart';
import 'package:qm_agricultural_machinery_services/entity/demand_category.dart';
import 'package:qm_agricultural_machinery_services/entity/demand_sub_category.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  late final StreamSubscription<int> subscriptionHomeTabKey;
  final publishModel = Get.find<PublishModel>();
  final homeModel = Get.find<HomeModel>();
  DemandCategory? _selectedTab;

  @override
  void initState() {
    // onLoad();
    _selectedTab = publishModel.demandCategoryList.value.first;
    subscriptionHomeTabKey = homeModel.tabKey.listen(listenHomeTabKeyChange);
    super.initState();
  }

  @override
  dispose() {
    subscriptionHomeTabKey.cancel();
    super.dispose();
  }

  listenHomeTabKeyChange(int homeTabKey) {
    if (homeTabKey == 2) onLoad();
  }

  onLoad() async {
    /// 获取需求大类
    final closeLoading = Loading.show();
    await publishModel.queryDemandSubcategoryTreeList();
    setState(() {
      _selectedTab = publishModel.demandCategoryList.value.first;
    });
    closeLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('发布需求'), scrolledUnderElevation: 0),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const TimeLine(step: 1),
          SizedBox(height: 20.w),
          Container(
            width: 336.w,
            height: 316.w,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: [
                Obx(
                  () => SizedBox(
                    width: 80.w,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (final it in publishModel.demandCategoryList.value)
                            GestureDetector(
                              onTap: () {
                                setState(() => _selectedTab = it);
                              },
                              child: Container(
                                width: 80.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color:
                                      _selectedTab == it ? const Color(0xFFFAFAFA) : Colors.white,
                                  border: Border(
                                    left: BorderSide(
                                      width: 2.w,
                                      color:
                                          _selectedTab == it
                                              ? const Color(0xFF3AC786)
                                              : Colors.white,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  it.demandName,
                                  style: TextStyle(
                                    height: 1,
                                    fontSize: 14.sp,
                                    color:
                                        _selectedTab == it
                                            ? const Color(0xFF3AC786)
                                            : const Color(0xFF333333),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 30.w, horizontal: 25.w),
                    height: 316.w,
                    color: const Color(0xFFFAFAFA),
                    child: Wrap(
                      direction: Axis.vertical,
                      spacing: 25.w,
                      runSpacing: 25.w,
                      children: [
                        for (DemandSubCategory item in _selectedTab?.children ?? [])
                          BadgeWidget(
                            title: item.demandSubcategoryName,
                            radius: 14.w,
                            onTap: () {
                              final token = getStorageUserToken();
                              if (token?.isEmpty ?? true) {
                                Get.toNamed('login');
                              } else {
                                Get.to(
                                  const StepTwo(title: '填写信息', author: true),
                                  arguments: item.demandSubcategoryId,
                                  fullscreenDialog: true,
                                );
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
