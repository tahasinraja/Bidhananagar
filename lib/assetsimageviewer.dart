import 'package:flutter/material.dart';
class assetsImageviwer extends StatelessWidget {
  final String Imageview;
  const assetsImageviwer({super.key, required this.Imageview});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fullview'),
      ),
      body: Center(child: InteractiveViewer(child: Image.asset(Imageview)),),
    );
  }
}