import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/user_tap_feedback.dart';
import 'package:qm_agricultural_machinery_services/entity/service_filter_type.dart';

final _filterList = [
  const ServiceFilterType(
    label: '化肥',
    value: '100000',
    img: 'assets/images/service/agricultural_machinery/chemical_fertilizer.png',
  ),
  const ServiceFilterType(
    label: '农药',
    value: '100001',
    img: 'assets/images/service/agricultural_machinery/farm_chemical.png',
  ),
  const ServiceFilterType(
    label: '种子',
    value: '100002',
    img: 'assets/images/service/agricultural_machinery/seed.png',
  ),
  const ServiceFilterType(
    label: '其他',
    value: '100003',
    img: 'assets/images/service/agricultural_machinery/other.png',
  ),
];

class FilterTypeWidget extends StatelessWidget {
  final ServiceFilterType? value;
  final void Function(ServiceFilterType? type) onChanged;

  const FilterTypeWidget({super.key, this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95.w,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final item in _filterList)
            GestureDetector(
              onTap: () {
                UserTapFeedback.selection();
                if (value == item) {
                  onChanged(null);
                } else {
                  onChanged(item);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 47.w,
                    height: 47.w,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(28)),
                      color:
                          value?.value == item.value
                              ? const Color(0xFFd8f3e6)
                              : const Color(0xFFF7F8F8),
                    ),
                    child: Align(
                      child: Image.asset(item.img!, width: 24.w, height: 24.w, fit: BoxFit.contain),
                    ),
                  ),
                  SizedBox(height: 6.w),
                  Text(
                    item.label,
                    style: TextStyle(height: 1, fontSize: 11.sp, color: const Color(0xFF4A4A4A)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
