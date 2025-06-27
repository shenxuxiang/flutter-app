import 'header.dart';
import 'constant.dart';
import 'weather_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/api/my_farm.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/utils/load_env.dart';
import 'package:qm_agricultural_machinery_services/models/my_farm.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/entity/farm_info.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/entity/weather_info.dart';
import 'package:qm_agricultural_machinery_services/components/menu_list.dart';
import 'package:qm_agricultural_machinery_services/components/search_page.dart';
import 'package:qm_agricultural_machinery_services/entity/list_item_option.dart';
import 'package:qm_agricultural_machinery_services/components/search_input_box.dart';
import 'package:qm_agricultural_machinery_services/pages/my_farm/farm_field_item.dart';
import 'package:qm_agricultural_machinery_services/components/easy_refresh_footer.dart';

class MyFarmPage extends BasePage {
  const MyFarmPage({super.key, required super.author, required super.title});

  @override
  State<MyFarmPage> createState() => _MyFarmPageState();
}

class _MyFarmPageState extends BasePageState<MyFarmPage> {
  int _pageNum = 0;

  WeatherInfo? _weather;
  CloseLoading? _closeLoading;

  final List<dynamic> _farmFieldList = [];

  Map<String, dynamic>? _farmStatistics;

  final int _pageSize = 10;
  final myFarmModel = Get.find<MyFarmModel>();
  final _menus = menus.map((item) => MenuItemOption.fromJson(item)).toList();
  final _easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void onMounted() async {
    _closeLoading = Loading.show();
    await initializationData();
    _closeLoading!();
  }

  @override
  didPopNext() async {
    super.didPopNext();
    _closeLoading = Loading.show();
    await initializationData();
    _closeLoading!();
  }

  @override
  onUnload() {
    _easyRefreshController.dispose();
  }

  navigateBack() {
    Get.back();
  }

  /// 页面数据初始化，先获取我的农场列表，再获取地块列表、农场详情、天气信息
  initializationData() async {
    _pageNum = 0;
    try {
      final farmList = myFarmModel.farmList;
      final selectedFarm = myFarmModel.selectedFarm;

      final resp = await queryMyFarmList();
      final data = resp.data;
      if (!mounted) return;

      final List<ListItemOption> farmArray = [];
      for (final item in data) {
        farmArray.add(ListItemOption(label: item['farmName'], value: item['farmId']));
      }
      farmList.value = farmArray;

      if (selectedFarm.value == null) {
        selectedFarm.value = farmArray.first;
      } else {
        /// 根据已选中的 selectedFarm 来匹配
        final filterValues = farmArray.where((item) => item.value == selectedFarm.value!.value);

        if (filterValues.isEmpty) {
          // 未匹配到
          selectedFarm.value = farmArray.first;
        } else {
          selectedFarm.value = filterValues.first;
        }
      }

      /// 地块统计、农场详情、地块列表
      await Future.wait([
        handleQueryFarmFieldStatics(),
        handleQueryFarmDetail(),
        handleLoadFarmFieldList(),
      ]);
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
    }
  }

  /// 地块统计
  Future<void> handleQueryFarmFieldStatics() async {
    final selectedFarm = myFarmModel.selectedFarm.value;
    final resp = await queryFarmFieldStatics(selectedFarm!.value);
    setState(() => _farmStatistics = resp.data);
  }

  /// 获取天气
  Future<void> handleQueryWeather() async {
    final farmInfo = myFarmModel.farmInfo.value!;
    String latitude = farmInfo.latitude;
    String longitude = farmInfo.longitude;
    String regionCode = farmInfo.regionCode;
    if (latitude.isNotEmpty && longitude.isNotEmpty && regionCode.isNotEmpty) {
      /// 获取天气
      final params = {'latitude': latitude, 'longitude': longitude, 'regionCode': regionCode};

      final resp = await queryWeather(params);
      if (!mounted) return;
      setState(() => _weather = WeatherInfo.fromJson(resp.data));
    }
  }

  /// 获取农场详情、以及天气信息
  Future<void> handleQueryFarmDetail() async {
    try {
      final selectedFarm = myFarmModel.selectedFarm.value!;

      /// 获取农场详情
      final resp = await queryMyFarmDetail(selectedFarm.value);
      if (!mounted) return;
      myFarmModel.farmInfo.value = FarmInfo.fromJson(resp.data);
      await handleQueryWeather();
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
    }
  }

  /// 获取地块列表
  Future<void> handleLoadFarmFieldList() async {
    try {
      final params = {
        'pageSize': _pageSize,
        'pageNum': _pageNum + 1,
        'farmId': myFarmModel.selectedFarm.value!.value,
      };
      final resp = await queryFarmFieldList(params);
      if (!mounted) return;
      setState(() {
        _pageNum = resp.data['pageNum'];
        if (_pageNum == 1) _farmFieldList.clear();
        _farmFieldList.addAll(resp.data['list']);
        _easyRefreshController.finishLoad(
          _farmFieldList.length >= int.parse(resp.data['total'])
              ? IndicatorResult.noMore
              : IndicatorResult.success,
        );
      });
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
      _easyRefreshController.finishLoad(IndicatorResult.fail);
    }
  }

