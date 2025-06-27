import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/components/checkbox.dart';
import 'package:qm_agricultural_machinery_services/entity/location_info.dart';
import 'package:qm_agricultural_machinery_services/components/empty_widget.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/components/easy_refresh_footer.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart' show queryPlaceAroundList;

class LocationList extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final void Function(LocationInfo? value) onChanged;
  final void Function(LocationListState instance) onMounted;

  const LocationList({
    super.key,
    this.latitude,
    this.longitude,
    required this.onChanged,
    required this.onMounted,
  });

  @override
  State<LocationList> createState() => LocationListState();
}

class LocationListState extends State<LocationList> {
  int _pageNum = 0;
  bool _isMounted = false;
  LocationInfo? _selectedLocation;

  final int _pageSize = 30;
  final _resourceList = [];
  final _scrollController = ScrollController();
  final _easyRefreshController = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  @override
  void didUpdateWidget(LocationList oldWidget) {
    final latitude = widget.latitude;
    final longitude = widget.longitude;
    if (oldWidget.latitude != latitude || oldWidget.longitude != longitude) {
      if (latitude != null && longitude != null) handleQueryNewList(1, '');
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    if (widget.latitude == null || widget.longitude == null) return;
    handleQueryNewList(1, '');

    super.initState();
  }

  @override
  dispose() {
    _easyRefreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> handleLoad() async {
    if (widget.latitude == null || widget.longitude == null) return;
    handleQueryNewList(_pageNum + 1, '');
  }

  handleQueryNewList(int pageNum, String keyword) async {
    try {
      final resp = await queryPlaceAroundList({
        'pageNum': pageNum,
        'keywords': keyword,
        'pageSize': _pageSize,
        'latitude': widget.latitude,
        'longitude': widget.longitude,
      });
      final data = resp.data;
      if (!mounted) return;

      IndicatorResult indicatorResult =
          _pageSize > data.length ? IndicatorResult.noMore : IndicatorResult.success;

      setState(() {
        if (pageNum == 1) {
          _resourceList.clear();
          _selectedLocation = data.isNotEmpty ? LocationInfo.fromJson(data.first) : null;
        }
        _pageNum = pageNum;
        _resourceList.addAll(data);
      });

      _easyRefreshController.finishLoad(indicatorResult);
      if (pageNum == 1) {
        widget.onChanged(_selectedLocation);
        _easyRefreshController.finishRefresh(indicatorResult);
        if (_scrollController.positions.isNotEmpty) _scrollController.position.jumpTo(0);
      }
    } catch (error, stack) {
      printLog('$error');
      printLog('$stack');
      if (!mounted) return;

      _easyRefreshController.finishLoad(IndicatorResult.fail);
      if (pageNum == 1) _easyRefreshController.finishRefresh(IndicatorResult.fail);
    } finally {
      if (!_isMounted) {
        _isMounted = true;
        widget.onMounted(this);
      }
    }
  }

  handleSelected(dynamic location) {
    setState(() {
      if (location['name'] != _selectedLocation?.name) {
        _selectedLocation = LocationInfo.fromJson(location);
      }
    });
    widget.onChanged(_selectedLocation);
  }

  handleConfirm() {
    if (_selectedLocation == null) {
      Toast.warning('请选择一个位置');
      return;
    }
    Get.back(result: _selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 44.w,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Color(0x11000000), offset: Offset(0, 3), blurRadius: 3)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '周边位置',
                  style: TextStyle(fontSize: 14.sp, color: const Color(0xFF4A4A4A), height: 1),
                ),
                ButtonWidget(
                  width: 60.w,
                  text: '确认',
                  height: 28.w,
                  radius: 14.w,
                  onTap: handleConfirm,
                ),
              ],
            ),
          ),
          Expanded(
            child: EasyRefresh(
              onLoad: handleLoad,
              canLoadAfterNoMore: false,
              canRefreshAfterNoMore: true,
              controller: _easyRefreshController,
              footer: EasyRefreshFooter(controller: _easyRefreshController),
              child: CustomScrollView(
                controller: _scrollController,
                slivers:
                    _resourceList.isEmpty
                        ? [
                          const SliverPadding(padding: EdgeInsets.only(top: 100)),
                          const SliverToBoxAdapter(child: Center(child: EmptyWidget())),
                        ]
                        : [
                          SliverList.builder(
                            itemCount: _resourceList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final location = _resourceList[index];
                              return GestureDetector(
                                onTap: () => handleSelected(location),
                                child: Container(
                                  height: 66.5.w,
                                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              location['name'],
                                              style: TextStyle(
                                                height: 1,
                                                fontSize: 16.sp,
                                                color: const Color(0xFF333333),
                                              ),
                                            ),
                                            SizedBox(height: 6.w),
                                            Text(
                                              location['address'],
                                              style: TextStyle(
                                                height: 1,
                                                fontSize: 13.sp,
                                                color: const Color(0xFF666666),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IgnorePointer(
                                        child: CheckboxWidget(
                                          size: 22.w,
                                          ghost: true,
                                          radius: 11.w,
                                          borderWidth: 1.4,
                                          checked: _selectedLocation?.name == location?['name'],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: 12.w)),
                          const FooterLocator.sliver(),
                        ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
