import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';

/// 时间选择类型
typedef OnDateTimePickerConfirm = void Function(DateTime date);

/// 日期选择类型
typedef OnDatePickerConfirm = void Function(DateTime? date);

/// 日期范围选择类型
typedef OnDateRangePickerConfirm = void Function(DateTime? startTime, DateTime? endTime);

class DatePicker {
  static OverlayEntry? _overlayEntry;
  static OverlayState? _overlayState;

  /// 时间控件
  static showDateTimePicker({
    DateTime? dateTime,
    BuildContext? context,
    VoidCallback? onCancel,
    required OnDateTimePickerConfirm onConfirm,
  }) async {
    final ctx = context ?? GlobalVars.context!;
    final primaryColor = Theme.of(ctx).primaryColor;

    DateTime? result = await showOmniDateTimePicker(
      context: ctx,
      is24HourMode: true,
      isShowSeconds: false,
      initialDate: dateTime,
      padding: const EdgeInsets.symmetric(vertical: 16),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      separator: const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          // 主题颜
          seedColor: primaryColor,
          // 主题颜
          primary: primaryColor,
          surfaceContainerHigh: Colors.white,
          // 字体颜色
          onSurface: Colors.black,
          // 被选中的字体颜色
          onPrimary: Colors.white,
          primaryFixed: Colors.red,
        ),
      ),
    );
    if (result == null) {
      onCancel?.call();
    } else {
      onConfirm.call(
        DateTime(result.year, result.month, result.day, result.hour, result.minute, 0),
      );
    }
  }

  /// 日期控件
  static showDatePicker({
    DateTime? dateTime,
    BuildContext? context,
    VoidCallback? onCancel,
    required OnDatePickerConfirm onConfirm,
  }) {
    final ctx = context ?? GlobalVars.context!;

    void onClose() {
      _overlayEntry?.remove();
      _overlayEntry?.dispose();
    }

    handleConfirm(dynamic date) {
      onConfirm(date);
      onClose();
    }

    handleCancel() {
      if (onCancel is Function) onCancel!();
      onClose();
    }

    _overlayState = Overlay.of(ctx);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return _DatePickerWidget(
          dateTime: dateTime,
          onCancel: handleCancel,
          onConfirm: handleConfirm,
          mode: DateRangePickerSelectionMode.single,
        );
      },
    );

    _overlayState!.insert(_overlayEntry!);
  }

  /// 日期范围控件
  static showDateRangePicker({
    DateTime? endTime,
    DateTime? startTime,
    BuildContext? context,
    VoidCallback? onCancel,
    required OnDateRangePickerConfirm onConfirm,
  }) {
    final ctx = context ?? GlobalVars.context!;

    void onClose() {
      _overlayEntry?.remove();
      _overlayEntry?.dispose();
    }

    handleConfirm(dynamic date) {
      onConfirm(date?.startDate, date?.endDate?.add(const Duration(seconds: 24 * 3600 - 1)));
      onClose();
    }

    handleCancel() {
      if (onCancel is Function) onCancel!();
      onClose();
    }

    _overlayState = Overlay.of(ctx);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return _DatePickerWidget(
          endTime: endTime,
          startTime: startTime,
          onCancel: handleCancel,
          onConfirm: handleConfirm,
          mode: DateRangePickerSelectionMode.range,
        );
      },
    );

    _overlayState!.insert(_overlayEntry!);
  }
}

class _DatePickerWidget extends StatefulWidget {
  final DateTime? endTime;
  final DateTime? dateTime;
  final DateTime? startTime;
  final VoidCallback? onCancel;
  final DateRangePickerSelectionMode mode;
  final void Function(dynamic value) onConfirm;

  const _DatePickerWidget({
    super.key,
    this.endTime,
    this.dateTime,
    this.onCancel,
    this.startTime,
    required this.onConfirm,
    this.mode = DateRangePickerSelectionMode.single,
  });

  @override
  State<_DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<_DatePickerWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.ease);

    _animationController.forward();
    super.initState();
  }

  Future<void> willClose() async {
    await _animationController.reverse();
  }

  handleCancel() async {
    await willClose();
    if (widget.onCancel is Function) widget.onCancel!();
  }

  handleConfirm(dynamic value) async {
    await willClose();
    widget.onConfirm(value);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          FadeTransition(
            opacity: _animation,
            child: Container(color: Colors.black.withAlpha(opacity2Alpha(0.4))),
          ),
          Positioned(
            top: 200,
            child: FadeTransition(
              opacity: _animation,
              child: Container(
                width: 336,
                height: 380,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: SfDateRangePicker(
                  headerHeight: 50,
                  cancelText: '取消',
                  confirmText: '确认',
                  onCancel: handleCancel,
                  onSubmit: handleConfirm,
                  showActionButtons: true,
                  toggleDaySelection: false,
                  showNavigationArrow: true,
                  selectionColor: primaryColor,
                  backgroundColor: Colors.white,
                  todayHighlightColor: primaryColor,
                  initialSelectedDate: widget.dateTime,
                  endRangeSelectionColor: primaryColor,
                  startRangeSelectionColor: primaryColor,
                  selectionMode: widget.mode,
                  initialSelectedRange: PickerDateRange(widget.startTime, widget.endTime),
                  // selectableDayPredicate: (DateTime date) => date.compareTo(DateTime.now()) > -1,
                  headerStyle: DateRangePickerHeaderStyle(
                    textAlign: TextAlign.center,
                    backgroundColor: primaryColor,
                    textStyle: const TextStyle(fontSize: 16, color: Colors.white),
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
