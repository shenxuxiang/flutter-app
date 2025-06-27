import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/utils/crypto.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/components/verification_code.dart';
import 'package:qm_agricultural_machinery_services/components/form_item_password.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart'
    show printLog, setStorageUserInfo;
import 'package:qm_agricultural_machinery_services/api/main.dart'
    show queryUserInfo, queryUpdateUserPhone, queryUpdateUserPassword;

import '../components/form_item_input.dart';

class ModifyPersonalDataPage extends BasePage {
  const ModifyPersonalDataPage({super.key, required super.author, required super.title});

  @override
  State<ModifyPersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends BasePageState<ModifyPersonalDataPage> {
  String _phone = '';
  String _code = '';
  String _password = '';
  String _password2 = '';
  bool _isUpdatePhone = true;

  @override
  void initState() {
    if (Get.parameters.containsKey('phone')) {
      _isUpdatePhone = false;
      _phone = Get.parameters['phone']!;
    }
    super.initState();
  }

  Future<void> handleSubmit() async {
    final mainModel = Get.find<MainModel>();
    final closeLoading = Loading.show();

    if (_isUpdatePhone) {
      try {
        final params = {'phone': _phone, 'code': _code};
        await queryUpdateUserPhone(params);
        final resp = await queryUserInfo();
        mainModel.setUserInfo(resp.data);
        await setStorageUserInfo(resp.data);
        Get.back();
      } catch (error, stack) {
        printLog(error);
        printLog(stack);
      }
    } else {
      try {
        final params = {
          'code': _code,
          'newPassword': encryption(_password),
          'confirmPassword': encryption(_password2),
        };
        await queryUpdateUserPassword(params);
        final resp = await queryUserInfo();
        mainModel.setUserInfo(resp.data);
        await setStorageUserInfo(resp.data);
        Get.back();
      } catch (error, stack) {
        printLog(error);
        printLog(stack);
      }
    }
    await closeLoading();
  }

  handleChangePhone(String input) {
    setState(() {
      _phone = input;
    });
  }

  handleChangeCode(String input) {
    setState(() {
      _code = input;
    });
  }

  handleChangePassword(String input) {
    setState(() {
      _password = input;
    });
  }

  handleChangePassword2(String input) {
    setState(() {
      _password2 = input;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(title: widget.title),
        body: Container(
          margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormItemInput(
                value: _phone,
                label: '手机号码',
                hintText: '请输入手机号',
                onChanged: handleChangePhone,
                keyboardType: TextInputType.phone,
              ),
              FormItemInput(
                value: _code,
                label: '验证码',
                maxLength: 6,
                hintText: '请输入验证码',
                bordered: !_isUpdatePhone,
                onChanged: handleChangeCode,
                keyboardType: TextInputType.phone,
                suffix: VerificationCode(phone: _phone, type: _isUpdatePhone ? '4' : '5'),
              ),
              _isUpdatePhone
                  ? const SizedBox.shrink()
                  : FormItemPassword(
                    label: '新密码',
                    value: _password,
                    hintText: '请输入新密码',
                    onChanged: handleChangePassword,
                  ),
              _isUpdatePhone
                  ? const SizedBox.shrink()
                  : FormItemPassword(
                    bordered: false,
                    label: '确认密码',
                    value: _password2,
                    hintText: '请再次输入新密码',
                    onChanged: handleChangePassword2,
                  ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 48.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color(0xFFEFEFEF), offset: Offset(0, -0.3), blurRadius: 2),
            ],
          ),
          child: Center(
            child: ButtonWidget(
              height: 36.w,
              width: 266.w,
              radius: 18.w,
              text: '提交',
              onTap: handleSubmit,
            ),
          ),
        ),
      ),
    );
  }
}
