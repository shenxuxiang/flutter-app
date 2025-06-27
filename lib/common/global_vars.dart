import 'package:flutter/material.dart';
import 'package:qm_agricultural_machinery_services/utils/load_env.dart';

class GlobalVars {
  static BuildContext? context;
  static final RegExp phoneRegExp = RegExp(r'^1[345789][0-9]{8}');
  static final RegExp certificationCodeRegExp = RegExp(r'^[0-9]{6}$');
  static final RegExp passwdRegExp = RegExp(
    r'^(?=.*\d+)(?=.*[a-zA-Z]+)(?=.*[~!@#$%^&*\.]+)[~!@#$%^&*\.0-9a-zA-Z]{6,18}',
  );
  static final List<String> tiandituImgSubdomains = ['0', '1', '2', '3', '4', '5', '6', '7'];

  static final List<String> tiandituCiaSubdomains = ['0', '1', '2', '3', '4', '5', '6', '7'];

  /// 替换为你的有效天地图密钥
  static const String tiandituKey = '8c72c96eb3fddf35e138a3259f57ed67';

  /// 矢量底图 WMTS
  static final String tiandituVec =
      'http://t{s}.tianditu.gov.cn/vec_w/wmts?tk=$tiandituKey&service=wmts&request=GetTile&version=1.0.0&layer=vec&style=default&tilematrixset=w&format=tiles&tilematrix={z}&tilerow={y}&tilecol={x}';

  /// 影像底图 WMTS
  static final String tiandituImg =
      'https://t{s}.tianditu.gov.cn/img_w/wmts?tk=49e687be3d835676e4cd1f15a24c1aef&SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}';

  /// 矢量注记 WMTS
  static final String tiandituCva =
      'http://t{s}.tianditu.gov.cn/cva_w/wmts?tk=$tiandituKey&service=wmts&request=GetTile&version=1.0.0&layer=cva&style=default&tilematrixset=w&format=tiles&tilematrix={z}&tilerow={y}&tilecol={x}';

  /// 影像注记 WMTS
  static final String tiandituCia =
      'https://t{s}.tianditu.gov.cn/cia_w/wmts?tk=49e687be3d835676e4cd1f15a24c1aef&SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=cia&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}';
}
