import 'package:flutter/material.dart';
import 'agricultural_material/goods_item.dart';
import 'package:qm_agricultural_machinery_services/pages/service/service_sub_page/index.dart';

class LaborServicesPage extends StatelessWidget {
  final String title;
  final bool author;

  const LaborServicesPage({super.key, required this.title, required this.author});

  @override
  Widget build(BuildContext context) {
    return SubPage(
      title: title,
      author: author,
      categoryID: '103',
      goodsItemBuilder: (BuildContext context, dynamic data) {
        return GoodsItem(
          price: data['price'],
          avatar: data['picUrl'],
          unit: data['priceUnit'],
          title: data['productName'],
          serverName: data['serverName'],
          goodsId: data['serviceProductId'],
        );
      },
    );
  }
}
