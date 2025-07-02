import 'package:flutter/material.dart';
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';

typedef DrawerBuilder = Widget Function(BuildContext context, void Function() close);

class QmDrawer {
  static show({BuildContext? context, required DrawerBuilder builder, double? width}) {
    final ctx = context ?? GlobalVars.context!;

    handleClose() {
      Navigator.of(ctx).pop();
    }

    showGeneralDialog(
      context: ctx,
      barrierDismissible: true,
      barrierColor: Colors.black38,
      barrierLabel: 'QM_DRAWER_DIALOG',
      transitionBuilder: (_, _, _, Widget child) => child,
      pageBuilder: (BuildContext context, a1, a2) {
        final size = MediaQuery.sizeOf(context);
        final viewPadding = MediaQuery.viewPaddingOf(context);
        final position = a1
            .drive(CurveTween(curve: Curves.ease))
            .drive(Tween(begin: const Offset(1, 0), end: const Offset(0, 0)));

        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Positioned(
                top: viewPadding.top + kToolbarHeight,
                right: 0,
                child: SlideTransition(
                  position: position,
                  child: Container(
                    width: width,
                    color: Colors.white,
                    height: size.height - viewPadding.top - kToolbarHeight,
                    child: builder(context, handleClose),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
