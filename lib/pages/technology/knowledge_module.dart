import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';

import '../knowledge_base/knowledge_item.dart';

class KnowledgeModule extends StatelessWidget {
  final List<dynamic> sourceList;

  const KnowledgeModule({super.key, required this.sourceList});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in sourceList)
          KnowledgeItem(
            info: item,
            margin: sourceList.last == item ? EdgeInsets.fromLTRB(12.w, 0, 12.w, 0) : null,
          ),
      ],
    );
  }
}
