


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class docsdownviewpage extends StatefulWidget {
  final String filePath;
  final String title;

  const docsdownviewpage({super.key, required this.filePath, required this.title});

  @override
  State<docsdownviewpage> createState() => _docsdownviewpageState();
}

class _docsdownviewpageState extends State<docsdownviewpage> {
  Future<void> saveAndOpenPdf() async {
    try {
      // Load PDF from assets
      ByteData bytes = await rootBundle.load(widget.filePath);
      Uint8List pdfBytes = bytes.buffer.asUint8List();

      // Save in app's temporary folder
      Directory tempDir = await getTemporaryDirectory();
      String filePath = "${tempDir.path}/${widget.title}.pdf";
      File file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      // Share / Open with external apps
      await Share.shareXFiles([XFile(file.path)], text: "Here is my PDF");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: saveAndOpenPdf,
          ),
        ],
      ),
      body: SfPdfViewer.asset(widget.filePath),
    );
  }
}