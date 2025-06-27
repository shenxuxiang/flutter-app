import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart' show getNetworkAssetURL;

class BannerWidget extends StatelessWidget {
  final int index;
  final List<dynamic> bannerList;
  final void Function(int index)? onChanged;

  const BannerWidget({super.key, required this.bannerList, this.index = 0, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Swiper(
      index: index,
      onIndexChanged: onChanged,
      itemCount: bannerList.length,
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(getNetworkAssetURL(bannerList[index])),
            ),
          ),
        );
      },
      autoplay: true,
      autoplayDelay: 5000,
      pagination: SwiperPagination(
        alignment: Alignment.bottomCenter,
        margin: const EdgeInsets.all(8),
        builder: DotSwiperPaginationBuilder(
          size: 7.w,
          space: 4.w,
          activeSize: 7.w,
          color: const Color(0xFFB9B9B9),
          activeColor: primaryColor,
        ),
      ),
    );
  }
}
