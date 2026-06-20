import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nuntium/config/dependency_injection.dart';
import 'package:nuntium/core/network/network_info.dart';
import 'package:nuntium/core/resources/app_assets.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'package:nuntium/core/widgets/app_back_button.dart';
import 'package:nuntium/core/widgets/primary_button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class OriginalArticleWebView extends StatefulWidget {
  final String url;

  const OriginalArticleWebView({
    super.key,
    required this.url,
  });

  @override
  State<OriginalArticleWebView> createState() => _OriginalArticleWebViewState();
}

class _OriginalArticleWebViewState extends State<OriginalArticleWebView> {
  late final WebViewController webViewController;
  bool isLoading = true;
  bool isError = false;
  final _networkInfo = getIt<NetworkInfo>();

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      // Add channel to receive (page is loaded) message
      ..addJavaScriptChannel(
        'PageLoadChannel',
        onMessageReceived: (JavaScriptMessage message) {
          // When the page is 'Ready' (page content is visible to the user) remove loading animation
          if (message.message == 'DomReady') {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (_) => NavigationDecision.navigate,
          onPageStarted: _onPageStarted,
          onProgress: _onProgress,
          onPageFinished: _onPageFinished,
          onWebResourceError: _onWebResourceError,
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _onPageStarted(String url) {
    if (mounted) {
      setState(() {
        isLoading = true;
        isError = false;
      });
    }
  }

  /// Early JavaScript injection
  void _onProgress(int progress) {
    if (progress > 10) {
      _injectDomListener();
    }
  }

  /// Late JavaScript injection, Acts as a fallback if the early injection has failed
  /// Checks if the event was already missed and manually triggers the "stop loading" logic if the page is already done.
  void _onPageFinished(String url) {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
    _injectDomListener();
  }

  Future<void> _onWebResourceError(WebResourceError error) async {
    // if an error happened to main frame (Not minor error)
    if (error.isForMainFrame ?? false) {
      if (mounted) {
        setState(() {
          isLoading = false;
          isError = true;
        });
      }

      if (!await _networkInfo.isConnected) {
        if (mounted) {
          setState(() {
            isLoading = false;
            isError = true;
          });
        }

        // Load empty page to hide No internet error page
        await webViewController.loadHtmlString(
          "<html><body style='background-color: white;'></body></html>",
        );
      }
    }
  }

  /// Injects JavaScript code that monitors if the page is ready (page content is viewed for the user)
  void _injectDomListener() {
    webViewController.runJavaScript('''
      // نتحقق مما إذا كانت الصفحة جاهزة بالفعل
      if (document.readyState === "complete" || document.readyState === "interactive") {
        PageLoadChannel.postMessage('DomReady');
      } else {
        // إذا لم تكن جاهزة، نستمع لحدث DOMContentLoaded
        window.addEventListener('DOMContentLoaded', (event) => {
          PageLoadChannel.postMessage('DomReady');
        });
      }
    ''');
  }

  void onRefresh() async {
    // عند المحاولة مرة أخرى، نخفي واجهة الخطأ ونعيد التحميل
    if (await _networkInfo.isConnected) {
      if (mounted) {
        setState(() {
          isError = false;
          isLoading = true;
        });
      }
      webViewController.loadRequest(Uri.parse(widget.url));
    } else {
      // إذا لا يزال لا يوجد إنترنت، نبقي حالة الخطأ
      if (mounted) {
        setState(() {
          isError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(
          context.tr(AppStrings.originalArticle),
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. The WebView Widget
          WebViewWidget(controller: webViewController),

          // 2. Loading & Error Handling
          if (isLoading)
            Center(child: Lottie.asset(AppAssets.loading, width: 150))
          else if (isError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    AppAssets.errorNoInternet,
                    width: 200,
                    repeat: false,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: PrimaryButton(
                      text: context.tr(AppStrings.retry),
                      onPressed: onRefresh,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
