import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/alert.dart';
import 'package:qm_agricultural_machinery_services/utils/crypto.dart';
import 'package:qm_agricultural_machinery_services/utils/storage.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/components/checkbox.dart';
import 'package:qm_agricultural_machinery_services/entity/response_data.dart';
import 'package:qm_agricultural_machinery_services/components/input_box.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart' show queryUserInfo;
import 'package:qm_agricultural_machinery_services/api/login.dart' show queryAccountLogin;
import 'package:qm_agricultural_machinery_services/utils/utils.dart'
    show setStorageUserInfo, setStorageUserToken;

class AccountLogin extends StatefulWidget {
  final bool isLogout;

  const AccountLogin({super.key, required this.isLogout});

  @override
  State<AccountLogin> createState() => _AccountLoginState();
}

class _AccountLoginState extends State<AccountLogin> {
  String _passwd = '';
  String _account = '';
  bool _checked = false;

  bool get _submitDisabled => _passwd.isEmpty || _account.isEmpty;

  @override
  void initState() {
    final account = Storage.getItem('User_Account') ?? '';
    setState(() => _account = account);
    super.initState();
  }

  void handleChangeAccount(String input) {
    setState(() {
      _account = input;
    });
  }

  void handleChangePasswd(String input) {
    setState(() {
      _passwd = input;
    });
  }

  void navigateToUserAgreement() {
    Get.toNamed('/user_agreement');
  }

  void navigateToPrivacyAgreement() {
    Get.toNamed('/privacy_agreement');
  }

  /// 更新用户信息
  updateUserInfo() async {
    final resp = await queryUserInfo();
    final mainModel = Get.find<MainModel>();
    mainModel.setUserInfo(resp.data);
    await setStorageUserInfo(resp.data);
  }

  void handleSubmit() async {
    if (!_checked) {
      Alert.confirm(
        confirmText: '同意',
        title: '请您阅读并同意《用户协议》和《隐私协议》',
        onConfirm: () {
          setState(() => _checked = true);
        },
      );
      return;
    }
    CloseLoading closeLoading = Loading.show();
    final params = {'username': _account, 'password': encryption(_passwd), 'clientType': 'app'};
    try {
      ResponseData resp = await queryAccountLogin(params);
      await setStorageUserToken(resp.data['token']);
      await Storage.setItem('User_Account', _account);

      /// 更新用户信息
      await updateUserInfo();
      await closeLoading();
      Toast.show('登录成功~', duration: const Duration(milliseconds: 1000));
      await Future.delayed(const Duration(milliseconds: 1000));
      if (widget.isLogout) {
        Get.offAllNamed('/home');
      } else {
        Get.back();
      }
    } catch (err, stack) {
      closeLoading();
      debugPrint('$err');
      debugPrint('$stack');
    }
  }

  Future<void> navigateToRegister() async {
    final account = await Get.toNamed('/register') ?? '';
    if (account.isNotEmpty) {
      setState(() => _account = account);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 40.w),
        InputBox(
          maxLength: 20,
          value: _account,
          hintText: '请输入账号',
          onChanged: handleChangeAccount,
          textInputType: TextInputType.text,
        ),
        SizedBox(height: 26.w),
        InputBox(
          maxLength: 16,
          value: _passwd,
          obscureText: true,
          hintText: '请输入密码',
          onChanged: handleChangePasswd,
          textInputType: TextInputType.text,
        ),
        SizedBox(height: 40.w),
        ButtonWidget(
          text: '登录',
          width: 266.w,
          height: 36.w,
          radius: 18.w,
          disabled: _submitDisabled,
          onTap: () {
            FocusScope.of(context).unfocus();
            handleSubmit();
          },
        ),
        SizedBox(height: 14.w),
        SizedBox(
          width: 266.w,
          child: Row(
            children: [
              CheckboxWidget(
                radius: 4,
                size: 18.w,
                borderWidth: 1,
                checked: _checked,
                onChanged: (checked) {
                  setState(() => _checked = checked);
                },
              ),
              const SizedBox(width: 6),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 10.sp, color: const Color(0xFF999999), height: 1.2),
                    children: [
                      const TextSpan(text: '登录代表您已同意'),
                      TextSpan(
                        text: '《用户协议》',
                        style: TextStyle(color: primaryColor),
                        recognizer: TapGestureRecognizer()..onTap = navigateToUserAgreement,
                      ),
                      const TextSpan(text: '和'),
                      TextSpan(
                        text: '《隐私协议》',
                        style: TextStyle(color: primaryColor),
                        recognizer: TapGestureRecognizer()..onTap = navigateToPrivacyAgreement,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 44.w),
        SizedBox(
          width: 266.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 16.w,
                height: 1,
                color: const Color(0xFFCCCCCC),
                margin: const EdgeInsets.only(right: 6),
              ),
              Text(
                '注册新账号',
                style: TextStyle(fontSize: 11.sp, height: 1, color: const Color(0xFF4A4A4A)),
              ),
              Container(
                width: 16.sp,
                height: 1,
                color: const Color(0xFFCCCCCC),
                margin: const EdgeInsets.only(left: 6),
              ),
            ],
          ),
        ),
        SizedBox(height: 26.sp),
        ButtonWidget(
          text: '注册',
          ghost: true,
          width: 266.w,
          height: 36.w,
          radius: 18.w,
          type: 'default',
          onTap: navigateToRegister,
        ),
      ],
    );
  }
}
