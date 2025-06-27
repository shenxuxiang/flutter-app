import 'package:flutter/material.dart';
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';

typedef SheetDialogBuilder = Widget Function(BuildContext context);

Future<T?> showSheetDialog<T>({
  double radius = 14,
  double height = 360,
  BuildContext? context,
  required SheetDialogBuilder builder,
  Duration transitionDuration = const Duration(milliseconds: 250),
}) async {
  final ctx = context ?? GlobalVars.context!;

  final result = showGeneralDialog<T>(
    context: ctx,
    barrierDismissible: true,
    barrierColor: Colors.black45,
    barrierLabel: 'QM_SHEET_DIALOG',
    transitionDuration: transitionDuration,
    transitionBuilder: (
      BuildContext context,
      Animation<double> a1,
      Animation<double> a2,
      Widget? child,
    ) {
      return child!;
    },
    pageBuilder: (BuildContext context, Animation<double> a1, Animation<double> a2) {
      final size = MediaQuery.sizeOf(ctx);
      final renderChild = builder(context);
      final borderRadius = Radius.circular(radius);
      final animation = a1.drive(CurveTween(curve: Curves.ease));
      final translation = Tween(begin: const Offset(0, 1), end: const Offset(0, 0));

      return Material(
        type: MaterialType.transparency,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Positioned(
              left: 0,
              bottom: 0,
              child: AnimatedBuilder(
                animation: a1,
                builder: (BuildContext context, Widget? child) {
                  return FractionalTranslation(
                    translation: translation.evaluate(animation),
                    child: Container(
                      height: height,
                      width: size.width,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: borderRadius,
                          topRight: borderRadius,
                        ),
                      ),
                      child: child,
                    ),
                  );
                },
                child: renderChild,
              ),
            ),
          ],
        ),
      );
    },
  );
  return result;
}
