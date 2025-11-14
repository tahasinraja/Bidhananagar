import 'package:bidhannagarpoliceapp/modelfetch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class NoticeDetailsPage extends StatelessWidget {
  final NoticeModel notice;

  const NoticeDetailsPage({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text(notice.topic),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notice.image1.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(notice.image1),
              ),
            const SizedBox(height: 15),

            Text(
              notice.topic,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              notice.des,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),

            Text(
              "Published: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(notice.createdDate))}",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