  /// 更换我的农场
  handleChangeSelectedFarm(ListItemOption value) async {
    _pageNum = 0;
    _closeLoading = Loading.show();
    myFarmModel.selectedFarm.value = value;

    await Future.wait([
      handleQueryFarmFieldStatics(),
      handleQueryFarmDetail(),
      handleLoadFarmFieldList(),
    ]);

    _closeLoading!();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.viewPaddingOf(context);

    return Material(
      type: MaterialType.canvas,
      child: Container(
        color: const Color(0xFFE3F2EA),
        child: EasyRefresh(
          onLoad: handleLoadFarmFieldList,
          controller: _easyRefreshController,
          footer: EasyRefreshFooter(controller: _easyRefreshController),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 534.w,
                scrolledUnderElevation: 0,
                title: Text(widget.title),
                collapsedHeight: kToolbarHeight,
                backgroundColor: const Color(0xFFE3F2EA),
                leading: GestureDetector(
                  onTap: navigateBack,
                  child: Icon(QmIcons.back, color: const Color(0xFF333333), size: 24),
                ),
                foregroundColor: Colors.red,
                actions: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/my_farm/add_farm');
                    },
                    child: Icon(QmIcons.plus, size: 24.sp, color: const Color(0xFF333333)),
                  ),
                  SizedBox(width: 8.w),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        alignment: Alignment.topLeft,
                        image: AssetImage('assets/images/my_farm/bg.png'),
                      ),
                    ),
                    padding: EdgeInsets.only(top: kToolbarHeight + padding.top),
                    child: Column(
                      children: [
                        Obx(
                          () => HeaderWidget(
                            onChanged: handleChangeSelectedFarm,
                            farmList: myFarmModel.farmList.value,
                            selectedFarm: myFarmModel.selectedFarm.value,
                            regionName: myFarmModel.farmInfo.value?.regionName ?? '',
                          ),
                        ),
                        WeatherWidget(weather: _weather),
                        MenuListWidget(menus: _menus),
                        Padding(
                          padding: EdgeInsets.fromLTRB(12.w, 16.w, 12.w, 12.w),
                          child: Row(
                            children: [
                              Text(
                                '农场地块',
                                style: TextStyle(
                                  height: 1,
                                  fontSize: 16.sp,
                                  color: const Color(0xFF333333),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '（${_farmStatistics?['count'] ?? ''}块地，${_farmStatistics?['totalArea'] ?? ''}亩）',
                                  style: TextStyle(
                                    height: 1,
                                    fontSize: 13.sp,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  final selectedFarm = myFarmModel.selectedFarm.value;

                                  Get.toNamed(
                                    '/webview_page',
                                    arguments:
                                        '${getEnv('h5')}/h5/home?id=${selectedFarm!.value}&farmName=${selectedFarm.label}',
                                  );
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      Text(
                                        '进入地块地图',
                                        style: TextStyle(
                                          height: 1,
                                          fontSize: 11.sp,
                                          color: const Color(0xFF4A4A4A),
                                        ),
                                      ),
                                      Icon(
                                        QmIcons.forward,
                                        size: 16.sp,
                                        color: const Color(0xFF4A4A4A),
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
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(52.w),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                        fullscreenDialog: true,
                        SearchPage(
                          author: true,
                          title: widget.title,
                          sliverPadding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, dynamic data) {
                            return FarmFieldItem(farmFieldInfo: data);
                          },
                          queryResourceList: (dynamic query) {
                            query['farmId'] = myFarmModel.selectedFarm.value!.value;
                            query['fieldName'] = query['keyword'];
                            query['keyword'] = '';

                            return queryFarmFieldList(query);
                          },
                        ),
                      );
                    },
                    child: Container(
                      color: const Color(0xFFE3F2EA),
                      padding: EdgeInsets.only(bottom: 12.w),
                      child: IgnorePointer(
                        child: SearchInputBox(onSearch: (String input) {}, hintText: '请输入地块名称'),
                      ),
                    ),
                  ),
                ),
              ),
              // SliverToBoxAdapter(child: Container(height: 1000.w, color: Colors.grey)),
              SliverList.builder(
                itemCount: _farmFieldList.length,
                itemBuilder: (BuildContext context, int index) {
                  return FarmFieldItem(farmFieldInfo: _farmFieldList[index]);
                },
              ),
              const FooterLocator.sliver(),
            ],
          ),
        ),
      ),
    );
  }
}
