import 'demand_list.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/api/publish.dart';
import 'package:qm_agricultural_machinery_services/models/publish.dart';
import 'package:qm_agricultural_machinery_services/components/skeleton.dart';
import 'package:qm_agricultural_machinery_services/components/keep_alive.dart';
import 'package:qm_agricultural_machinery_services/components/search_page.dart';
import 'package:qm_agricultural_machinery_services/entity/demand_category.dart';
import 'package:qm_agricultural_machinery_services/components/search_input_box.dart';

class DemandPanel extends StatefulWidget {
  const DemandPanel({super.key});

  @override
  State<DemandPanel> createState() => _DemandPanelState();
}

class _DemandPanelState extends State<DemandPanel> with SingleTickerProviderStateMixin {
  final publishModel = Get.find<PublishModel>();
  late final TabController tabController;
  DemandCategory? selectedTab;
  bool isLoading = true;

  @override
  void initState() {
    onLoad();
    super.initState();
  }

  onLoad() async {
    try {
      final demandCategoryList = publishModel.demandCategoryList;

      tabController = TabController(
        vsync: this,
        animationDuration: Duration.zero,
        length: demandCategoryList.value.length,
      );
      setState(() {
        isLoading = false;
        selectedTab = demandCategoryList.value.first;
      });
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12.w),
        GestureDetector(
          onTap: () {
            Get.to(
              SearchPage(
                author: true,
                title: '服务大厅',
                queryResourceList: queryHallDemandList,
                itemBuilder: (BuildContext context, dynamic data) {
                  return DemandItem(data: data);
                },
              ),
              fullscreenDialog: true,
            );
          },
          child: Container(
            color: Colors.transparent,
            child: IgnorePointer(child: SearchInputBox(onSearch: (_) {})),
          ),
        ),
        SizedBox(height: 12.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child:
                isLoading
                    ? const SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: SkeletonScreen(),
                    )
                    : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Container(
                            width: 80.w,
                            height: 316.w,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  for (final it in publishModel.demandCategoryList.value)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() => selectedTab = it);
                                        final index = publishModel.demandCategoryList.value.indexOf(
                                          it,
                                        );
                                        tabController.index = index;
                                      },
                                      child: Container(
                                        width: 80.w,
                                        height: 40.w,
                                        decoration: BoxDecoration(
                                          color:
                                              selectedTab == it
                                                  ? const Color(0xFFFAFAFA)
                                                  : Colors.white,
                                          border: Border(
                                            left: BorderSide(
                                              width: 2.w,
                                              color:
                                                  selectedTab == it
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
                                                selectedTab == it
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
                        SizedBox(width: 8.w),
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              for (final item in publishModel.demandCategoryList.value)
                                KeepAliveWidget(
                                  child: DemandList(categoryId: item.demandCategoryId),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ],
    );
  }
}
