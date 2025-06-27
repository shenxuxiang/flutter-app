import 'package:flutter/material.dart';
import 'agricultural_material/goods_item.dart';
import 'package:qm_agricultural_machinery_services/pages/service/service_sub_page/index.dart';

class PlantProtectionPage extends StatelessWidget {
  final String title;
  final bool author;

  const PlantProtectionPage({super.key, required this.title, required this.author});

  @override
  Widget build(BuildContext context) {
    return SubPage(
      title: title,
      author: author,
      categoryID: '102',
      goodsItemBuilder: (BuildContext context, dynamic data) {
        return GoodsItem(
          avatar: data['picUrl'],
          unit: data['priceUnit'],
          title: data['productName'],
          serverName: data['serverName'],
          goodsId: data['serviceProductId'],
          price: double.parse('${data['price']}'),
        );
      },
    );
  }
}
