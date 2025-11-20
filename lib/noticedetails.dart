import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
class noticedetails extends StatefulWidget {
    final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const noticedetails({super.key,
  required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<noticedetails> createState() => _noticedetailsState();
}

class _noticedetailsState extends State<noticedetails> {
    List<dynamic> notices = [];
  bool isLoading = true;
  // 🔹 Open PDF link
  Future<void> openPdf(String url) async {
    final Uri pdfUrl = Uri.parse(url);
    if (await canLaunchUrl(pdfUrl)) {
      await launchUrl(pdfUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Could not open PDF")));
    }
  }

  Future<void> newsfetch() async {
    final urlnews = Uri.parse(
      'https://bnpcdeveloper.co.in/bnpolice/app/new_notice.php',
    );

    try {
      final response = await http.get(urlnews);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'].toLowerCase() == 'success') {
          setState(() {
            notices = data['data'];
            isLoading = false;
          });
        } else {
          throw Exception("Failed: ${data['message']}");
        }
      } else {
        throw Exception("Failed to load notices");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    newsfetch();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:widget. isDarkMode ? Colors.black : const Color(0xFFe9e4de),
      appBar: AppBar(
        title: Text("Notice Details"),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
    ? Colors.black
    : const Color(0xFFe9e4de),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notices.isEmpty
              ? Center(child: Text("No notices available."))
              : ListView.builder(
                  itemCount: notices.length,
                  itemBuilder: (context, index) {
                    final notice = notices[index];
                    return Card(
                      child: ListTile(
                        title: Text(notice!['subject']),
                      //  subtitle: Text(notice['']),
                        trailing: IconButton(
                          icon: Icon(Icons.open_in_new),
                          onPressed: () {
                            openPdf(notice!['pdf']);
                          },
                        )
                                         
                      ),
                    );
                  },
              )
    );
  }
}