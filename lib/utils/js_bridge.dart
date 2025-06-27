import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class JSBridge {
  final WebViewController controller;

  JSBridge._({required this.controller}) {
    _initial();
  }

  factory JSBridge({required WebViewController controller}) {
    return JSBridge._(controller: controller);
  }

  dispose() {
    controller.removeJavaScriptChannel('JSBridge');
  }

  _initial() {
    controller.addJavaScriptChannel(
      'JSBridge',
      onMessageReceived: (JavaScriptMessage message) {
        _run(message);
      },
    );
  }

  /// 数据格式： { "type": "navigate", "arguments": "dynamic" };
  _run(JavaScriptMessage message) {
    final data = jsonDecode(message.message);
    final arguments = data['arguments'];
    final type = data['type'];

    switch (type) {
      case 'navigate':
        return _navigate(arguments);
      default:
        return debugPrint("$type; $arguments");
    }
  }

  _navigate(String path) async {
    await controller.runJavaScript(
      'if (typeof window.onPageHide === "function") window.onPageHide();',
    );
    await Get.toNamed(path);
    await controller.runJavaScript(
      'if (typeof window.onPageShow === "function") window.onPageShow();',
    );
  }
}
