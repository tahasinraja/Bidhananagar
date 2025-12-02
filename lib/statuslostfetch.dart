import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class lostitemstatuspage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;
  final String phone; // <-- phone pass karein

  const lostitemstatuspage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
    required this.phone,
  });

  @override
  State<lostitemstatuspage> createState() => _lostitemstatuspageState();
}

class _lostitemstatuspageState extends State<lostitemstatuspage> {
  TextEditingController commentcontroller = TextEditingController();

  Future<void> sendcomment(String id) async {
    final sendurl = Uri.parse('https://bnpcdeveloper.co.in/bnpolice/app/send_comment.php');

    try {
      final response = await http.post(
        sendurl,
        body: {
          "id": id,
          "comment": commentcontroller.text,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Successfully sent comment')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to send comment')));
      }
    } catch (e) {
      print('error: $e');
    }
  }

  List<dynamic>? Statusshow;

  Future<void> fethstatus(String phone) async {
    final fetchurls = Uri.parse(
        'https://bnpcdeveloper.co.in/bnpolice/app/lost_status_fetch.php?userid=$phone');

    try {
      final response = await http.get(fetchurls);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'].toLowerCase() == 'success') {
          setState(() {
            Statusshow = data['data'];
          });

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Status fetched')));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('No data found')));
        }
      }
    } catch (e) {
      print('error: $e');
    }
  }
  void openPdf(String url) async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    throw 'Could not open PDF';
  }
}


  @override
  void initState() {
    super.initState();
    fethstatus(widget.phone); // <-- correct
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Color(0xFFe9e4de),

      appBar: AppBar(
        backgroundColor: widget.isDarkMode ? Colors.black : Color(0xFFe9e4de),
        title: Text("Form Status"),
        centerTitle: true,
      ),

      body: RefreshIndicator(
        onRefresh: () async{
         await fethstatus(widget.phone); 
        },
        child: Statusshow == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(                                 // << FIXED
                    child: ListView.builder(
                      itemCount: Statusshow!.length,
                      itemBuilder: (context, index) {
                        final status = Statusshow![index];
        
                     return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Name + Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Name: ${status["name"] ?? 'N/A'}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
        
              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: status["status"] == "Approved"
                      ? Colors.green
                      : status["status"] == "Pending"
                          ? Colors.orange
                          : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status['status_info']?["status"] ?? "Pending",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        
          SizedBox(height: 10),
        
          // Item
          Text(
            "Item Name: ${status["item"] ?? 'N/A'}",
            style: TextStyle(fontSize: 15),
          ),
        
          SizedBox(height: 5),
        
          // Sl no & Date row
          Text(
            "Relation Name: ${status["so_do_wo"] ?? 'N/A'}",
            style: TextStyle(fontSize: 15),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "GD No.: ${status['status_info']? ["gdno"] ?? 'N/A'}",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              Text(
                "Date: ${status["date_filing"] ?? 'N/A'}",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        
          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 6),
        
          // PDF Clickable Badge
          Row(
            children: [
              Icon(Icons.picture_as_pdf, color: Colors.red, size: 20),
              SizedBox(width: 6),
              InkWell(
                onTap: () {
                  openPdf(status['status_info']?["pdf"] ?? "");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SizedBox(
                    width: 200,
                    child: Text(
                      status['status_info']?["pdf"] ?? "PDF Not Available",
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        
          SizedBox(height: 10),
        
          // Comment section
          Text(
            "Comment:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status["status_info"]?["comment"] ?? "No comment",
              style: TextStyle(fontSize: 14),
            ),
          ),
        
          SizedBox(height: 12),
        
          // Comment Button
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: ElevatedButton.icon(
          //     onPressed: () {
          //       showDialog(
          //         context: context,
          //         builder: (context) {
          //           return AlertDialog(
          //             title: Text("Add Comment"),
          //             content: TextField(
          //               controller: commentcontroller,
          //               decoration: InputDecoration(
          //                 hintText: "Enter your comment...",
          //               ),
          //             ),
          //             actions: [
          //               TextButton(
          //                 onPressed: () => Navigator.pop(context),
          //                 child: Text("Cancel"),
          //               ),
          //               ElevatedButton(
          //                 onPressed: () {
          //                   sendcomment(status["id"]);
          //                   Navigator.pop(context);
          //                 },
          //                 child: Text("Submit"),
          //               ),
          //             ],
          //           );
          //         },
          //       );
          //     },
          //     icon: Icon(Icons.chat),
          //     label: Text("Add Comment"),
          //     style: ElevatedButton.styleFrom(
          //       padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //     ),
          //   ),
          // ),
        ],
            ),
          ),
        );
        
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
