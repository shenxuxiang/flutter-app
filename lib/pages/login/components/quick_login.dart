import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/alert.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/utils/storage.dart';
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';
import 'package:qm_agricultural_machinery_services/components/checkbox.dart';
import 'package:qm_agricultural_machinery_services/components/input_box.dart';
import 'package:qm_agricultural_machinery_services/entity/response_data.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart' show queryUserInfo;
import 'package:qm_agricultural_machinery_services/components/verification_code.dart';
import 'package:qm_agricultural_machinery_services/api/login.dart' show queryPhoneCode;
import 'package:qm_agricultural_machinery_services/utils/utils.dart'
    show setStorageUserToken, setStorageUserInfo;

class QuickLogin extends StatefulWidget {
  final bool isLogout;

  const QuickLogin({super.key, required this.isLogout});

  @override
  State<QuickLogin> createState() => _QuickLoginState();
}

class _QuickLoginState extends State<QuickLogin> {
  String _code = '';
  String _phone = '';
  bool _checked = false;

  bool get _submitDisabled => _code.isEmpty || _phone.isEmpty;

  @override
  void initState() {
    _phone = Storage.getItem('User_Phone') ?? '';
    super.initState();
  }

  void handleChangePhone(String input) {
    setState(() {
      _phone = input;
    });
  }

  void handleChangeCode(String input) {
    setState(() {
      _code = input;
    });
  }

  /// 更新用户信息
  updateUserInfo() async {
    final resp = await queryUserInfo();
    final mainModel = Get.find<MainModel>();
    mainModel.setUserInfo(resp.data);
    await setStorageUserInfo(resp.data);
  }

  /// 登录
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
    CloseLoading? closeLoading;
    try {
      if (!GlobalVars.phoneRegExp.hasMatch(_phone)) {
        Toast.warning('请输入正确的手机号码');
        return;
      }

      if (!GlobalVars.certificationCodeRegExp.hasMatch(_code)) {
        Toast.warning('验证码错误');
        return;
      }

      closeLoading = Loading.show();
      ResponseData resp = await queryPhoneCode({'phone': _phone, 'code': _code});
      await setStorageUserToken(resp.data['token']);
      await Storage.setItem('User_Phone', _phone);

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
      closeLoading?.call();
      debugPrint('$err');
      debugPrint('$stack');
    }
  }

  void navigateToUserAgreement() {
    Get.toNamed('/user_agreement');
  }

  void navigateToPrivacyAgreement() {
    Get.toNamed('/privacy_agreement');
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
          maxLength: 11,
          value: _phone,
          hintText: '请输入手机号',
          onChanged: handleChangePhone,
          textInputType: TextInputType.number,
        ),
        SizedBox(height: 26.w),
        InputBox(
          value: _code,
          maxLength: 6,
          hintText: '请输入验证码',
          onChanged: handleChangeCode,
          textInputType: TextInputType.number,
          textInputAction: TextInputAction.done,
          suffix: VerificationCode(phone: _phone, type: '1'),
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
      ],
    );
  }
}
