import 'package:qm_agricultural_machinery_services/utils/utils.dart';

import 'common/app_location_service.dart';
import 'routes.dart';
import 'models/home.dart';
import 'models/main.dart';
import 'utils/storage.dart';
import 'utils/load_env.dart';
import 'models/publish.dart';
import 'package:get/get.dart';
import 'common/base_page.dart';
import 'utils/user_tap_feedback.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qm_agricultural_machinery_services/models/mine.dart';
import 'package:qm_agricultural_machinery_services/utils/permissions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnv();
  await Storage.init();
  await UserTapFeedback.init();
  await Permissions.requestLocation();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await AppLocationService.initialize();
  runApp(const MyApp());
}

class GlobalBindings extends Bindings {
  @override
  dependencies() {
    Get.put(HomeModel());
    Get.put<MineModel>(MineModel(), permanent: true);
    Get.put<PublishModel>(PublishModel(), permanent: true);
    final mainModel = Get.put<MainModel>(MainModel(), permanent: true);
    // APP 初始化时获取用户信息，可能为 null。
    mainModel.setUserInfo(getStorageUserInfo());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: false,
      splitScreenMode: true,
      child: GetMaterialApp(
        builder: (BuildContext context, Widget? child) {
          final mediaQuery = MediaQuery.of(context);
          return MediaQuery(
            data: mediaQuery.copyWith(
              /// App 字体大小不随 Andorid 系统字体大小调整而进行不缩放
              textScaler: TextScaler.noScaling,
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
        title: '爱农田',
        getPages: routes,
        popGesture: true,
        initialRoute: '/home?tab=0',
        initialBinding: GlobalBindings(),
        navigatorObservers: [routeObserver],
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'SiYuan',
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3AC786)),
          hintColor: const Color(0xFF999999),
          shadowColor: const Color(0xFFF1FBF5),
          primaryColor: const Color(0xFF3AC786),
          disabledColor: const Color(0xFF89DDB6),
          indicatorColor: const Color(0xFF3AC786),
          primaryColorDark: const Color(0xFF288B5D),
          primaryColorLight: const Color(0xFFEBF9F2),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(size: 26, color: Colors.white),
            titleTextStyle: TextStyle(fontSize: 16, height: 1, color: Color(0xFF333333)),
            systemOverlayStyle: SystemUiOverlayStyle(
              // 系统顶部导航栏的颜色
              statusBarColor: Colors.transparent,
              // 设置顶部导航 icon 的颜色（仅适用于 IOS）
              statusBarBrightness: Brightness.dark,
              // 设置顶部导航 icon 的颜色（仅适用于 Android）
              statusBarIconBrightness: Brightness.dark,
              // 系统底部导航栏的颜色
              systemNavigationBarColor: Colors.black,
            ),
          ),
        ),
        supportedLocales: const [
          Locale('en', 'US'), // 英文
          Locale('zh', 'CN'), // 简体中文
        ],
        localizationsDelegates: [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
