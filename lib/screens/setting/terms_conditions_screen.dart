import 'package:carkett/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class TermsAndConditionsScreen extends StatelessWidget {
  TermsAndConditionsScreen({super.key});
  late WebViewController webViewControllerFull;

  Future<WebViewController> setController() async {
    final htmlString =
        await rootBundle.loadString('assets/doc/Terms and Conditions.html');
    final uri = Uri.dataFromString(htmlString, mimeType: 'text/html');
    WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            const Center(child: CircularProgressIndicator());
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(uri);
    return webViewController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.termsAndConditions),
      ),
      body: FutureBuilder(
        future: setController(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return WebViewWidget(controller: snapshot.data!);
        },
      ),
    );
  }
}
