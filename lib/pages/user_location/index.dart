import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';
import 'package:qm_agricultural_machinery_services/entity/location_info.dart';
import 'package:qm_agricultural_machinery_services/components/marker_icon.dart';
import 'package:qm_agricultural_machinery_services/pages/user_location/location_list.dart';
import 'package:qm_agricultural_machinery_services/pages/service/service_sub_page/input_search.dart';

class UserLocationPage extends BasePage {
  const UserLocationPage({super.key, required super.title, required super.author});

  @override
  BasePageState<UserLocationPage> createState() => UserLocationPageState();
}

class UserLocationPageState extends BasePageState<UserLocationPage> {
  /// 经纬度
  LatLng? _location;
  String _markerText = '';
  bool _isUserDrag = false;
  CloseLoading? _closeLoading;
  LocationListState? _instance;

  /// 搜索关键字
  String _keyword = '';
  final double _maxZoom = 18;
  final double _initZoom = 16.6;
  final double _mapHeight = 360.w;
  final _mapController = MapController();
  final Epsg3857 _flutterMapCRS = const Epsg3857();
  final _initialMapCenter = const LatLng(39.907458, 116.391229);

  /// 移除 FlutterMap 的旋转(手指操作时地图就不会发生旋转了)
  final _interactionOptions = const InteractionOptions(
    flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
  );

  @override
  void onMounted() {
    _closeLoading = Loading.show();
    handleLocation();
  }

  handleNavBack() {
    Get.back();
  }

  /// 获取用户位置
  handleLocation() async {
    /// 获取用户的当前位置(经纬度)
    final location = await getUserLocation();

    if (location == null) {
      await _closeLoading?.call();
      Toast.warning('无法获取用户位置', duration: const Duration(seconds: 1));
      await Future.delayed(const Duration(seconds: 1));
      Get.back();
      return;
    }

    if (!mounted) return;

    setState(() => _location = location);
    _mapController.move(_location!, _initZoom);
  }

  onMapEvent(MapEvent event) {
    if (event.source == MapEventSource.dragEnd) {
      setState(() {
        _keyword = '';
        _isUserDrag = true;
        _location = event.camera.center;
      });
    }
  }

  handleInputChangeKeyword(String input) {
    setState(() {
      _keyword = input;
    });
  }

  /// 搜索定位
  handleSearch(String input) async {
    final closeLoading = Loading.show();
    await _instance!.handleQueryNewList(1, input);
    closeLoading();
  }

  handleLocationChange(LocationInfo? value) {
    if (value == null) return;

    setState(() => _markerText = value.name);

    if (_isUserDrag) {
      _isUserDrag = false;
      return;
    }

    final location = LatLng(double.parse(value.latitude), double.parse(value.longitude));
    final zoom = _mapController.camera.zoom;
    _mapController.move(location, zoom);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.viewPaddingOf(context);
    return Material(
      type: MaterialType.canvas,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: _mapHeight,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                maxZoom: _maxZoom,
                crs: _flutterMapCRS,
                initialZoom: _initZoom,
                onMapEvent: onMapEvent,
                initialCenter: _initialMapCenter,
                interactionOptions: _interactionOptions,
              ),
              children: [
                TileLayer(
                  urlTemplate: GlobalVars.tiandituVec,
                  subdomains: GlobalVars.tiandituImgSubdomains,
                  userAgentPackageName: 'com.example.qm_agricultural_machinery_services',
                ),
                TileLayer(
                  urlTemplate: GlobalVars.tiandituCva,
                  subdomains: GlobalVars.tiandituCiaSubdomains,
                  userAgentPackageName: 'com.example.qm_agricultural_machinery_services',
                ),
                // _markerLayer,
              ],
            ),
          ),

          /// Marker 定位标记
          Positioned(
            top: (_mapHeight - 93.w) / 2,
            child: SizedBox(width: 93.w, height: 93.w, child: const MarkerIcon()),
          ),
          _markerText.isEmpty
              ? const SizedBox.shrink()
              : Positioned(
                top: (_mapHeight - 110.w) / 2,
                child: IntrinsicWidth(
                  child: Container(
                    height: 24.w,
                    constraints: BoxConstraints(maxWidth: 240.w),
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      boxShadow: [
                        BoxShadow(color: Color(0x66000000), offset: Offset(0, 1), blurRadius: 5),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _markerText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.sp, height: 1),
                    ),
                  ),
                ),
              ),

          /// 位置搜索
          Positioned(
            left: 0,
            height: 40.w,
            width: 360.w,
            top: padding.top + 10,
            child: InputSearch(
              value: _keyword,
              onSearch: handleSearch,
              hintText: '搜索位置信息',
              onChanged: handleInputChangeKeyword,
            ),
          ),

          /// 重新定位
          Positioned(
            top: 100.w,
            right: 20.w,
            child: GestureDetector(
              onTap: handleLocation,
              child: Container(
                height: 38.w,
                width: 38.w,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(opacity2Alpha(0.6)),
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                ),
                child: Icon(QmIcons.position, size: 22.sp, color: const Color(0xFF333333)),
              ),
            ),
          ),

          /// 返回上一页
          Positioned(
            top: 100.w,
            left: 20.w,
            child: GestureDetector(
              onTap: handleNavBack,
              child: Container(
                height: 38.w,
                width: 38.w,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(opacity2Alpha(0.6)),
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                ),
                child: Icon(QmIcons.backup, size: 22.sp, color: const Color(0xFF333333)),
              ),
            ),
          ),
          Positioned(
            left: 0,
            width: 360.w,
            top: _mapHeight,
            height: size.height - _mapHeight,
            child: LocationList(
              latitude: _location?.latitude,
              longitude: _location?.longitude,
              onChanged: handleLocationChange,
              onMounted: (instance) {
                _instance = instance;
                _closeLoading?.call();
              },
            ),
          ),
        ],
      ),
    );
  }
}
