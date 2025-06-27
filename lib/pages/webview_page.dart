import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/utils/js_bridge.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart' show getStorageUserToken;

class WebViewPage extends BasePage {
  const WebViewPage({super.key, required super.author, required super.title});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends BasePageState<WebViewPage> {
  late final WebViewController controller;
  late final JSBridge jsBridge;
  String _title = '';
  late Uri _uri;
  CloseLoading? closeLoading;

  @override
  void onMounted() {
    closeLoading = Loading.show();
  }

  @override
  void onLoad() {
    _title = '';
    String url = Get.arguments!;
    final token = getStorageUserToken()!;
    _uri = Uri.parse('$url&token=$token');

    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (String url) async {
                closeLoading!();
              },
              onUrlChange: (UrlChange _) async {
                await Future.delayed(const Duration(milliseconds: 500));
                final title = await controller.getTitle();
                setState(() {
                  _title = title ?? widget.title;
                });
              },
              onNavigationRequest: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(_uri);

    jsBridge = JSBridge(controller: controller);
  }

  @override
  dispose() {
    jsBridge.dispose();
    super.dispose();
  }

  handleBack() async {
    final canGoBack = await controller.canGoBack();

    if (canGoBack) {
      await controller.goBack();
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(_title),
          leading: GestureDetector(
            onTap: handleBack,
            child: Icon(QmIcons.back, color: const Color(0xFF333333)),
          ),
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
