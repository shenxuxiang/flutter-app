import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart' as api;
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';
import 'package:qm_agricultural_machinery_services/components/countdown.dart';

class VerificationCode extends StatefulWidget {
  final String phone;
  final String type;

  const VerificationCode({super.key, required this.phone, required this.type});

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

enum Status { none, waiting }

class _VerificationCodeState extends State<VerificationCode> {
  Status _status = Status.none;

  @override
  void initState() {
    super.initState();
  }

  /// 获取验证码
  Future<void> handleQueryVerificationCode() async {
    if (widget.phone.isEmpty) {
      Toast.warning('手机号不能为空');
      return;
    } else if (!GlobalVars.phoneRegExp.hasMatch(widget.phone)) {
      Toast.warning('请输入正确的手机号');
      return;
    }

    api
        .queryUserVerificationCode({'phone': widget.phone, 'type': widget.type})
        .then((resp) => Toast.success('验证码已发送'));

    setState(() => _status = Status.waiting);
  }

  void handleCountdownComplete() {
    setState(() => _status = Status.none);
  }

  renderWidget() {
    if (_status == Status.none) {
      return GestureDetector(onTap: handleQueryVerificationCode, child: const Text('获取验证码'));
    } else if (_status == Status.waiting) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Countdown(onCompleted: handleCountdownComplete, seconds: 60), const Text(' S')],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return AnimatedSize(
      alignment: Alignment.centerRight,
      duration: const Duration(milliseconds: 200),
      child: Container(
        alignment: Alignment.center,
        width: _status == Status.none ? 60.w : 30.w,
        child: DefaultTextStyle(
          style: TextStyle(height: 1.2, fontSize: 11.sp, color: primaryColor),
          child: renderWidget(),
        ),
      ),
    );
  }
}
