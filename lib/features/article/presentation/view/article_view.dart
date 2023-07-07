import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuntium/features/article/presentation/controller/article_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends GetView<ArticleController> {
  const ArticleView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.back,
      child: Scaffold(
        body: SafeArea(
          child: WebViewWidget(
            controller: controller.webViewController,
          ),
        ),
      ),
    );
  }
}
