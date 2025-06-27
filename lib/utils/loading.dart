import 'package:vector_math/vector_math_64.dart' show Vector3, Quaternion, Matrix3;
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'dart:async';

typedef CloseLoading = Future<void> Function([Duration? delay]);

enum LoadingStatus { none, active, inactive }

class LoadingTask {
  final int id;
  final String message;
  final BuildContext context;

  OverlayState? overlayState;
  OverlayEntry? overlayEntry;
  LoadingWidgetState? loadingWidgetState;
  LoadingStatus status = LoadingStatus.none;

  LoadingTask({required this.context, required this.message, required this.id});

  void start() {
    /// 如果 Loading 任务不是初始状态，则不执行
    if (status != LoadingStatus.none) return;

    /// 如果 Loading 任务的构建上下文已经卸载，则不执行
    if (!context.mounted) {
      status = LoadingStatus.inactive;
      return;
    }

    status = LoadingStatus.active;
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return LoadingWidget(
          message: message,
          onMounted: (LoadingWidgetState state) {
            if (status == LoadingStatus.active) loadingWidgetState = state;
          },
          delay: const Duration(milliseconds: 500),
          animationDuration: const Duration(milliseconds: 200),
          animationReverseDuration: const Duration(milliseconds: 150),
        );
      },
    );
    overlayState!.insert(overlayEntry!);
  }

  Future<void> close([Duration? delay]) async {
    switch (status) {
      case LoadingStatus.active:
        status = LoadingStatus.inactive;
        await loadingWidgetState?.willClose(delay: delay);
        overlayEntry?.remove();
        overlayEntry?.dispose();
      case LoadingStatus.none:
        status = LoadingStatus.inactive;
      default:
    }
  }
}

/// message 最多展示八个字
class Loading {
  static int uniID = 0;

  /// 任务队列
  static final List<LoadingTask> _tasks = [];

  static CloseLoading show({String message = '加载中···'}) {
    final ctx = GlobalVars.context!;
    final isEmptyQueue = _tasks.isEmpty;
    final task = LoadingTask(context: ctx, message: message, id: uniID++);

    /// 添加至任务队列，（如果task没有添加至任务队列，页面关闭时将无法关闭当前显示的 Loading）
    _tasks.add(task);
    Future<void> onClose([Duration? delay]) async {
      await task.close(delay);
      await Future.delayed(const Duration(milliseconds: 300));
      _tasks.remove(task);

      for (int i = 0; i < _tasks.length; i++) {
        final item = _tasks[i];
        if (item.status == LoadingStatus.active) {
          /// 有 Loading 任务正在执行
          return;
        } else if (item.status == LoadingStatus.none) {
          /// 可以执行该 Loading 任务
          item.start();
          return;
        }
      }
    }

    /// 队列为空，则立即执行
    if (isEmptyQueue) task.start();
    return onClose;
  }

  /// Loading.close() 属于强制关闭 Loading 的方法。
  static close(BuildContext context) async {
    for (int i = 0; i < _tasks.length;) {
      final task = _tasks[i];
      if (task.status == LoadingStatus.inactive) {
        _tasks.remove(task);
      } else if (task.context == context) {
        /// 没有延迟，直接关闭
        await task.close(Duration.zero);
        _tasks.remove(task);
      } else {
        i++;
      }
    }
  }
}

class LoadingWidget extends StatefulWidget {
  /// Loading 提示信息
  final String? message;

  /// 延迟打开、关闭 Loading 的时长，这主要是为了防抖（闪屏的现象）
  final Duration delay;

  /// 开始动画持续时间
  final Duration animationDuration;

  /// 关闭动画持续时间
  final Duration animationReverseDuration;

  /// Widget 渲染完成回调
  final Function(LoadingWidgetState instance) onMounted;

  const LoadingWidget({
    super.key,
    this.message,
    required this.delay,
    required this.onMounted,
    required this.animationDuration,
    required this.animationReverseDuration,
  });

  @override
  State<LoadingWidget> createState() => LoadingWidgetState();
}

class LoadingWidgetState extends State<LoadingWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  Timer? _timer;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.animationDuration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.ease);

    _timer = Timer(widget.delay, () {
      _timer = null;
      _controller.forward();
    });

    widget.onMounted(this);
    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> willClose({Duration? delay}) async {
    _timer?.cancel();
    if (_timer == null) {
      await Future.delayed(delay ?? widget.delay);
      if (!mounted) return;

      _controller.reverseDuration = widget.animationReverseDuration;
      await _controller.reverse();
    }
  }

  Matrix4 onTransform(double value) {
    return Matrix4Tween(
      begin:
          _controller.status == AnimationStatus.forward
              ? Matrix4.compose(
                Vector3(0, -50, 0),
                Quaternion.fromRotation(Matrix3.zero()),
                Vector3(0.7, 0.7, 1),
              )
              : Matrix4.identity(),
      end: Matrix4.identity(),
    ).lerp(value);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        alignment: const Alignment(0, -0.25),
        children: [
          Positioned(
            top: 0,
            left: 0,
            width: size.width,
            height: size.height,
            child: FadeTransition(
              opacity: _animation,
              child: Container(constraints: BoxConstraints.tight(size), color: Colors.black12),
            ),
          ),
          Positioned(
            height: 54.w,
            child: FadeTransition(
              opacity: _animation,
              child: MatrixTransition(
                animation: _animation,
                onTransform: onTransform,
                alignment: Alignment.topCenter,
                child: IntrinsicWidth(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      color: const Color(0xFF34332E).withAlpha(opacity2Alpha(0.9)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 16.w),
                    constraints: BoxConstraints(maxWidth: 200.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 22.w,
                          height: 22.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            strokeCap: StrokeCap.round,
                            valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                          ),
                        ),
                        widget.message?.isEmpty ?? true
                            ? const SizedBox()
                            : Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: Text(
                                  maxLines: 1,
                                  widget.message!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(height: 1, fontSize: 15.sp, color: Colors.white),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
