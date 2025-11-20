import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class webviewtennatpage extends StatefulWidget {
   final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const webviewtennatpage({super.key, required this.onThemeChanged, required this.isDarkMode});

  @override
  State<webviewtennatpage> createState() => _webviewtennatpageState();
}

class _webviewtennatpageState extends State<webviewtennatpage> {
  late WebViewController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);

    controller.loadRequest(
      Uri.parse('https://bnpcdeveloper.co.in/bnpolice/tenantbdn/tenantform'),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : const Color(0xFFe9e4de),
      appBar: AppBar(
             backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : const Color(0xFFe9e4de),
        title: Text('Tenant Form'),centerTitle: true,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
