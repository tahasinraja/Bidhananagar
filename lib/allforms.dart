import 'dart:convert';

import 'package:bidhannagarpoliceapp/tenantregistration.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class formspage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const formspage({
    super.key,

    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<formspage> createState() => _formspageState();
}

class _formspageState extends State<formspage> {
  String tenanturl = '';
  bool isLoading = true;
  List<dynamic> forms = [];
  Future<void> fetchforms() async {
    final formsurls = Uri.parse(
      'https://bnpcdeveloper.co.in/bnpolice/app/fetch_forms.php',
    );

    try {
      final response = await http.get(formsurls);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'].toLowerCase() == 'success') {
          setState(() {
            forms = data['data'];
            isLoading = false;
          });
        } else {
          throw Exception("Failed:${data['message']}");
        }
      } else {
        throw Exception("Failed to load forms");
      }
    } catch (e) {
      print('erroe:$e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchforms();
  }

  Future<void> openPdf(String url) async {
    final String viewerUrl =
        "https://docs.google.com/viewer?url=$url&embedded=true";
    final Uri pdfUrl = Uri.parse(viewerUrl);
    if (await canLaunchUrl(pdfUrl)) {
      await launchUrl(pdfUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Could not open PDF")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.isDarkMode ? Colors.black : const Color(0xFFe9e4de),
      appBar: AppBar(
        backgroundColor:
            widget.isDarkMode ? Colors.black : const Color(0xFFe9e4de),
        title: const Text("Forms"),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Container(
            height: 65,
            child: Card(
              child: ListTile(
                title: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.red),
                    SizedBox(width: 20),
                    Text(
                      'Tenanat Registration',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),

                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => docsdownviewpage(filePath: 'assets/images/Tenant Registration Form.pdf',
                         title: 'Tenanat Registration',)
                      ),
                    );
                  },
                  icon: Icon(Icons.open_in_browser,color: Colors.green,),
                ),
              ),
            ),
          ),
          Container(
            height: 65,
            child: Card(
              child: ListTile(
                title: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.green),
                    SizedBox(width: 20),
                    Text('Saanjh Baati', style: TextStyle(fontSize: 16)),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => docsdownviewpage(
                              filePath: 'assets/images/SAANJI BAATI.pdf',
                              title: 'Saanjh Baati',
                            ),
                      ),
                    );
                  },
                  icon: Icon(Icons.open_in_browser,color: Colors.red,),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : forms.isEmpty
                    ? const Center(child: Text("No forms available"))
                    : ListView.builder(
                      itemCount: forms.length,
                      itemBuilder: (context, index) {
                        final form = forms[index];
                        return Card(
                          child: ListTile(
                            title: Row(
                              children: [
                                Icon(Icons.picture_as_pdf, color: Colors.red),
                                SizedBox(width: 20),
                                Text('${form['subject']} '),
                              ],
                            ),

                            //  subtitle: Text(form['description']??''),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.open_in_browser,
                                color: Colors.green,
                              ),
                              onPressed: () async {
                                await openPdf(form['pdf']);
                              },
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
