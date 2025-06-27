import 'package:get/get.dart';

enum VisibilityState { show, hidden }

class HomeModel extends GetxController {
  /// 当前展示的 tab 所对应的下标
  final tabKey = 0.obs;
}
