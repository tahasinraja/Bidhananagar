import 'package:flutter/material.dart';
class Imageviwer extends StatelessWidget {
  final String Imageview;
  const Imageviwer({super.key, required this.Imageview});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fullview'),
      ),
      body: Center(child: InteractiveViewer(child: Image.network(Imageview)),),
    );
  }
}