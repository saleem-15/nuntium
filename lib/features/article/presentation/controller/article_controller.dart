import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuntium/config/dependency_injection.dart';
import 'package:nuntium/core/cache/cache.dart';
import 'package:nuntium/features/home/presentation/model/article.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleController extends GetxController {
  late final WebViewController webViewController;
  late Article _article;

  @override
  void onInit() {
    super.onInit();

    _article = CacheData.getArticle()!;

    initWebController(_article.url!);
  }

  void initWebController(String url) {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  Future<bool> back() async {
    disposeArticleModule();
    return true;
  }
}
