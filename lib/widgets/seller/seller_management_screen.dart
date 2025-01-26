import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SellerManagementScreen extends StatefulWidget {
  const SellerManagementScreen({super.key});

  @override
  _SellerManagementScreenState createState() => _SellerManagementScreenState();
}

class _SellerManagementScreenState extends State<SellerManagementScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Puedes hacer un seguimiento del progreso de la carga si lo deseas
            print("Progreso de carga: $progress%");
          },
          onPageStarted: (String url) {
            print("Página iniciada: $url");
          },
          onPageFinished: (String url) {
            print("Página cargada: $url");
          },
          onHttpError: (HttpResponseError error) {
            print("Error HTTP: $error  ");
          },
          onWebResourceError: (WebResourceError error) {
            print("Error en recurso web: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            // Bloqueo de navegaciones específicas si es necesario
            if (request.url.startsWith('https://www.youtube.com/')) {
              print("Navegación bloqueada a: ${request.url}");
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://gestioware.pythonanywhere.com/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GestioWare WebView')),
      body: WebViewWidget(controller: controller),
    );
  }
}
