import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class Webviewsaanjhbati extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const Webviewsaanjhbati({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<Webviewsaanjhbati> createState() => _WebviewsaanjhbatiState();
}

class _WebviewsaanjhbatiState extends State<Webviewsaanjhbati> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://bnpcdeveloper.co.in/bnpolice/saanjhbaati/saanjbaatiform'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : const Color(0xFFe9e4de),

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : const Color(0xFFe9e4de),
          title: const Text('Saanjhbati'),
          centerTitle: true,
        ),
      ),

      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
