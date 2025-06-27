import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/components/order.dart';
import 'package:qm_agricultural_machinery_services/utils/user_tap_feedback.dart';

class AppBarBottom extends StatelessWidget {
  final bool isActive;
  final OrderStatus saleOrder;
  final OrderStatus priceOrder;
  final Function(String key, [OrderStatus? order]) onChanged;

  const AppBarBottom({
    super.key,
    required this.onChanged,
    required this.isActive,
    required this.priceOrder,
    required this.saleOrder,
  });

  handleChangePriceOrder(order) {
    UserTapFeedback.selection();
    onChanged('price', order);
  }

  handleChangeSaleOrder(order) {
    UserTapFeedback.selection();
    onChanged('sale', order);
  }

  handleOpenDrawer() {
    UserTapFeedback.selection();
    onChanged('filter');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34.w,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OrderWidget(title: '价格', onChanged: handleChangePriceOrder, status: priceOrder),
          OrderWidget(title: '销量', onChanged: handleChangeSaleOrder, status: saleOrder),
          GestureDetector(
            onTap: handleOpenDrawer,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '筛选',
                  style: TextStyle(height: 1, fontSize: 13.sp, color: const Color(0xFF4A4A4A)),
                ),
                Icon(
                  QmIcons.filter,
                  size: 16.sp,
                  color: isActive ? const Color(0xFF3AC786) : const Color(0xFFCCCCCC),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
