import 'package:get/get.dart';

class UserCheckStatus {
  /// 用户类型名称
  final String userTypeName;

  ///审核状态名称
  final String checkStatusName;

  /// 用户类型名称
  final int userType;

  /// 审核状态审核状态,0-未审核1-待审核；2-审核不通过；3-审核通过
  final int checkStatus;

  const UserCheckStatus({
    required this.userType,
    required this.checkStatus,
    required this.userTypeName,
    required this.checkStatusName,
  });

  factory UserCheckStatus.fromJson(Map<String, dynamic> json) => UserCheckStatus(
    userType: json['userType'],
    checkStatus: json['checkStatus'],
    userTypeName: json['userTypeName'],
    checkStatusName: json['checkStatusName'],
  );

  toJson() => {
    'userType': userType,
    'checkStatus': checkStatus,
    'userTypeName': userTypeName,
    'checkStatusName': checkStatusName,
  };
}

class MineModel extends GetxController {
  /// 用户认证状态
  final userCheckStatus = Rx<UserCheckStatus?>(null);

  void setUserCheckStatus(Map<String, dynamic> newValue) {
    userCheckStatus.value = UserCheckStatus.fromJson(newValue);
  }
}
