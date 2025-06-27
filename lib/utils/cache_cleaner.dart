import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart'
    show getStorageUserToken, printLog;

class CacheCleaner {
  /// 清理图片内存缓存
  static void clearImageMemoryCache() {
    PaintingBinding.instance.imageCache.clear();

    /// 仅清除当前正在渲染或显示的图片（即 "live" 状态的图片），保留未被使用的缓存。
    // PaintingBinding.instance.imageCache.clearLiveImages();
  }

  /// 清理临时文件缓存（系统认可的缓存目录）
  static Future<bool> clearTempFiles() async {
    try {
      final dir = await getTemporaryDirectory();

      if (dir.existsSync()) dir.deleteSync(recursive: true);

      return true;
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
      return false;
    }
  }
}
