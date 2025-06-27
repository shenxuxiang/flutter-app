import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 加载环境变量
///
/// 开发环境 flutter run --dart-define=ENV=development
/// 生产构建 flutter build apk --dart-define=ENV=development
Future<void> loadEnv() async {
  // 必须使用常量的形式定义，否则获取不到环境变量
  String env = const String.fromEnvironment('ENV');
  await dotenv.load(fileName: env == 'development' ? '.env.dev' : '.env.prod');
}

String? getEnv(String key) {
  if (dotenv.env.containsKey(key)) {
    return dotenv.env[key];
  } else {
    return null;
  }
}


