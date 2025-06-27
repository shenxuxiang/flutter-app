import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qm_agricultural_machinery_services/utils/user_tap_feedback.dart';

class AiRobot extends StatelessWidget {
  const AiRobot({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        UserTapFeedback.selection();
        Get.toNamed('/webview_page', arguments: 'http://60.169.69.3:30054/');
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: const DecorationImage(
            image: AssetImage('assets/images/home/ic_system_airobat.png'),
          ),
          boxShadow: [
            const BoxShadow(color: Color(0x99999999), offset: Offset(0, 2), blurRadius: 4),
          ],
        ),
      ),
    );
  }
}
