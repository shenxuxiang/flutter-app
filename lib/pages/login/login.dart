import 'package:get/get.dart';
import 'components/quick_login.dart';
import 'package:flutter/material.dart';
import 'components/account_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/keep_alive.dart';

class LoginPage extends BasePage {
  const LoginPage({super.key, required super.title, super.author = false});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BasePageState<LoginPage> with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final bool _isLogout;

  int _activeKey = 0;
  double _indicatorAlign = -1;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _isLogout = Get.parameters.containsKey('is_logout');
    super.initState();
  }

  void navigateToAccountLogin() {
    if (_activeKey == 1) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _activeKey = 1;
      _indicatorAlign = 1;
    });
    _pageController.jumpToPage(1);
  }

  void navigateToQuickLogin() {
    if (_activeKey == 0) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _activeKey = 0;
      _indicatorAlign = -1;
    });
    _pageController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return PopScope(
      // 关闭右滑返回上一页
      canPop: false,
      child: Material(
        type: MaterialType.card,
        child: Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              alignment: Alignment.topLeft,
              image: AssetImage('assets/images/login_bg.png'),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(top: 51.w)),
              Align(
                widthFactor: 1,
                heightFactor: 1,
                alignment: Alignment.center,
                child: Image.asset('assets/images/login_logo.png', width: 93.w, height: 93.w),
              ),
              Padding(padding: EdgeInsets.only(top: 33.w)),
              Container(
                width: 336.w,
                height: 434.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 快捷登录、账号登录
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: navigateToQuickLogin,
                          child: Container(
                            width: 61.w,
                            height: 39.w,
                            color: Colors.transparent,
                            padding: const EdgeInsets.only(top: 20, bottom: 4),
                            child: Text(
                              '快捷登录',
                              style: TextStyle(
                                height: 1,
                                fontSize: 15.sp,
                                color:
                                    _activeKey == 0
                                        ? const Color(0xFF3AC786)
                                        : const Color(0xFF4A4A4A),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: navigateToAccountLogin,
                          child: Container(
                            width: 61.w,
                            height: 39.w,
                            color: Colors.transparent,
                            padding: const EdgeInsets.only(top: 20, bottom: 4),
                            child: Text(
                              '账号登录',
                              style: TextStyle(
                                height: 1,
                                fontSize: 15.sp,
                                // fontWeight: FontWeight.bold,
                                color:
                                    _activeKey == 1
                                        ? const Color(0xFF3AC786)
                                        : const Color(0xFF4A4A4A),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// 指针指示器
                    Align(
                      heightFactor: 1,
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 152.3333.w,
                        height: 3.w,
                        child: AnimatedAlign(
                          alignment: AlignmentDirectional(_indicatorAlign, -1),
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.ease,
                          child: Container(
                            width: 20.w,
                            height: 3.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFF3AC786),
                              borderRadius: BorderRadius.all(Radius.circular(2)),
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// 面板
                    Expanded(
                      child: FocusScope(
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            KeepAliveWidget(child: QuickLogin(isLogout: _isLogout)),
                            KeepAliveWidget(child: AccountLogin(isLogout: _isLogout)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
