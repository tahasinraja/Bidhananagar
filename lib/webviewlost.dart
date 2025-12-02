import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class webviewlostpage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const webviewlostpage({super.key,required this.onThemeChanged,required this.isDarkMode});

  @override
  State<webviewlostpage> createState() => _webviewlostpageState();
}

class _webviewlostpageState extends State<webviewlostpage> {
  late WebViewController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://bnpcdeveloper.co.in/bnpolice/lost/lostform.php')); 
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : const Color(0xFFe9e4de),
      appBar: PreferredSize(preferredSize: Size.fromHeight(40), child: AppBar(
         backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : const Color(0xFFe9e4de),
title: Row(

  children: [
    Text('Lost Form'),
   // Spacer(),
    // TextButton(onPressed: (){Navigator.push(context,
    //  MaterialPageRoute(builder: (context) =>statuspage (onThemeChanged:widget.onThemeChanged,
    //   isDarkMode:widget.isDarkMode),));}, child: Text(' Check Status',
    //   style: TextStyle(color: Colors.red,fontSize: 20),)),
 ],
)

      )),
      body: WebViewWidget(controller: controller)
    );
  }
}