import 'package:get/get.dart';
import 'components/Input_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'components/select_region_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/alert.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/crypto.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';
import 'package:qm_agricultural_machinery_services/components/checkbox.dart';
import 'package:qm_agricultural_machinery_services/api/register.dart' as api;
import 'package:qm_agricultural_machinery_services/utils/user_tap_feedback.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/entity/selected_tree_node.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/components/verification_code.dart';

class Register extends BasePage {
  const Register({super.key, required super.title, super.author = false});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends BasePageState<Register> {
  String _code = '';
  String _phone = '';
  String _passwd = '';
  String _realName = '';
  bool _checked = false;
  List<SelectedTreeNode> _regions = [];

  bool get _submitDisabled =>
      !GlobalVars.phoneRegExp.hasMatch(_phone) ||
      _realName.isEmpty ||
      _passwd.isEmpty ||
      _code.isEmpty ||
      _regions.isEmpty;

  void handleChangePhone(String input) {
    setState(() {
      _phone = input;
    });
  }

  void handleChangePasswd(String input) {
    setState(() {
      _passwd = input;
    });
  }

  void handleChangeRealName(String input) {
    setState(() {
      _realName = input;
    });
  }

  void handleChangeCode(String input) {
    setState(() {
      _code = input;
    });
  }

  void handleChangeRegions(List<SelectedTreeNode> input) {
    setState(() {
      _regions = input;
    });
  }

  void handleRegister() async {
    FocusScope.of(context).unfocus();

    if (!_checked) {
      Alert.confirm(
        confirmText: '同意',
        title: '请您阅读并同意《用户协议》',
        onConfirm: () {
          setState(() => _checked = true);
        },
      );
      return;
    }

    if (!GlobalVars.passwdRegExp.hasMatch(_passwd)) {
      Toast.show("密码必须包含字母、数字、特殊字符(~！%@#\$)，长度为8-16位");
      return;
    }

    final closeLoading = Loading.show();
    final params = {
      'code': _code,
      'phone': _phone,
      'userType': '5',
      'username': _realName,
      'password': encryption(_passwd),
      'regionCode': _regions.last.value,
      'regionName': _regions.last.label,
    };

    try {
      await api.queryUserRegister(params);
      await closeLoading();
      Toast.show('注册成功~', duration: const Duration(milliseconds: 1000));
      await Future.delayed(const Duration(milliseconds: 1000));
      Get.back(result: _phone);
    } catch (err, stack) {
      closeLoading();
      debugPrint('$err');
      debugPrint('$stack');
    }
  }

  void navigateToUserAgreement() {
    Get.toNamed('/user_agreement');
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(title: widget.title),
        body: Container(
          height: 516.w,
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: FocusScope(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.w),
                  InputWidget(
                    maxLength: 11,
                    value: _phone,
                    label: '手机号',
                    hintText: '请填写手机号',
                    onChanged: handleChangePhone,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20.w),
                  InputWidget(
                    label: '密码',
                    maxLength: 12,
                    value: _passwd,
                    obscureText: true,
                    onChanged: handleChangePasswd,
                    textInputAction: TextInputAction.next,
                    hintText: '必须包含字母、数字、特殊字符，长度为8-16位',
                  ),
                  SizedBox(height: 20.w),
                  InputWidget(
                    maxLength: 20,
                    label: '用户名',
                    value: _realName,
                    hintText: '请填写用户名',
                    onChanged: handleChangeRealName,
                  ),
                  SizedBox(height: 20.w),
                  SelectRegionWidget(
                    value: _regions,
                    label: '所在地区',
                    hintText: '请选择地区',
                    onChanged: handleChangeRegions,
                  ),
                  SizedBox(height: 20.w),
                  InputWidget(
                    value: _code,
                    maxLength: 6,
                    label: '验证码',
                    hintText: '请输入验证码',
                    onChanged: handleChangeCode,
                    keyboardType: TextInputType.number,
                    suffix: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: VerificationCode(phone: _phone, type: '2'),
                    ),
                  ),
                  SizedBox(height: 33.w),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        CheckboxWidget(
                          radius: 4,
                          size: 18.w,
                          borderWidth: 1,
                          checked: _checked,
                          onChanged: (checked) {
                            UserTapFeedback.selection();
                            setState(() => _checked = checked);
                          },
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF999999),
                                height: 1.2,
                              ),
                              children: [
                                const TextSpan(text: '勾选同意'),
                                TextSpan(
                                  text: '《用户协议》',
                                  style: TextStyle(color: primaryColor),
                                  recognizer:
                                      TapGestureRecognizer()..onTap = navigateToUserAgreement,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.w),
                  ButtonWidget(
                    text: '注册',
                    radius: 18.w,
                    height: 36.w,
                    type: 'primary',
                    disabled: _submitDisabled,
                    onTap: handleRegister,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
