import 'dart:io';
import 'toast.dart';
import 'load_env.dart';
import 'package:dio/io.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' show Get, GetNavigation;
import 'utils.dart' show printLog, getStorageUserToken;
import 'package:qm_agricultural_machinery_services/entity/response_data.dart';

CancelToken _cancelToken = CancelToken();

/// DioExceptionType 不同类型对应的错误提示
const _errorMessage = {
  DioExceptionType.unknown: '未知异常！',
  DioExceptionType.cancel: '请求被取消！',
  DioExceptionType.sendTimeout: '数据发送超时！',
  DioExceptionType.badResponse: '网络响应异常！',
  DioExceptionType.receiveTimeout: '数据接收超时！',
  DioExceptionType.connectionError: '网络连接失败！',
  DioExceptionType.connectionTimeout: '网络连接超时！',
};

// 取消请求
void _abortHttpRequest() {
  _cancelToken.cancel('HTTP 请求已取消');
  _cancelToken = CancelToken();
}

// 导航去登录页面
void _navigateToLogin() {
  String route = Get.currentRoute;

  if (route != '/login') {
    if (RegExp(r'^/home').hasMatch(Get.currentRoute)) {
      Get.toNamed('/login');
    } else {
      Get.offNamed('/login');
    }
  }
}

/// 根据 HTTP 请求状态码返回对应的错误信息
String _getErrorStatusMessage(int? statusCode) {
  switch (statusCode) {
    case 400:
      return "请求语法错误";
    case 403:
      return "禁止访问";
    case 404:
      return "找不到资源";
    case 405:
      return "请求方法错误";
    case 500 || 502 || 503:
      return "服务器异常";
    case 505:
      return "不支持该协议";
    default:
      return "未知异常";
  }
}

class _Interceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.cancelToken = _cancelToken;
    options.headers = {'Authorization': 'Bearer ${getStorageUserToken()}'};
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.responseType == ResponseType.stream) return handler.next(response);

    final data = ResponseData.fromJson(response.data);
    if (data.code == 0) {
      handler.resolve(
        Response<ResponseData>(
          data: data,
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          requestOptions: response.requestOptions,
        ),
      );
    } else {
      String message = data.message.isNotEmpty ? data.message : '未知异常';

      if (data.code == 401) {
        // message = '用户无权限';
        Toast.show(message);
        _abortHttpRequest();
        Future.delayed(const Duration(milliseconds: 500), () => _navigateToLogin());
      } else {
        Toast.show(message);
      }

      /// 注意，Interceptor.onResponse() 中抛出的异常不会被 Interceptor.onError() 捕获；
      /// 该异常将被 请求的 .catchError() 捕获。
      printLog(response.requestOptions.path);
      handler.reject(
        DioException(requestOptions: response.requestOptions, response: response, message: message),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message = '';
    if (err.type == DioExceptionType.badResponse) {
      final statusCode = err.response!.statusCode;
      message = _getErrorStatusMessage(statusCode);

      if (statusCode == 401) {
        message = '用户无权限';
        Toast.show(message);
        _abortHttpRequest();
        Future.delayed(const Duration(milliseconds: 500), () => _navigateToLogin());
      } else {
        Toast.show(message);
      }
    } else {
      message = _errorMessage[err.type]!;

      // 如果请求被取消，则不需要触发 Toast
      if (err.type != DioExceptionType.cancel) Toast.show(message);
    }
    printLog(err.requestOptions.path);
    handler.reject(err);
  }
}

typedef SendProgress = void Function(int, int);
typedef ReceiveProgress = void Function(int, int);

final BaseOptions _baseOptions = BaseOptions(
  baseUrl: getEnv('WEBSITE_BASE_URL')!,
  sendTimeout: const Duration(seconds: 60),
  connectTimeout: const Duration(seconds: 60),
  receiveTimeout: const Duration(seconds: 60),
);

class HttpRequest {
  late final Dio _dio;

  HttpRequest._internal() {
    _dio = Dio(_baseOptions);

    _dio.interceptors.add(_Interceptor());

    if (getEnv('ENABLE_PROXY') == 'true') _enableProxy();
  }

  static final HttpRequest _singleton = HttpRequest._internal();

  factory HttpRequest() => _singleton;

  // 启用代理
  _enableProxy() {
    String address = getEnv('PROXY_ADDRESS') ?? '';
    if (address.isNotEmpty) {
      _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.findProxy = (uri) => address;
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          // You can also create a new HttpClient for Dio instead of returning,
          // but a client must being returned here.
          return client;
        },
      );
    }
  }

  Future<ResponseData> post(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    SendProgress? onSendProgress,
    ReceiveProgress? onReceiveProgress,
  }) async {
    final resp = await _dio.post<ResponseData>(
      url,
      data: data,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return resp.data!;
  }

  Future<ResponseData> get(
    String url, {
    Options? options,
    CancelToken? cancelToken,
    SendProgress? onSendProgress,
    ReceiveProgress? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
  }) async {
    final resp = await _dio.get<ResponseData>(
      url,
      options: options,
      cancelToken: cancelToken,
      queryParameters: queryParameters,
      onReceiveProgress: onReceiveProgress,
    );

    return resp.data!;
  }

  Future<ResponseData> delete(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final resp = await _dio.delete(url, data: data, options: options, cancelToken: cancelToken);

    return resp.data!;
  }

  Future<void> download(String url, String savePath) async {
    await _dio.download(
      url,
      savePath,
      options: Options(
        sendTimeout: const Duration(seconds: 600),
        receiveTimeout: const Duration(seconds: 600),
      ),
    );
  }
}

final request = HttpRequest();
