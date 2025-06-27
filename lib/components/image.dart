import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';

class ImageWidget extends StatelessWidget {
  final String image;
  final BoxFit fit;
  final double? width;
  final double? height;

  const ImageWidget({
    super.key,
    this.width,
    this.height,
    required this.image,
    this.fit = BoxFit.contain,
  });

  onOpenModal(BuildContext context) {
    final opacity = Rx<double>(0);
    Future.delayed(const Duration(milliseconds: 20), () => opacity.value = 1);
    showDialog(
      context: context,
      useSafeArea: false,
      barrierDismissible: true,
      barrierColor: Colors.black,
      builder: (BuildContext context) {
        return Obx(
          () => AnimatedOpacity(
            curve: Curves.ease,
            opacity: opacity.value,
            duration: const Duration(milliseconds: 200),
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: InteractiveViewer(
                      child:
                          image.startsWith('assets/images')
                              ? Image.asset(image, fit: fit)
                              : CachedNetworkImage(
                                fit: fit,
                                imageUrl:
                                    image.startsWith('http') ? image : getNetworkAssetURL(image),
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) return SizedBox(height: height, width: width);

    return GestureDetector(
      onTap: () => onOpenModal(context),
      child:
          image.startsWith('assets/images')
              ? Image.asset(image, height: height, width: width, fit: fit)
              : CachedNetworkImage(
                imageUrl: getNetworkAssetURL(image),
                height: height,
                width: width,
                fit: fit,
              ),
    );
  }
}
