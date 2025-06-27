import 'global_vars.dart';
import 'package:flutter/material.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';

// 监听全局路由变化
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

abstract class BasePage extends StatefulWidget {
  final bool author;
  final String title;

  const BasePage({super.key, required this.title, required this.author});
}

abstract class BasePageState<T extends BasePage> extends State<T>
    with RouteAware, WidgetsBindingObserver {
  @override
  void initState() {
    onLoad();

    /// 添加对 APP 生命周期的监听
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      GlobalVars.context = context;
      onMounted();

      /// 注册路由监听
      routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    });
    super.initState();
  }

  @override
  /// dispose() 并不是在页面关闭后立即执行。
  /// 从页面关闭到组件完全被卸载这中间会有延迟。
  void dispose() {
    /// 取消注册，防止内存泄漏
    onUnload();

    /// 取消对 APP 生命周期的监听
    WidgetsBinding.instance.removeObserver(this);

    /// 取消路由监听
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  /// 当一个新的页面被添加到路由栈的最顶层时触发。
  /// didPush() 总是在上一个页面的 didPushNext() 之后执行。
  void didPush() {}

  @override
  /// 当页面从路由栈中移除时触发，
  /// didPop() 总是在上一个页面的 didPopNext() 之后执行。
  /// didPop() 总是在在页面的 dispose() 之前执行。
  /// 注意，在子类中重写时请调用 super.didPop()。
  void didPop() {
    /// 关闭 Toast、Loading 提示
    Toast.close();
    Loading.close(context);

    /// 页面即将卸载。
    onWillUnmount();
  }

  @override
  /// 当往路由栈中添加一个新路由时触发，原有页面将被新页面遮蔽。
  /// didPushNext() 总是在新路由页面的 didPush() 之前执行。
  void didPushNext() {}

  @override
  /// 当路由栈最顶层的路由被移除后，原有的路由又变成路由栈最顶层路由时触发，此时页面由原先被遮蔽的状态恢复成可见状态
  /// didPopNext() 总是在被移除的路由页面的 didPop() 之前执行。
  /// 注意，在子类中重写时请调用 super.didPopNext()。
  void didPopNext() {
    /// 从其他页面返回后时触发
    GlobalVars.context = context;
  }

  /// 监听 APP 的运行状态（后台/前台）
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      /// App 回到前台
      case AppLifecycleState.resumed:
        if (context == GlobalVars.context) onShow();
        break;

      /// App 进入后台
      case AppLifecycleState.paused:
        if (context == GlobalVars.context) onHide();
        break;

      /// 不监听其他状态
      default:
        break;
    }
  }

  @protected
  /// 页面由隐藏状态变为可见状态时触发
  void onShow() {}

  @protected
  ///  页面由可见状态变为隐藏状态时触发
  void onHide() {}

  @protected
  /// 页面卸载时触发
  void onUnload() {}

  @protected
  /// 页面加载时触发
  void onLoad() {}

  @protected
  /// 页面挂在成功后触发，此时可以访问 context
  void onMounted() {}

  @protected
  /// 页面即将销毁之前触发
  void onWillUnmount() {}
}
