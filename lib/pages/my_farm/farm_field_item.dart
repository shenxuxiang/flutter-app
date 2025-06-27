import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/load_env.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';

class FarmFieldItem extends StatefulWidget {
  final Map<String, dynamic> farmFieldInfo;

  const FarmFieldItem({super.key, required this.farmFieldInfo});

  @override
  State<FarmFieldItem> createState() => _FarmFieldItemState();
}

class _FarmFieldItemState extends State<FarmFieldItem> {
  late List<LatLng> _points;
  late CameraFit _initialCameraFit;
  final Epsg3857 _flutterMapCRS = const Epsg3857();

  /// 关闭所有的地图交互，此处的地图只有展示功能
  final _interactionOptions = const InteractionOptions(flags: InteractiveFlag.none);

  @override
  void initState() {
    dynamic features = (widget.farmFieldInfo['geoJsonBean']['features']).elementAt(0);
    List<dynamic> coordinates = features['geometry']['coordinates'][0][0];

    /// 计算所有的点位
    _points = coordinates.map((item) => LatLng(item[1], item[0])).toList();

    /// 得到合适的相机位，让所有的点都展示在可视区范围内
    _initialCameraFit = CameraFit.coordinates(
      coordinates: _points,
      padding: const EdgeInsets.all(8),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          '/webview_page',
          arguments: '${getEnv('h5')}/h5/field-detail?id=${widget.farmFieldInfo['farmFieldId']}',
        );
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 106.w,
              height: 80.w,
              child: FlutterMap(
                options: MapOptions(
                  crs: _flutterMapCRS,
                  initialCameraFit: _initialCameraFit,
                  interactionOptions: _interactionOptions,
                ),
                children: [
                  TileLayer(
                    urlTemplate: GlobalVars.tiandituImg,
                    subdomains: GlobalVars.tiandituImgSubdomains,
                    userAgentPackageName: 'com.example.qm_agricultural_machinery_services',
                  ),
                  PolygonLayer(
                    polygons: [
                      Polygon(
                        points: _points,
                        borderStrokeWidth: 2.w,
                        borderColor: Colors.green,
                        strokeCap: StrokeCap.square,
                        color: const Color(0xAA388E3C),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.farmFieldInfo['fieldName'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: 1,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 11.w),
                  Text(
                    '面积：${widget.farmFieldInfo['area'] ?? ''}',
                    style: TextStyle(height: 1, fontSize: 13.sp, color: const Color(0xFF666666)),
                  ),
                  SizedBox(height: 4.w),
                  Text(
                    '种养殖：${widget.farmFieldInfo['breedingTypeNames'] ?? ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(height: 1, fontSize: 13.sp, color: const Color(0xFF666666)),
                  ),
                  SizedBox(height: 9.w),
                  Row(
                    children: [
                      Icon(QmIcons.location, size: 16.sp, color: const Color(0xFF4A4A4A)),
                      Expanded(
                        child: Text(
                          widget.farmFieldInfo['location'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            height: 1,
                            fontSize: 11.sp,
                            color: const Color(0xFF4A4A4A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
