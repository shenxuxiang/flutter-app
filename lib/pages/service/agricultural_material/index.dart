import 'goods_item.dart';
import 'package:flutter/material.dart';
import 'package:qm_agricultural_machinery_services/pages/service/service_sub_page/index.dart';

class AgriculturalMaterialPage extends StatelessWidget {
  final String title;
  final bool author;

  const AgriculturalMaterialPage({super.key, required this.title, required this.author});

  @override
  Widget build(BuildContext context) {
    return SubPage(
      title: title,
      author: author,
      categoryID: '100',
      goodsItemBuilder: (BuildContext context, dynamic data) {
        return GoodsItem(
          avatar: data['picUrl'],
          unit: data['priceUnit'],
          title: data['productName'],
          serverName: data['serverName'],
          goodsId: data['serviceProductId'],
          // 需要转一下，后台返回的数据不能直接使用（如果返回的是整数，则 Flutter认定为 int 类型）
          price: double.parse('${data['price']}'),
        );
      },
    );
  }
}
