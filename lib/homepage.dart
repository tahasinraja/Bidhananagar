import 'dart:convert';

//import 'package:bidhannagarpoliceapp/commingsoon.dart';
import 'package:bidhannagarpoliceapp/allforms.dart';
import 'package:bidhannagarpoliceapp/allparkingmape.dart';
//import 'package:bidhannagarpoliceapp/feedback.dart';
import 'package:bidhannagarpoliceapp/contactscreen.dart';
import 'package:bidhannagarpoliceapp/crimereport.dart';
import 'package:bidhannagarpoliceapp/messipage.dart';
import 'package:bidhannagarpoliceapp/noticedetails.dart';
import 'package:bidhannagarpoliceapp/registerotppage.dart';
import 'package:bidhannagarpoliceapp/signuppage.dart';
import 'package:bidhannagarpoliceapp/lostitempage.dart';
import 'package:bidhannagarpoliceapp/trafficreport.dart';
//import 'package:bidhannagarpoliceapp/history.dart';
import 'package:bidhannagarpoliceapp/imageviwer.dart';
//import 'package:bidhannagarpoliceapp/knowps.dart';
import 'package:bidhannagarpoliceapp/login.dart';

import 'package:bidhannagarpoliceapp/modelfetch.dart';

import 'package:bidhannagarpoliceapp/notification.dart';
//import 'package:bidhannagarpoliceapp/notification.dart';

import 'package:bidhannagarpoliceapp/profile.dart';
//import 'package:bidhannagarpoliceapp/saanjhbatipage.dart';
import 'package:bidhannagarpoliceapp/serviceapifetch.dart';
import 'package:bidhannagarpoliceapp/tenantregistration.dart';
//import 'package:bidhannagarpoliceapp/trafficadvisari.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class homepage extends StatefulWidget {
  final Function(bool) onThemeChanged; // 🔹 Dark mode toggle callback
  final bool isDarkMode; // 🔹 Current mode state

  const homepage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final TextEditingController phoneController = TextEditingController();
  void loadSavedCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationCount = prefs.getInt("unread_count") ?? 0;
    });
  }

  //notice scroller
  final ScrollController _scrollController = ScrollController();
  bool _scrollingForward = true;

  // Login and Signup Dialog
  void showLoginSignupDialog(
    BuildContext context,
    VoidCallback onLoginTap,
    VoidCallback onSignupTap,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true, // user must choose one
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              "Welcome!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            content: const Text(
              "You need to log in or sign up to continue.",
              style: TextStyle(fontSize: 16),
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              SizedBox(
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onLoginTap();
                  },
                ),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.person_add, color: Colors.white),
                label: const Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onSignupTap();
                },
              ),
            ],
          ),
    );
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 1), () async {
      while (mounted) {
        await Future.delayed(const Duration(milliseconds: 50));
        if (_scrollController.hasClients) {
          final maxScroll = _scrollController.position.maxScrollExtent;
          final current = _scrollController.offset;

          // Scroll direction toggle
          if (_scrollingForward) {
            _scrollController.jumpTo(current + 1);
            if (current >= maxScroll) _scrollingForward = false;
          } else {
            _scrollController.jumpTo(current - 1);
            if (current <= 0) _scrollingForward = true;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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

  // fetch slider image
  List<dynamic> sliderImage = [];
  Future<void> fetchSliderImage() async {
    final sliderurl = Uri.parse(
      'https://bnpcdeveloper.co.in/bnpolice/app/fetch_slider.php',
    );

    try {
      final response = await http.get(sliderurl);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'].toLowerCase() == 'success') {
          setState(() {
            sliderImage = data['data'];
          });
          print("Slider Data: $sliderImage.length");
        } else {
          throw Exception("Failed: ${data['message']}");
        }
      } else {
        throw Exception("Failed to load slider image");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  //news fetch
  List<dynamic> notices = [];
  bool isLoading = true;
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

  bool isDarkMode = false;
  // void _toggleTheme(bool value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   setState(() {
  //     isDarkMode = value; // 🌓 Theme state change karo
  //   });

  //   await prefs.setBool('isDarkMode', value); // 💾 Save state locally

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(value ? "🌙 Dark Mode Enabled" : "☀️ Light Mode Enabled"),
  //       duration: const Duration(seconds: 1),
  //     ),
  //   );
  // }

  //logout
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('ph');
    await prefs.setBool('isloggedin', false);
    // ✅ Replace with login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder:
            (_) => testlogin(
              onThemeChanged: widget.onThemeChanged,
              isDarkMode: widget.isDarkMode,
            ),
      ),
      (route) => false,
    );
  }

  Future<List<NoticeModel>>? _futureNotices;
  int _notificationCount = 0;
  void _loadNotices() async {
    final notices = await ApiService.fetchNotices();
    setState(() {
      _notificationCount = notices.length; // jitne notice aaye count set karo
    });
  }

  bool showMore = false; // 🔹 Toggle state
  String? selectedfeedback;
  //late final WebViewController _fbController;
  Future<void> _refresher() async {
    await Future.delayed(Duration(microseconds: 2));
    setState(() {
      // _fbController.clearCache();
    });
  }

  //naviagtionbutton
  //int _selectedindex = 0;
  //dial 1930
  Uri dialnumber4 = Uri(scheme: 'tel', path: '1930');
  callnumber4() async {
    await launchUrl(dialnumber4);
  }

  //dial 102
  Uri dialnumber3 = Uri(scheme: 'tel', path: '102');
  callnumber3() async {
    await launchUrl(dialnumber3);
  }

  // Dial112
  Uri dialnumber2 = Uri(scheme: 'tel', path: '112');
  callnumber2() async {
    await launchUrl(dialnumber2);
  }

  // Dial 101
  Uri dialnumber1 = Uri(scheme: 'tel', path: '101');
  callnumber1() async {
    await launchUrl(dialnumber1);
  }

  // Dial 100
  Uri dialnumber = Uri(scheme: 'tel', path: '100');
  callnumber() async {
    await launchUrl(dialnumber);
  }

  @override

  void initState() {
    super.initState();
    newsfetch();
    _startAutoScroll();
    fetchSliderImage();
  //  _futureNotices = ApiService.fetchNotices();
    _loadNotices();
    loadSavedCount();
    // selectedfeedback = "facebook"; // 👈 Default Facebook select
    // _fbController =
    //     WebViewController()
    //       ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //       ..setBackgroundColor(const Color(0x00000000))
    //       ..loadRequest(
    //         Uri.parse(
    //           "https://www.facebook.com/plugins/page.php?href=https%3A%2F%2Fwww.facebook.com%2Fbdncitypolice&tabs=timeline&width=340&height=600&small_header=true&adapt_container_width=true&hide_cover=true&show_facepile=true&appId",
    //         ),
    //       );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.height;
    final h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        bool exitapp = await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                // backgroundColor:isDarkMode ? Colors.black : Color(0xFFe9e4de),
                title: Text('😞Exit App?', style: TextStyle(color: Colors.red)),
                content: Text('Are You Want to close this App ?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Yes'),
                  ),
                ],
              ),
        );
        return exitapp;
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : const Color(0xFFe9e4de),

        drawer: Drawer(
          backgroundColor:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : const Color(0xFFe9e4de),

          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // 🔹 Drawer Header with Branding
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Image.asset('assets/images/BDN logo.png', height: 70),
                    SizedBox(height: 10),
                    Text(
                      "Bidhannagar Police",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    // SwitchListTile(
                    //   title: Text(
                    //     widget.isDarkMode ? "Dark Mode" : "Light Mode",
                    //     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    //   ),
                    //   secondary: AnimatedSwitcher(
                    //     duration: const Duration(milliseconds: 300),
                    //     child: Icon(
                    //       widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    //       key: ValueKey(widget.isDarkMode),
                    //       color: widget.isDarkMode ? Colors.white : Colors.black87,
                    //     ),
                    //   ),
                    //   activeThumbColor: Colors.amberAccent,
                    //   value: widget.isDarkMode,
                    //   onChanged: (value) async {
                    //     widget.onThemeChanged(value); // call main.dart function

                    // //     await Future.delayed(const Duration(milliseconds: 100));

                    // //  showDialog(
                    // //   context: context,
                    // //   barrierDismissible: true,
                    // //   builder: (context) => Dialog(
                    // //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    // //     backgroundColor:
                    // //         widget.isDarkMode ? Colors.grey[900] : Colors.white, // Adaptive color
                    // //     child: Container(
                    // //       padding: const EdgeInsets.all(20),
                    // //       decoration: BoxDecoration(
                    // //         borderRadius: BorderRadius.circular(20),
                    // //         gradient: LinearGradient(
                    // //           colors: widget.isDarkMode
                    // //               ? [Colors.black87, Colors.grey[850]!]
                    // //               : [Colors.white, Colors.grey[100]!],
                    // //           begin: Alignment.topLeft,
                    // //           end: Alignment.bottomRight,
                    // //         ),
                    // //         boxShadow: [
                    // //           BoxShadow(
                    // //             color: widget.isDarkMode
                    // //                 ? Colors.black54
                    // //                 : Colors.grey.withOpacity(0.3),
                    // //             blurRadius: 15,
                    // //             offset: const Offset(0, 6),
                    // //           ),
                    // //         ],
                    // //       ),
                    // //       child: Column(
                    // //         mainAxisSize: MainAxisSize.min,
                    // //         children: [
                    // //           Icon(
                    // //             widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    // //             color: widget.isDarkMode ? Colors.amberAccent : Colors.orangeAccent,
                    // //             size: 50,
                    // //           ),
                    // //           const SizedBox(height: 15),
                    // //           Text(
                    // //             "Theme Updated 🎨",
                    // //             style: TextStyle(
                    // //               fontSize: 20,
                    // //               fontWeight: FontWeight.bold,
                    // //               color: widget.isDarkMode ? Colors.white : Colors.black87,
                    // //             ),
                    // //           ),
                    // //           const SizedBox(height: 10),
                    // //           Text(
                    // //             "Please restart the app to fully apply the new theme.",
                    // //             textAlign: TextAlign.center,
                    // //             style: TextStyle(
                    // //               fontSize: 15,
                    // //               color: widget.isDarkMode
                    // //                   ? Colors.grey[400]
                    // //                   : Colors.grey[700],
                    // //             ),
                    // //           ),
                    // //           const SizedBox(height: 20),
                    // //           ElevatedButton(
                    // //             style: ElevatedButton.styleFrom(
                    // //               backgroundColor: widget.isDarkMode
                    // //                   ? Colors.amberAccent
                    // //                   : Colors.blueAccent,
                    // //               shape: RoundedRectangleBorder(
                    // //                   borderRadius: BorderRadius.circular(12)),
                    // //               padding:
                    // //                   const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    // //               elevation: 5,
                    // //             ),
                    // //             onPressed: () => Navigator.pop(context),
                    // //             child: const Text(
                    // //               "OK",
                    // //               style: TextStyle(
                    // //                 fontSize: 16,
                    // //                 fontWeight: FontWeight.bold,
                    // //                 color: Colors.white,
                    // //               ),
                    // //             ),
                    // //           ),
                    // //         ],
                    // //       ),
                    // //     ),
                    // //   ),
                    // // );

                    //   },
                    // ),
                    Card(
                      // 🔹 About Section
                      child: Column(
                        children: [
                          // _buildExpansionTile(
                          //   icon: Icons.info,
                          //   title: "About Us",
                          //   children: [
                          _buildDrawerItem(
                            Icons.security_outlined,
                            "Police Station Hierarchy",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => docsdownviewpage(
                                        filePath: 'assets/images/Capture.pdf',
                                        title: 'Police Station Hierarchy',
                                      ),
                                ),
                              );
                            },
                          ),

                          // _buildDrawerItem(
                          //   Icons.policy_outlined,
                          //   "Police Station Profile",
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder:
                          //             (context) => knowpspage(
                          //               onThemeChanged: widget.onThemeChanged,
                          //               isDarkMode: widget.isDarkMode,
                          //             ),
                          //       ),
                          //     );
                          //   },
                          // ),
                          // _buildDrawerItem(
                          //   Icons.history_outlined,
                          //   "History",
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder:
                          //             (context) => HistoryPage(
                          //               onThemeChanged: widget.onThemeChanged,
                          //               isDarkMode: widget.isDarkMode,
                          //             ),
                          //       ),
                          //     );
                          //   },
                          // ),
                          // _buildDrawerItem(
                          //   Icons.receipt_long_outlined,
                          //   " Police Station Jurisdiction Map",
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder:
                          //             (context) => docsdownviewpage(
                          //               filePath:
                          //                   'assets/images/jurisdiction.pdf',
                          //               title: 'Jurisdiction Map',
                          //             ),
                          //       ),
                          //     );
                          //   },
                          // ),
                          //   ],
                          //  ),

                          // // 🔹 Traffic Section
                          // _buildExpansionTile(
                          //   icon: Icons.traffic_outlined,
                          //   title: "Traffic",
                          //   children: [
                          // _buildDrawerItem(
                          //   Icons.map,
                          //   'Traffic  Hierarchy',
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder:
                          //             (context) => docsdownviewpage(
                          //               filePath:
                          //                   'assets/images/Traffic Heirarchy.pdf',
                          //               title: 'Traffic Hierarchy ',
                          //             ),
                          //       ),
                          //     );
                          //   },
                          // ),
                          _buildDrawerItem(
                            Icons.person,
                            "Traffic Police Hierarchy ",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => docsdownviewpage(
                                        filePath:
                                            'assets/images/Traffic Heirarchy.pdf',
                                        title: 'Traffic Police Hierarchy',
                                      ),
                                ),
                              );
                            },
                          ),

                          // _buildDrawerItem(
                          //   Icons.rule,
                          //   'Traffic Rules',
                          //   onTap: () async {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder:
                          //             (context) => docsdownviewpage(
                          //               filePath:
                          //                   'assets/images/TrafficRules.pdf',
                          //               title: 'Traffic Rules',
                          //             ),
                          //       ),
                          //     );
                          //   },
                          // ),
                          // _buildDrawerItem(
                          //   Icons.kitesurfing_sharp,
                          //   'Traffic Advisory',
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder:
                          //             (context) => trafficadvisary(
                          //               onThemeChanged: widget.onThemeChanged,
                          //               isDarkMode: widget.isDarkMode,
                          //             ),
                          //       ),
                          //     );
                          //   },
                          // ),

                          // _buildDrawerItem(
                          //   Icons.shopping_bag_outlined,
                          //   "Traffic Jurisdiction Map",
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder:
                          //             (context) => docsdownviewpage(
                          //               filePath:
                          //                   'assets/images/Traffic Map.pdf',
                          //               title: 'Traffic Jurisdiction Map',
                          //             ),
                          //       ),
                          //     );
                          //   },
                          // ),
                          //  ],
                          //  ),

                          // 🔹 Links Section
                          // _buildExpansionTile(
                          //   icon: Icons.link,
                          //   title: "Related Websites",
                          //   children: [
                          //     _buildDrawerItem(
                          //       Icons.policy,
                          //       "West Bengal Police",
                          //       onTap: () async {
                          //         const ur1 = 'http://policewb.gov.in/';
                          //         if (await canLaunchUrl(Uri.parse(ur1))) {
                          //           await launchUrl(
                          //             Uri.parse(ur1),
                          //             mode: LaunchMode.externalApplication,
                          //           );
                          //         } else {
                          //           debugPrint("Could not launch $ur1");
                          //         }
                          //       },
                          //     ),
                          //     _buildDrawerItem(
                          //       Icons.policy,
                          //       "e-Courts",
                          //       onTap: () async {
                          //         const ur1 = 'https://services.ecourts.gov.in/';
                          //         if (await canLaunchUrl(Uri.parse(ur1))) {
                          //           await launchUrl(
                          //             Uri.parse(ur1),
                          //             mode: LaunchMode.externalApplication,
                          //           );
                          //         } else {
                          //           debugPrint("Could not launch $ur1");
                          //         }
                          //       },
                          //     ),
                          //     _buildDrawerItem(
                          //       Icons.shield_outlined,
                          //       "Report Cyber Crime ",
                          //       onTap: () async {
                          //         const ur1 = 'https://cybercrime.gov.in/';
                          //         if (await canLaunchUrl(Uri.parse(ur1))) {
                          //           await launchUrl(
                          //             Uri.parse(ur1),
                          //             mode: LaunchMode.externalApplication,
                          //           );
                          //         } else {
                          //           debugPrint("Could not launch $ur1");
                          //         }
                          //       },
                          //     ),
                          //     _buildDrawerItem(
                          //       Icons.hide_source_rounded,
                          //       "Missing Person",
                          //       onTap: () async {
                          //         const ur1 =
                          //             'https://udcase.wb.gov.in/Citizen_search';
                          //         if (await canLaunchUrl(Uri.parse(ur1))) {
                          //           await launchUrl(
                          //             Uri.parse(ur1),
                          //             mode: LaunchMode.externalApplication,
                          //           );
                          //         } else {
                          //           debugPrint("Could not launch $ur1");
                          //         }
                          //       },
                          //     ),
                          //     _buildDrawerItem(
                          //       Icons.shield,
                          //       'Missing Child ',
                          //       onTap: () async {
                          //         const ur1 =
                          //             'https://missionvatsalya.wcd.gov.in/citizen-login';
                          //         if (await canLaunchUrl(Uri.parse(ur1))) {
                          //           await launchUrl(
                          //             Uri.parse(ur1),
                          //             mode: LaunchMode.externalApplication,
                          //           );
                          //         } else {
                          //           debugPrint("Could not launch $ur1");
                          //         }
                          //       },
                          //     ),
                          //     _buildDrawerItem(
                          //       Icons.account_balance_sharp,
                          //       'Sorasori Mukhyomatri ',
                          //       onTap: () async {
                          //         const ur1 = 'https://cmo.wb.gov.in/';
                          //         if (await canLaunchUrl(Uri.parse(ur1))) {
                          //           await launchUrl(
                          //             Uri.parse(ur1),
                          //             mode: LaunchMode.externalApplication,
                          //           );
                          //         } else {
                          //           debugPrint("Could not launch $ur1");
                          //         }
                          //       },
                          //     ),
                          //     _buildDrawerItem(
                          //       Icons.shield,
                          //       'CID West Bengal ',
                          //       onTap: () async {
                          //         const ur1 = 'https://cid.wb.gov.in/';
                          //         if (await canLaunchUrl(Uri.parse(ur1))) {
                          //           await launchUrl(
                          //             Uri.parse(ur1),
                          //             mode: LaunchMode.externalApplication,
                          //           );
                          //         } else {
                          //           debugPrint("Could not launch $ur1");
                          //         }
                          //       },
                          //     ),
                          //     _buildDrawerItem(
                          //       Icons.shield,
                          //       'Kolkata Police ',
                          //       onTap: () async {
                          //         const ur1 = 'https://kolkatapolice.gov.in/';
                          //         if (await canLaunchUrl(Uri.parse(ur1))) {
                          //           await launchUrl(Uri.parse(ur1));
                          //         } else {
                          //           debugPrint("Could not launch $ur1");
                          //         }
                          //       },
                          //     ),
                          //   ],
                          // ),
                          const Divider(),

                          // 🔹 Single Items
                          _buildDrawerItem(
                            Icons.assignment_outlined,
                            " Registration Forms",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => formspage(
                                        onThemeChanged: widget.onThemeChanged,
                                        isDarkMode: widget.isDarkMode,
                                      ),
                                ),
                              );
                            },
                          ),

                          //                 _buildDrawerItem(
                          //                   Icons.feedback_outlined,
                          //                   "Feedback",
                          //                   onTap: () async {
                          //                     SharedPreferences prefs =
                          //                         await SharedPreferences.getInstance();
                          //                         bool isloggedin= prefs.getBool('isloggedin') ?? false;

                          //                           if (!isloggedin) {
                          //   showLoginSignupDialog(
                          //     context,
                          //     // when user taps Login
                          //     () {
                          //       Navigator.pushReplacement(
                          // context,
                          // PageRouteBuilder(
                          //   transitionDuration: const Duration(milliseconds: 500),
                          //   pageBuilder: (context, animation, secondaryAnimation) => testlogin(
                          //     onThemeChanged: widget.onThemeChanged,
                          //     isDarkMode: widget.isDarkMode,
                          //   ),
                          //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          //     const begin = Offset(0.0, -1.0);
                          //     const end = Offset.zero;
                          //     var tween = Tween(begin: begin, end: end)
                          //         .chain(CurveTween(curve: Curves.easeInOut));
                          //     return SlideTransition(position: animation.drive(tween), child: child);
                          //   },
                          // ),
                          //       );
                          //     },
                          //     // when user taps Signup
                          //     () {
                          //       Navigator.pushReplacement(
                          // context,
                          // PageRouteBuilder(
                          //   transitionDuration: const Duration(milliseconds: 500),
                          //   pageBuilder: (context, animation, secondaryAnimation) => signuppage(
                          //     onThemeChanged: widget.onThemeChanged,
                          //     isDarkMode: widget.isDarkMode,
                          //   ),
                          //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          //     const begin = Offset(0.0, -1.0);
                          //     const end = Offset.zero;
                          //     var tween = Tween(begin: begin, end: end)
                          //         .chain(CurveTween(curve: Curves.easeInOut));
                          //     return SlideTransition(position: animation.drive(tween), child: child);
                          //   },
                          // ),
                          //       );
                          //     },
                          //   );
                          // } else {
                          //   Navigator.push(
                          //     context,
                          //     PageRouteBuilder(
                          //       transitionDuration: const Duration(milliseconds: 1000),
                          //       pageBuilder: (context, animation, secondaryAnimation) => feedbackpage(
                          // onThemeChanged: widget.onThemeChanged,
                          // isDarkMode: widget.isDarkMode,
                          //       ),
                          //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          // const begin = Offset(0.0, -1.0);
                          // const end = Offset.zero;
                          // var tween = Tween(begin: begin, end: end)
                          //     .chain(CurveTween(curve: Curves.easeInOut));
                          // return SlideTransition(position: animation.drive(tween), child: child);
                          //       },
                          //     ),
                          //   );
                          // }
                          //                   },
                          //                 ),
                          const Divider(),
                          //login area
                          // _buildExpansionTile(
                          //   icon: Icons.login,
                          //   title: 'Login',
                          //   children: [
                          //     _buildDrawerItem(
                          //       Icons.man,
                          //       'Citizen Login',
                          //       onTap: () async {
                          //         const ur1 =
                          //             'http://services.bidhannagarcitypolice.gov.in/';
                          //         if (await canLaunchUrl(Uri.parse(ur1))) {
                          //           await launchUrl(
                          //             Uri.parse(ur1),
                          //             mode: LaunchMode.externalApplication,
                          //           );
                          //         } else {
                          //           debugPrint("Could not launch $ur1");
                          //         }
                          //       },
                          //     ),
                          //     _buildDrawerItem(
                          //       Icons.meeting_room,
                          //       'Officer Login',
                          //       onTap: () async {
                          //         const ur1 =
                          //             'http://services.bidhannagarcitypolice.gov.in/';
                          //         if (await canLaunchUrl(Uri.parse(ur1))) {
                          //           await launchUrl(
                          //             Uri.parse(ur1),
                          //             mode: LaunchMode.externalApplication,
                          //           );
                          //         } else {
                          //           debugPrint("Could not launch $ur1");
                          //         }
                          //       },
                          //     ),
                          //     _buildDrawerItem(
                          //       Icons.file_copy,
                          //       'Login for FIR',
                          //       onTap: () async {
                          //         const ur1 =
                          //             'http://fir.bidhannagarcitypolice.gov.in/';
                          //         if (await canLaunchUrl(Uri.parse(ur1))) {
                          //           await launchUrl(
                          //             Uri.parse(ur1),
                          //             mode: LaunchMode.externalApplication,
                          //           );
                          //         } else {
                          //           debugPrint("Could not launch $ur1");
                          //         }
                          //       },
                          //     ),
                          //   ],
                          // ),
                          // 🔹 Emergency Buttons
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Column(
                              children: [
                                // ElevatedButton.icon(
                                //   style: ElevatedButton.styleFrom(
                                //     backgroundColor: Colors.red,
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(12),
                                //     ),
                                //     //  minimumSize: const Size.fromHeight(45),
                                //   ),
                                //   icon: const Icon(
                                //     Icons.call,
                                //     color: Colors.white,
                                //   ),
                                //   label: const Text(
                                //     "Police Helpline",
                                //     style: TextStyle(
                                //       fontSize: 16,
                                //       color: Colors.white,
                                //       fontWeight: FontWeight.bold,
                                //     ),
                                //   ),
                                //   onPressed: callnumber2,
                                // ),
                                const SizedBox(height: 10),
                                //logout button

                                //                                  ElevatedButton.icon(
                                //                               style: ElevatedButton.styleFrom(
                                //                                 backgroundColor: Colors.red,
                                //                                 shape: RoundedRectangleBorder(
                                //                                   borderRadius: BorderRadius.circular(12),
                                //                                 ),
                                //                                 minimumSize: const Size.fromHeight(45),
                                //                               ),
                                //                               icon: const Icon(Icons.logout_outlined, color: Colors.white),
                                //                               label: const Text(
                                //                                 "Logout",
                                //                                 style: TextStyle(
                                //                                   fontSize: 16,
                                //                                   color: Colors.white,
                                //                                   fontWeight: FontWeight.bold,
                                //                                 ),
                                //                               ),
                                //                               onPressed: () async {
                                //   // Pehle SharedPreferences clear karo
                                //   final prefs = await SharedPreferences.getInstance();
                                //   await prefs.clear();

                                //   // Phir animated navigation
                                //   Navigator.pushAndRemoveUntil(
                                //     context,
                                //     PageRouteBuilder(
                                //       transitionDuration: const Duration(milliseconds: 700),
                                //       pageBuilder: (context, animation, secondaryAnimation) =>
                                //            testlogin(onThemeChanged:widget. onThemeChanged, isDarkMode:widget. isDarkMode), // ya SplashScreen()
                                //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                //         // Left-to-right animation
                                //         const begin = Offset(-1.0, 0.0);
                                //         const end = Offset.zero;
                                //         final tween = Tween(begin: begin, end: end).chain(
                                //           CurveTween(curve: Curves.easeInOut),
                                //         );
                                //         return SlideTransition(
                                //           position: animation.drive(tween),
                                //           child: child,
                                //         );
                                //       },
                                //     ),
                                //     (route) => false, // saare purane routes remove
                                //   );
                                // },

                                //                             ),

                                // ElevatedButton.icon(
                                //   style: ElevatedButton.styleFrom(
                                //     backgroundColor: Colors.red,
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(12),
                                //     ),
                                //     minimumSize: const Size.fromHeight(45),
                                //   ),
                                //   icon: const Icon(
                                //     Icons.local_fire_department,
                                //     color: Colors.white,
                                //   ),
                                //   label: const Text(
                                //     "Dial 101",
                                //     style: TextStyle(
                                //       fontSize: 16,
                                //       color: Colors.white,
                                //       fontWeight: FontWeight.bold,
                                //     ),
                                //   ),
                                //   onPressed: callnumber1,
                                // ),
                                // 🔹 Dark Mode Toggle (Logout के नीचे)
                                SwitchListTile(
                                  title: Text(
                                    widget.isDarkMode
                                        ? "Dark Mode"
                                        : "Light Mode",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  secondary: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: Icon(
                                      widget.isDarkMode
                                          ? Icons.dark_mode
                                          : Icons.light_mode,
                                      key: ValueKey(widget.isDarkMode),
                                      color:
                                          widget.isDarkMode
                                              ? Colors.white
                                              : Colors.black87,
                                    ),
                                  ),
                                  activeThumbColor: Colors.amberAccent,
                                  value: widget.isDarkMode,
                                  onChanged: widget.onThemeChanged,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ✅ AppBar
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height * 0.07,
          ),
          child: AppBar(
            backgroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : const Color(0xFFe9e4de),

            shadowColor: Colors.black,
            // elevation: 4,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Builder(
                        builder:
                            (context) => GestureDetector(
                              onTap: () => Scaffold.of(context).openDrawer(),
                              child: Row(
                                children: [
                                  Text("☰", style: TextStyle(fontSize: 27)),
                                  SizedBox(width: 12),
                                  Image.asset(
                                    'assets/images/BDN logo.png',
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.040,
                                  ),
                                ],
                              ),
                            ),
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        // child: Text(
                        //   "Bidhannagar Police",
                        //   style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),

                        //  // maxLines: 1,
                        //   overflow: TextOverflow.ellipsis,
                        // )

                        //  ⭐ IMPORTANT!
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Bidhannagar Police",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.1, // optional, makes text tighter
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Spacer(),
                IconButton(
                  onPressed: () => callnumber2(),
                  icon: ImageIcon(
                    AssetImage('assets/images/sos_1894555.png'),
                    color: Colors.red,
                    size: MediaQuery.of(context).size.width * 0.08,
                  ),
                ),

                FutureBuilder<List<NoticeModel>>(
                  future: _futureNotices,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _notificationCount =
                          snapshot.data!.length; // notice count
                    }

                    return IconButton(
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            Icons.notifications_active_outlined,
                            color: Colors.red,
                            // widget.isDarkMode ? Colors.white : Colors.black,
                            size: MediaQuery.of(context).size.width * 0.08,
                          ),
                          if (_notificationCount > 0)
                            Positioned(
                              right: -3,
                              top: -3,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  '$_notificationCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                      onPressed: () async {
                        SharedPreferences prets =
                            await SharedPreferences.getInstance();
                        bool isloggedin = prets.getBool('isloggedin') ?? false;

                        if (!isloggedin) {
                          showLoginSignupDialog(
                            context,
                            // when user taps Login
                            () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(
                                    milliseconds: 500,
                                  ),
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => testlogin(
                                        onThemeChanged: widget.onThemeChanged,
                                        isDarkMode: widget.isDarkMode,
                                      ),
                                  transitionsBuilder: (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    const begin = Offset(0.0, -1.0);
                                    const end = Offset.zero;
                                    var tween = Tween(
                                      begin: begin,
                                      end: end,
                                    ).chain(
                                      CurveTween(curve: Curves.easeInOut),
                                    );
                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            // when user taps Signup
                            () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(
                                    milliseconds: 500,
                                  ),
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => SendOtpPage(
                                        onThemeChanged: widget.onThemeChanged,
                                        isDarkMode: widget.isDarkMode,
                                       // phone: phoneController.text,
                                      ),
                                  transitionsBuilder: (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    const begin = Offset(0.0, -1.0);
                                    const end = Offset.zero;
                                    var tween = Tween(
                                      begin: begin,
                                      end: end,
                                    ).chain(
                                      CurveTween(curve: Curves.easeInOut),
                                    );
                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                milliseconds: 1000,
                              ),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      Notificationscreen(
                                        onThemeChanged: widget.onThemeChanged,
                                        isDarkMode: widget.isDarkMode,
                                      ),
                              transitionsBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              ) {
                                const begin = Offset(0.0, -1.0);
                                const end = Offset.zero;
                                var tween = Tween(
                                  begin: begin,
                                  end: end,
                                ).chain(CurveTween(curve: Curves.easeInOut));
                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        }

                        // 🔹 Reset counter after opening notification screen
                        prets.setInt("unread_count", 0);
                        setState(() {
                          _notificationCount = 0;
                        });
                      },
                    );
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    // ✅ 1️⃣ Check login status
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    bool isloggedin = prefs.getBool('isloggedin') ?? false;

                    // ✅ 2️⃣ If NOT logged in → show popup
                    if (!isloggedin) {
                      showLoginSignupDialog(
                        context,
                        // When user taps Login
                        () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                milliseconds: 500,
                              ),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      testlogin(
                                        onThemeChanged: widget.onThemeChanged,
                                        isDarkMode: widget.isDarkMode,
                                      ),
                              transitionsBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              ) {
                                const begin = Offset(0.0, -1.0);
                                const end = Offset.zero;
                                var tween = Tween(
                                  begin: begin,
                                  end: end,
                                ).chain(CurveTween(curve: Curves.easeInOut));
                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        // When user taps Signup
                        () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                milliseconds: 500,
                              ),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      SendOtpPage(
                                        onThemeChanged: widget.onThemeChanged,
                                        isDarkMode: widget.isDarkMode,
                                      //  phone: phoneController.text,
                                      ),
                              transitionsBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              ) {
                                const begin = Offset(0.0, -1.0);
                                const end = Offset.zero;
                                var tween = Tween(
                                  begin: begin,
                                  end: end,
                                ).chain(CurveTween(curve: Curves.easeInOut));
                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      );
                    }
                    // ✅ 3️⃣ If logged in → go to profile screen
                    else {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 600),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  profilescreen(
                                    onThemeChanged: widget.onThemeChanged,
                                    isDarkMode: widget.isDarkMode,
                                  ),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            const begin = Offset(0.0, -1.0);
                            const end = Offset.zero;
                            var tween = Tween(
                              begin: begin,
                              end: end,
                            ).chain(CurveTween(curve: Curves.easeInOut));
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    }
                  },

                  // ✅ 4️⃣ Profile Avatar UI
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.020,
                    backgroundColor: Colors.white,
                    child: Image(
                      image: AssetImage('assets/images/man_4140037.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ✅ Body
        body: RefreshIndicator(
          onRefresh: _refresher,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 🔹 Photo Slider
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 250,
                      child:
                          sliderImage.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : CarouselSlider(
                                items:
                                    sliderImage.map((item) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          item['pic'], // <-- Correct way
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.broken_image,
                                                size: 40,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }).toList(),
                                options: CarouselOptions(
                                  height: 200,
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                ),
                              ),
                    ),

                    Positioned(
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () async {
                          const Ur1 =
                              'https://www.google.com/maps/search/police+station+near+me/';
                          if (await canLaunchUrl(Uri.parse(Ur1))) {
                            await launchUrl(
                              Uri.parse(Ur1),
                              mode: LaunchMode.platformDefault,
                            );
                          } else {
                            debugPrint('Could not launch $Ur1');
                          }
                        },
                        child: CircleAvatar(
                          radius: 33,
                          backgroundColor: Color(0xFFe9e4de),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Lottie.asset(
                              'assets/images/X1CGyfIO5U.json',
                              height: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Nearby Police Stations',
                  style: TextStyle(
                    fontSize: h * 0.019,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // 🔹tilesButton
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: // 🔹 Main + Extra services in same grid
                      GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.90,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(1),
                    children: [
                      tilesButton(
                        title: ' Report Cyber \nCrime ',
                        imagepath: 'assets/images/complain.png',
                        onTap: () async {
                          const ur1 =
                              'https://cybercrime.gov.in/Webform/Index.aspx';
                          if (await canLaunchUrl(Uri.parse(ur1))) {
                            await launchUrl(
                              Uri.parse(ur1),
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            debugPrint("Could not launch $ur1");
                          }
                        },
                      ),
                           tilesButton(
                          title: ' Report Missing\nMobile',
                          imagepath: 'assets/images/missing.png',
                          onTap: () async {
                            const ur1 =
                                'https://www.ceir.gov.in/Request/CeirUserBlockRequestDirect.jsp';
                            if (await canLaunchUrl(Uri.parse(ur1))) {
                              await launchUrl(Uri.parse(ur1));
                            } else {
                              debugPrint("Could not launch $ur1");
                            }
                          },
                        ),
                    
                      tilesButton(
                        title: 'Report Lost\nProperty',
                        imagepath: 'assets/images/lost-items.png',
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          bool isLoggedIn =
                              prefs.getBool('isloggedin') ?? false;
                          if (!isLoggedIn) {
                            showLoginSignupDialog(
                              context,
                              // When user taps Login
                              () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(
                                      milliseconds: 500,
                                    ),
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => testlogin(
                                          onThemeChanged: widget.onThemeChanged,
                                          isDarkMode: widget.isDarkMode,
                                        ),
                                    transitionsBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      const begin = Offset(0.0, -1.0);
                                      const end = Offset.zero;
                                      var tween = Tween(
                                        begin: begin,
                                        end: end,
                                      ).chain(
                                        CurveTween(curve: Curves.easeInOut),
                                      );
                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              // When user taps Signup
                              () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(
                                      milliseconds: 500,
                                    ),
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => SendOtpPage(
                                          onThemeChanged: widget.onThemeChanged,
                                          isDarkMode: widget.isDarkMode,
                                         // phone: phoneController.text,
                                        ),
                                    transitionsBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      const begin = Offset(0.0, -1.0);
                                      const end = Offset.zero;
                                      var tween = Tween(
                                        begin: begin,
                                        end: end,
                                      ).chain(
                                        CurveTween(curve: Curves.easeInOut),
                                      );
                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          }
                          // ✅ 3️⃣ If logged in → go to profile screen
                          else {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(
                                  milliseconds: 600,
                                ),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        lostitempage(
                                          onThemeChanged: widget.onThemeChanged,
                                          isDarkMode: widget.isDarkMode,
                                        ),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  const begin = Offset(0.0, -1.0);
                                  const end = Offset.zero;
                                  var tween = Tween(
                                    begin: begin,
                                    end: end,
                                  ).chain(CurveTween(curve: Curves.easeInOut));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          }
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder:
                          //         (context) =>webviewlostpage(
                          //       onThemeChanged: widget.onThemeChanged,
                          //       isDarkMode: widget.isDarkMode,
                          //     ),
                          //   ),
                          // );
                        },
                      ),
                      tilesButton(
                        title: 'Report \nCrime',
                        imagepath: 'assets/images/crimereport.png',
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          bool isLoggedIn =
                              prefs.getBool('isloggedin') ?? false;
                          if (!isLoggedIn) {
                            showLoginSignupDialog(
                              context,
                              // When user taps Login
                              () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(
                                      milliseconds: 500,
                                    ),
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => testlogin(
                                          onThemeChanged: widget.onThemeChanged,
                                          isDarkMode: widget.isDarkMode,
                                        ),
                                    transitionsBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      const begin = Offset(0.0, -1.0);
                                      const end = Offset.zero;
                                      var tween = Tween(
                                        begin: begin,
                                        end: end,
                                      ).chain(
                                        CurveTween(curve: Curves.easeInOut),
                                      );
                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              // When user taps Signup
                              () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(
                                      milliseconds: 500,
                                    ),
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => SendOtpPage(
                                          onThemeChanged: widget.onThemeChanged,
                                          isDarkMode: widget.isDarkMode,
                                         // phone: phoneController.text,
                                        ),
                                    transitionsBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      const begin = Offset(0.0, -1.0);
                                      const end = Offset.zero;
                                      var tween = Tween(
                                        begin: begin,
                                        end: end,
                                      ).chain(
                                        CurveTween(curve: Curves.easeInOut),
                                      );
                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          }
                          // ✅ 3️⃣ If logged in → go to profile screen
                          else {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(
                                  milliseconds: 600,
                                ),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        crimereport(
                                          onThemeChanged: widget.onThemeChanged,
                                          isDarkMode: widget.isDarkMode,
                                        ),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  const begin = Offset(0.0, -1.0);
                                  const end = Offset.zero;
                                  var tween = Tween(
                                    begin: begin,
                                    end: end,
                                  ).chain(CurveTween(curve: Curves.easeInOut));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          }
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder:
                          //         (context) => crimereport(
                          //           onThemeChanged: widget.onThemeChanged,
                          //           isDarkMode: widget.isDarkMode,
                          //         ),
                          //   ),
                          // );
                        },
                      ),
                      tilesButton(
                        title: 'Report\nTraffic Incident',
                        imagepath: 'assets/images/trafficindident.png',
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          bool isLoggedIn =
                              prefs.getBool('isloggedin') ?? false;
                          if (!isLoggedIn) {
                            showLoginSignupDialog(
                              context,
                              // When user taps Login
                              () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(
                                      milliseconds: 500,
                                    ),
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => testlogin(
                                          onThemeChanged: widget.onThemeChanged,
                                          isDarkMode: widget.isDarkMode,
                                        ),
                                    transitionsBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      const begin = Offset(0.0, -1.0);
                                      const end = Offset.zero;
                                      var tween = Tween(
                                        begin: begin,
                                        end: end,
                                      ).chain(
                                        CurveTween(curve: Curves.easeInOut),
                                      );
                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              // When user taps Signup
                              () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(
                                      milliseconds: 500,
                                    ),
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => SendOtpPage(
                                          onThemeChanged: widget.onThemeChanged,
                                          isDarkMode: widget.isDarkMode,
                                         // phone: phoneController.text,
                                        ),
                                    transitionsBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      const begin = Offset(0.0, -1.0);
                                      const end = Offset.zero;
                                      var tween = Tween(
                                        begin: begin,
                                        end: end,
                                      ).chain(
                                        CurveTween(curve: Curves.easeInOut),
                                      );
                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          }
                          // ✅ 3️⃣ If logged in → go to profile screen
                          else {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(
                                  milliseconds: 600,
                                ),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        trafficreport(
                                          onThemeChanged: widget.onThemeChanged,
                                          isDarkMode: widget.isDarkMode,
                                        ),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  const begin = Offset(0.0, -1.0);
                                  const end = Offset.zero;
                                  var tween = Tween(
                                    begin: begin,
                                    end: end,
                                  ).chain(CurveTween(curve: Curves.easeInOut));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          }
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder:
                          //         (context) => crimereport(
                          //           onThemeChanged: widget.onThemeChanged,
                          //           isDarkMode: widget.isDarkMode,
                          //         ),
                          //   ),
                          // );
                        },
                      ),
                      //       tilesButton(
                      //   title: 'Report\nTraffic Incident',
                      //   imagepath: 'assets/images/trafficindident.png',
                      //   onTap: ()async {
                      //    SharedPreferences prefs = await SharedPreferences.getInstance();

                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder:
                      //             (context) => trafficreport(
                      //               onThemeChanged: widget.onThemeChanged,
                      //               isDarkMode: widget.isDarkMode,
                      //             ),
                      //       ),
                      //     );
                      //   },
                      // ),

                      // 🔹 Extra buttons only when showMore is true
                      if (showMore) ...[
                   

                        tilesButton(
                          title: 'Pay Traffic \nChallan',
                          imagepath: 'assets/images/14897102.png',
                          onTap: () async {
                            const ur1 =
                                'https://echallan.parivahan.gov.in/index/accused-challan';
                            if (await canLaunchUrl(Uri.parse(ur1))) {
                              await launchUrl(Uri.parse(ur1));
                            } else {
                              debugPrint("Could not launch $ur1");
                            }
                          },
                        ),
                        tilesButton(
                          title: 'Download \nFIR ',
                          imagepath: 'assets/images/firdownload.png',
                          onTap: () async {
                            const ur1 =
                                'https://bidhannagarcitypolice.gov.in/fir_record.php';
                            if (await canLaunchUrl(Uri.parse(ur1))) {
                              await launchUrl(
                                Uri.parse(ur1),
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              debugPrint("Could not launch $ur1");
                            }
                          },
                        ),
                        tilesButton(
                          title: 'Apply for \nPCC',
                          imagepath: 'assets/images/2490354.png',
                          onTap: () async {
                            const Ur1 = 'https://pcc.wb.gov.in/';
                            if (await canLaunchUrl(Uri.parse(Ur1))) {
                              await launchUrl(Uri.parse(Ur1));
                            } else {
                              debugPrint("Could not launch $Ur1");
                            }
                          },
                        ),
                        //   tilesButton(
                        //   title: 'Saanjh Baati\nRegistration',
                        //   imagepath: 'assets/images/10551084.png',
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => SaanjhBatiPage(),
                        //       ),
                        //     );
                        //   },
                        // ),
                              tilesButton(
                          title: 'Passport\nStatus',
                          imagepath: 'assets/images/620765.png',
                          onTap: () async {
                            const ur1 =
                                'https://www.passportindia.gov.in/psp/trackApplicationService';
                            if (await canLaunchUrl(Uri.parse(ur1))) {
                              await launchUrl(Uri.parse(ur1));
                            } else {
                              debugPrint("Could not launch $ur1");
                            }
                          },
                        ),
                        tilesButton(
                          title: 'Registration\nForms',
                          imagepath:
                              'assets/images/authentication_14291356.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => formspage(
                                      onThemeChanged: widget.onThemeChanged,
                                      isDarkMode: widget.isDarkMode,
                                    ),
                                // docsdownviewpage(
                                //   filePath:
                                //       'assets/images/Sarai Application.pdf',
                                //   title: 'Sarai Application',
                                // ),
                              ),
                            );
                          },
                        ),
                          tilesButton(
                        title: ' Police\nContact ',
                        imagepath: 'assets/images/phone-book_7229022.png',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => contactscreen(
                                    onThemeChanged: widget.onThemeChanged,
                                    isDarkMode: widget.isDarkMode,
                                  ),
                            ),
                          );
                        },
                      ),

                        // tilesButton(
                        //   title: 'Tenant\nRegistration',
                        //   imagepath: 'assets/images/tenant.png',
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder:
                        //             (context) => docsdownviewpage(
                        //               filePath:
                        //                   'assets/images/Tenant Registration Form.pdf',
                        //               title: 'Tenant Registration',
                        //             ),
                        //       ),
                        //     );
                        //   },
                        // ),
                        // ServiceButton(
                        //   title: 'Missing Person',
                        //   imagepath: 'assets/images/siren_9056479.png',
                        //   onTap: () async {
                        //     const ur1 =
                        //         'https://bidhannagarcitypolice.gov.in/missing_person.php';
                        //     if (await canLaunchUrl(Uri.parse(ur1))) {
                        //       await launchUrl(
                        //         Uri.parse(ur1),
                        //         mode: LaunchMode.externalApplication,
                        //       );
                        //     } else {
                        //       debugPrint("Could not launch $ur1");
                        //     }
                        //   },
                        // ),
                  

                        // ServiceButton(
                        //   title: 'Traffic Rules',
                        //   imagepath: 'assets/images/direction-board_17575680.png',
                        //   onTap: () async {
                        //     const ur1 =
                        //         'https://bidhannagarcitypolice.gov.in/assets/docs/TrafficRules.pdf';
                        //     if (await canLaunchUrl(Uri.parse(ur1))) {
                        //       await launchUrl(
                        //         Uri.parse(ur1),
                        //         mode: LaunchMode.externalApplication,
                        //       );
                        //     } else {
                        //       debugPrint("Could not launch $ur1");
                        //     }
                        //   },
                        // ),
                      ],

                      // 🔹 Last button always Toggle (More / Hide)
                      tilesButton(
                        title: showMore ? "Hide" : "More",
                        imagepath: 'assets/images/17470916.png',
                        onTap: () {
                          setState(() {
                            showMore = !showMore;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Enquiry center
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),

                  child: Container(
                    //  height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              : const Color(0xFFe9e4de),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          // child: Text(
                          //   'Find My Parking',
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                        ),
                        SizedBox(height:10),

                        // SingleChildScrollView(
                        //   scrollDirection: Axis.horizontal,
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(bottom: 5, left: 2),
                        //     child: Row(
                        //       children: [
                        //         // SizedBox(
                        //         //   height:
                        //         //       MediaQuery.of(context).size.height * 0.065,
                        //         //   width:
                        //         //       MediaQuery.of(context).size.height * 0.19,
                        //         //   child: ElevatedButton(
                        //         //     style: ElevatedButton.styleFrom(
                        //         //       backgroundColor: Colors.white,

                        //         //       elevation: 2,
                        //         //       shape: RoundedRectangleBorder(
                        //         //         borderRadius: BorderRadius.circular(15),
                        //         //       ),
                        //         //       shadowColor: Colors.black,
                        //         //       padding: EdgeInsets.zero,
                        //         //     ),
                        //         //     onPressed: (){
                        //         //       Navigator.push(context,
                        //         //       MaterialPageRoute(builder: (context) => docsdownviewpage(filePath: 'assets/images/Untitled_compressed.pdf', title: 'DURGA PUJA 2025'),));
                        //         //     },
                        //         //     child: Row(
                        //         //       mainAxisAlignment: MainAxisAlignment.center,
                        //         //       children: [
                        //         //         Image.asset(
                        //         //           'assets/images/durga icon.png',
                        //         //           height: 35,
                        //         //         ),
                        //         //         SizedBox(width: 10),
                        //         //         Column(
                        //         //           mainAxisSize: MainAxisSize.min,
                        //         //           children: [
                        //         //             Text(
                        //         //               'Durga Puja',
                        //         //               style: TextStyle(
                        //         //                 fontWeight: FontWeight.w500,
                        //         //                 fontSize:
                        //         //                     MediaQuery.of(
                        //         //                       context,
                        //         //                     ).size.height *
                        //         //                     0.013,
                        //         //               ),
                        //         //             ),
                        //         //             Text(
                        //         //               'Guide Map',
                        //         //               style: TextStyle(fontSize: 8),
                        //         //             ),
                        //         //           ],
                        //         //         ),
                        //         //       ],
                        //         //     ),
                        //         //   ),
                        //         // ),
                        //         //   SizedBox(width: 10),
                        //         //durga puja map
                        //         //                           SizedBox(
                        //         //   height: MediaQuery.of(context).size.height * 0.065,
                        //         //   width: MediaQuery.of(context).size.height * 0.19,
                        //         //   child: ElevatedButton(
                        //         //     style: ElevatedButton.styleFrom(
                        //         //       backgroundColor: Colors.white,
                        //         //       elevation: 2,
                        //         //       shape: RoundedRectangleBorder(
                        //         //         borderRadius: BorderRadius.circular(15),
                        //         //       ),
                        //         //       shadowColor: Colors.black,
                        //         //       padding: EdgeInsets.zero,
                        //         //     ),
                        //         //     onPressed: () async {
                        //         //       final Uri url = Uri.parse('https://www.google.com/maps/search/Durga+Puja+2025+nearby/');
                        //         //       if (await canLaunchUrl(url)) {
                        //         //         await launchUrl(url, mode: LaunchMode.externalApplication);
                        //         //       } else {
                        //         //         ScaffoldMessenger.of(context).showSnackBar(
                        //         //           const SnackBar(content: Text('Could not open map')),
                        //         //         );
                        //         //       }
                        //         //     },
                        //         //     child: Row(
                        //         //       mainAxisAlignment: MainAxisAlignment.center,
                        //         //       children: [
                        //         //         Image.asset(
                        //         //           'assets/images/temple_1183161.png',
                        //         //           height: 35,
                        //         //         ),
                        //         //         const SizedBox(width: 10),
                        //         //         Column(
                        //         //           mainAxisSize: MainAxisSize.min,
                        //         //           children: [
                        //         //             Text(
                        //         //               'Durga Puja',
                        //         //               style: TextStyle(
                        //         //                 fontWeight: FontWeight.w500,
                        //         //                 fontSize: MediaQuery.of(context).size.height * 0.013,
                        //         //               ),
                        //         //             ),
                        //         //             const Text(
                        //         //               'Nearby Pandel',
                        //         //               style: TextStyle(fontSize: 8),
                        //         //             ),
                        //         //           ],
                        //         //         ),
                        //         //       ],
                        //         //     ),
                        //         //   ),
                        //         // ),
                        //         SizedBox(width: 10),
                        //         SizedBox(
                        //           height:
                        //               MediaQuery.of(context).size.height *
                        //               0.065,
                        //           width: w * 0.19,
                        //           child: ElevatedButton(
                        //             style: ElevatedButton.styleFrom(
                        //               backgroundColor:
                        //                   Theme.of(context).brightness ==
                        //                           Brightness.dark
                        //                       ? Color(0xFF1A1A1A)
                        //                       : Color(0xfff7f2f9),

                        //               elevation: 2,
                        //               shape: RoundedRectangleBorder(
                        //                 borderRadius: BorderRadius.circular(15),
                        //               ),
                        //               shadowColor: Colors.black,
                        //               padding: EdgeInsets.zero,
                        //             ),
                        //             onPressed: callnumber,
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 Image.asset(
                        //                   'assets/images/dials.png',
                        //                   height: 35,
                        //                 ),
                        //                 SizedBox(width: 10),
                        //                 Column(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   children: [
                        //                     Text(
                        //                       'Dial 100',
                        //                       style: TextStyle(
                        //                         fontWeight: FontWeight.w500,
                        //                         fontSize:
                        //                             MediaQuery.of(
                        //                               context,
                        //                             ).size.height *
                        //                             0.013,
                        //                       ),
                        //                     ),
                        //                     Text(
                        //                       'Police Helpline',
                        //                       style: TextStyle(fontSize: 8),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),

                        //         SizedBox(width: 10),
                        //         SizedBox(
                        //           height:
                        //               MediaQuery.of(context).size.height *
                        //               0.065,
                        //           width:
                        //               MediaQuery.of(context).size.height * 0.19,
                        //           child: ElevatedButton(
                        //             style: ElevatedButton.styleFrom(
                        //               backgroundColor:
                        //                   Theme.of(context).brightness ==
                        //                           Brightness.dark
                        //                       ? Color(0xFF1A1A1A)
                        //                       : Color(0xfff7f2f9),

                        //               elevation: 2,
                        //               shape: RoundedRectangleBorder(
                        //                 borderRadius: BorderRadius.circular(15),
                        //               ),
                        //               shadowColor: Colors.black,
                        //               padding: EdgeInsets.zero,
                        //             ),
                        //             onPressed: callnumber1,
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 Image.asset(
                        //                   'assets/images/hotline_7833545.png',
                        //                   height: 35,
                        //                 ),
                        //                 SizedBox(width: 10),
                        //                 Column(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   children: [
                        //                     Text(
                        //                       'Dial 101',
                        //                       style: TextStyle(
                        //                         fontWeight: FontWeight.w500,
                        //                         fontSize:
                        //                             MediaQuery.of(
                        //                               context,
                        //                             ).size.height *
                        //                             0.013,
                        //                       ),
                        //                     ),
                        //                     Text(
                        //                       'Fire Helpline',
                        //                       style: TextStyle(fontSize: 8),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(width: 10),
                        //         SizedBox(
                        //           height:
                        //               MediaQuery.of(context).size.height *
                        //               0.065,
                        //           width:
                        //               MediaQuery.of(context).size.height * 0.19,
                        //           child: ElevatedButton(
                        //             style: ElevatedButton.styleFrom(
                        //               backgroundColor:
                        //                   Theme.of(context).brightness ==
                        //                           Brightness.dark
                        //                       ? Color(0xFF1A1A1A)
                        //                       : Color(0xfff7f2f9),

                        //               elevation: 2,
                        //               shape: RoundedRectangleBorder(
                        //                 borderRadius: BorderRadius.circular(15),
                        //               ),
                        //               shadowColor: Colors.black,
                        //               padding: EdgeInsets.zero,
                        //             ),
                        //             onPressed: callnumber3,
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 Image.asset(
                        //                   'assets/images/ambulance.png',
                        //                   height: 35,
                        //                 ),
                        //                 SizedBox(width: 10),
                        //                 Column(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   children: [
                        //                     Text(
                        //                       'Dial 102',
                        //                       style: TextStyle(
                        //                         fontWeight: FontWeight.w500,
                        //                         fontSize:
                        //                             MediaQuery.of(
                        //                               context,
                        //                             ).size.height *
                        //                             0.013,
                        //                       ),
                        //                     ),
                        //                     Text(
                        //                       'Ambulance',
                        //                       style: TextStyle(fontSize: 8),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),

                        //         SizedBox(width: 10),
                        //         SizedBox(
                        //           height:
                        //               MediaQuery.of(context).size.height *
                        //               0.065,
                        //           width:
                        //               MediaQuery.of(context).size.height * 0.19,
                        //           child: ElevatedButton(
                        //             style: ElevatedButton.styleFrom(
                        //               backgroundColor:
                        //                   Theme.of(context).brightness ==
                        //                           Brightness.dark
                        //                       ? Color(0xFF1A1A1A)
                        //                       : Color(0xfff7f2f9),

                        //               elevation: 2,
                        //               shape: RoundedRectangleBorder(
                        //                 borderRadius: BorderRadius.circular(15),
                        //               ),
                        //               shadowColor: Colors.black,
                        //               padding: EdgeInsets.zero,
                        //             ),
                        //             onPressed: callnumber4,
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 Image.asset(
                        //                   'assets/images/hacker.png',
                        //                   height: 35,
                        //                 ),
                        //                 SizedBox(width: 10),
                        //                 Column(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   children: [
                        //                     Text(
                        //                       'Dial 1930',
                        //                       style: TextStyle(
                        //                         fontWeight: FontWeight.w500,
                        //                         fontSize:
                        //                             MediaQuery.of(
                        //                               context,
                        //                             ).size.height *
                        //                             0.013,
                        //                       ),
                        //                     ),
                        //                     Text(
                        //                       'Report Cyber Crime ',
                        //                       style: TextStyle(fontSize: 8),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(width: 10),

                        //         SizedBox(
                        //           height:
                        //               MediaQuery.of(context).size.height *
                        //               0.065,
                        //           width:
                        //               MediaQuery.of(context).size.height * 0.19,
                        //           child: ElevatedButton(
                        //             style: ElevatedButton.styleFrom(
                        //               backgroundColor:
                        //                   Theme.of(context).brightness ==
                        //                           Brightness.dark
                        //                       ? Color(0xFF1A1A1A)
                        //                       : Color(0xfff7f2f9),

                        //               elevation: 2,
                        //               shape: RoundedRectangleBorder(
                        //                 borderRadius: BorderRadius.circular(15),
                        //               ),
                        //               shadowColor: Colors.black,
                        //               padding: EdgeInsets.zero,
                        //             ),
                        //             onPressed: () async {
                        //               const ur1 =
                        //                   'https://www.aai.aero/en/airports/flights-schedule/kolkata'; // police help line
                        //               if (await canLaunchUrl(Uri.parse(ur1))) {
                        //                 await launchUrl(
                        //                   Uri.parse(ur1),
                        //                   mode: LaunchMode.platformDefault,
                        //                 );
                        //               } else {
                        //                 debugPrint('Could Not Found $ur1');
                        //               }
                        //             },
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 Image.asset(
                        //                   'assets/images/airport.png',
                        //                   height: 35,
                        //                 ),
                        //                 SizedBox(width: 10),
                        //                 Column(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   children: [
                        //                     Text(
                        //                       'Airport',
                        //                       style: TextStyle(
                        //                         fontWeight: FontWeight.w500,
                        //                         fontSize:
                        //                             MediaQuery.of(
                        //                               context,
                        //                             ).size.height *
                        //                             0.013,
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(width: 10),
                        //         SizedBox(
                        //           height:
                        //               MediaQuery.of(context).size.height *
                        //               0.065,
                        //           width:
                        //               MediaQuery.of(context).size.height * 0.19,
                        //           child: ElevatedButton(
                        //             style: ElevatedButton.styleFrom(
                        //               backgroundColor:
                        //                   Theme.of(context).brightness ==
                        //                           Brightness.dark
                        //                       ? Color(0xFF1A1A1A)
                        //                       : Color(0xfff7f2f9),

                        //               elevation: 2,
                        //               shape: RoundedRectangleBorder(
                        //                 borderRadius: BorderRadius.circular(15),
                        //               ),
                        //               shadowColor: Colors.black,
                        //               padding: EdgeInsets.zero,
                        //             ),
                        //             onPressed: () async {
                        //               // if (await canLaunchUrl(
                        //               //   Uri.parse('https://bnpcdeveloper.co.in/bnpolice/park/form.php'),
                        //               //   )

                        //               // ) {
                        //               //   await launchUrl(
                        //               //     Uri.parse('https://bnpcdeveloper.co.in/bnpolice/park/form.php'),
                        //               //     mode: LaunchMode.platformDefault,
                        //               //   );
                        //               // }

                        //               Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(
                        //                   builder:
                        //                       (context) =>
                        //                       //   webviewparkingpage
                        //                       AllParkingMap(
                        //                         onThemeChanged:
                        //                             widget.onThemeChanged,
                        //                         isDarkMode: widget.isDarkMode,
                        //                       ),
                        //                 ),
                        //               );
                        //             },
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 Image.asset(
                        //                   'assets/images/parking-area.png',
                        //                   height: 35,
                        //                 ),
                        //                 SizedBox(width: 10),
                        //                 Column(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   children: [
                        //                     Text(
                        //                       'Parking',
                        //                       style: TextStyle(
                        //                         fontWeight: FontWeight.w500,
                        //                         fontSize:
                        //                             MediaQuery.of(
                        //                               context,
                        //                             ).size.height *
                        //                             0.013,
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),

                        //         SizedBox(width: 10),
                        //       ],
                        //     ),
                        //   ),
                        // ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                 SizedBox(
                                         height:
                                     MediaQuery.of(context).size.height *
                                      0.065,
                                   width:
                                       MediaQuery.of(context).size.height * 0.21,
                                      
                                      
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Color(0xFF1A1A1A)
                                                  : Color(0xfff7f2f9),
                              
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          shadowColor: Colors.black,
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () async {
                                          // if (await canLaunchUrl(
                                          //   Uri.parse('https://bnpcdeveloper.co.in/bnpolice/park/form.php'),
                                          //   )
                              
                                          // ) {
                                          //   await launchUrl(
                                          //     Uri.parse('https://bnpcdeveloper.co.in/bnpolice/park/form.php'),
                                          //     mode: LaunchMode.platformDefault,
                                          //   );
                                          // }
                              
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                  //   webviewparkingpage
                                                  Messipage(
                                                    onThemeChanged:
                                                        widget.onThemeChanged,
                                                    isDarkMode: widget.isDarkMode,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/messiicons.png',
                                              height: 35,
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Welcome MESSI',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.height *
                                                        0.013,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                              SizedBox(
                                 height:    MediaQuery.of(context).size.height *
                                      0.065,
                                   width:
                                       MediaQuery.of(context).size.height * 0.21,
                                        //  MediaQuery.of(context).size.height * 0.19,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Color(0xFF1A1A1A)
                                                  : Color(0xfff7f2f9),
                              
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          shadowColor: Colors.black,
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () async {
                                          // if (await canLaunchUrl(
                                          //   Uri.parse('https://bnpcdeveloper.co.in/bnpolice/park/form.php'),
                                          //   )
                              
                                          // ) {
                                          //   await launchUrl(
                                          //     Uri.parse('https://bnpcdeveloper.co.in/bnpolice/park/form.php'),
                                          //     mode: LaunchMode.platformDefault,
                                          //   );
                                          // }
                              
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                  //   webviewparkingpage
                                                  AllParkingMap(
                                                    onThemeChanged:
                                                        widget.onThemeChanged,
                                                    isDarkMode: widget.isDarkMode,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/parking-area.png',
                                              height: 35,
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  ' Find My Parking',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.height *
                                                        0.013,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                //quize cyber
                // quiz cyber
                // _BlinkingContainer(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                //     child: GestureDetector(
                //       onTap: () async {
                //         const url =
                //             'https://docs.google.com/forms/d/e/1FAIpQLSfHugYvzymXy6bkO-_PJd0F1hS687wXELUqj5-XZSnSPZuXOQ/viewform';
                //         if (await canLaunchUrl(Uri.parse(url))) {
                //           await launchUrl(
                //             Uri.parse(url),
                //             mode: LaunchMode.externalApplication,
                //           );
                //         } else {
                //           debugPrint("Could not launch $url");
                //         }
                //       },
                //       child: Container(
                //         height: 65,
                //         width: double.infinity,
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(15),
                //           boxShadow: [
                //             BoxShadow(
                //               color: Colors.black.withOpacity(0.15),
                //               spreadRadius: 1,
                //               blurRadius: 6,
                //               offset: Offset(0, 3),
                //             ),
                //           ],
                //         ),
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Row(
                //             children: [
                //               Chip(
                //                 label: Icon(
                //                   Icons.quiz_outlined,
                //                   size: 15,
                //                   color: Colors.blue,
                //                 ),
                //                 backgroundColor: Colors.grey.shade200,
                //               ),
                //               SizedBox(width: 8),
                //               Expanded(
                //                 child: Text(
                //                   'Tech Cyber Quiz',
                //                   style: TextStyle(
                //                     fontWeight: FontWeight.bold,
                //                     fontSize: MediaQuery.of(context).size.height * 0.015,
                //                   ),
                //                 ),
                //               ),
                //               Icon(Icons.more_vert_outlined, size: 20),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 10),
                // 🔹 Important Notice
                Text(
                  'Notices',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: GestureDetector(
                    onTap: () async {},
                    child: Container(
                      height: 65, // mini container height
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.black
                                : const Color(0xFFe9e4de),

                        borderRadius: BorderRadius.circular(15),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withOpacity(0.15),
                        //     spreadRadius: 1,
                        //     blurRadius: 6,
                        //     offset: Offset(0, 3), // shadow direction
                        //   ),
                        // ],
                      ),
                      child:
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : notices.isEmpty
                              ? const Center(
                                child: Text('No notices available'),
                              )
                              : SizedBox(
                                height:
                                    120, // 👈 fixed height required for horizontal scroll
                                child: ListView.builder(
                                  controller:
                                      _scrollController, // 👈 controller added
                                  scrollDirection:
                                      Axis.horizontal, // 👈 scrolls left-right
                                  itemCount: notices.length,
                                  itemBuilder: (context, index) {
                                    final item = notices[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => noticedetails(
                                                  onThemeChanged:
                                                      widget.onThemeChanged,
                                                  isDarkMode: widget.isDarkMode,
                                                ),
                                          ),
                                        );
                                      }, // 👈 open PDF on tap
                                      child: Container(
                                        width: 200, // 👈 each card width
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 8,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color:
                                              Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Color(0xFF1A1A1A)
                                                  : Color(0xfff7f2f9),

                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          // border: Border.all(
                                          //   color: Colors.grey.shade300,
                                          // ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item['subject'] ?? '',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                //  textAlign: TextAlign.right,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            const Icon(
                                              Icons.picture_as_pdf,
                                              color: Colors.red,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 Updates Section
                Container(
                  //  padding: const EdgeInsets.only(left: 0, right:0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Follow Bidhannagar Police",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Facebook button
                            ServiceButton(
                              title: '',
                              imagepath: 'assets/images/fb.png',
                              onTap: () async {
                                const ur1 =
                                    'https://www.facebook.com/bdncitypolice';
                                if (await canLaunchUrl(Uri.parse(ur1))) {
                                  await launchUrl(
                                    Uri.parse(ur1),
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                            ),
                            //whtsapp
                            ServiceButton(
                              title: '',
                              imagepath: 'assets/images/wp.png',
                              onTap: () async {
                                const ur1 =
                                    'https://whatsapp.com/channel/0029Vb6ktnC1Hsq1kV1ZEI04';
                                if (await canLaunchUrl(Uri.parse(ur1))) {
                                  await launchUrl(
                                    Uri.parse(ur1),
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                            ),
                            // X button
                            ServiceButton(
                              title: '',
                              imagepath: 'assets/images/x.png',
                              onTap: () async {
                                const ur1 = 'https://x.com/bidhannagarpc?s=11';
                                if (await canLaunchUrl(Uri.parse(ur1))) {
                                  await launchUrl(
                                    Uri.parse(ur1),
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  debugPrint("Could not launch $ur1");
                                }
                                setState(() {
                                  selectedfeedback = "📰 X Feeds";
                                });
                              },
                            ),
                            // YouTube button
                            ServiceButton(
                              title: '',
                              imagepath: 'assets/images/yt2.png',
                              onTap: () async {
                                const ur1 =
                                    'https://youtube.com/@bidhannagar.citypolice?si=JnS5_PoFwzu3uXgl';
                                if (await canLaunchUrl(Uri.parse(ur1))) {
                                  await launchUrl(
                                    Uri.parse(ur1),
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  debugPrint("Could not launch $ur1");
                                }
                                setState(() {
                                  selectedfeedback = "▶️ YouTube Feeds";
                                });
                              },
                            ),
                            // Instagram button
                            ServiceButton(
                              title: '',
                              imagepath: 'assets/images/insta.png',
                              onTap: () async {
                                const ur1 =
                                    'https://www.instagram.com/bidhannagarpolice?igsh=bzJxOTZ4Z2k0eG9s';
                                if (await canLaunchUrl(Uri.parse(ur1))) {
                                  await launchUrl(
                                    Uri.parse(ur1),
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  debugPrint("Could not launch $ur1");
                                }
                                setState(() {
                                  selectedfeedback = "📸 Instagram Feeds";
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      //   const SizedBox(height: 10),
                      Text(
                        'Latest Updates',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),

                      // 🔹 Feed Container
                      // 🔹 Feed Container
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0,
                        ), // ✅ better spacing
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: FutureBuilder<List<NoticeModel>>(
                            future: ApiService.fetchNotices(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text("Error: ${snapshot.error}"),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                  child: Text("No notices found"),
                                );
                              }

                              final notices = snapshot.data!;

                              return ListView.builder(
                                itemCount: notices.length,
                                itemBuilder: (context, index) {
                                  final notice = notices[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ), // ✅ top-bottom spacing
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    color:
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Color(0xFF1A1A1A)
                                            : Color(0xfff7f2f9),

                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                        12,
                                      ), // ✅ inner padding
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Text(
                                          //   notice.dept,
                                          //   style: const TextStyle(fontWeight: FontWeight.bold),
                                          // ),
                                          const SizedBox(height: 10),

                                          if (notice.image1.isNotEmpty)
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) => Imageviwer(
                                                          Imageview:
                                                              notice.image1,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                height:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.27,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      notice.image1,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          const SizedBox(height: 10),

                                          Center(
                                            child: Text(
                                              notice.topic,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),

                                          ExpandableTextWidget(
                                            text: notice.des,
                                            maxLines: 2,
                                          ),

                                          const SizedBox(height: 10),

                                          Text(
                                            "Published: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(notice.createdDate))}",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),

                      Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // // ✅ Bottom Navigation
        // bottomNavigationBar: Container(
        //   margin: const EdgeInsets.all(12), // ⬅️ floating effect
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.circular(30),
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.black.withOpacity(0.15),
        //         blurRadius: 12,
        //         offset: const Offset(0, 6), // soft shadow
        //       ),
        //     ],
        //   ),
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.circular(30),
        //     child: BottomNavigationBar(
        //       currentIndex: _selectedindex,
        //       onTap: (index) async {
        //         setState(() {
        //           _selectedindex = index;
        //         });

        //         // ✅ SOS logic remains same
        //         if (index == 2) {
        //           callnumber2();
        //         } else if (index == 0) {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(builder: (context) => homepage()),
        //           );
        //         } else if (index == 1) {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(builder: (context) => contactscreen()),
        //           );
        //         } else if (index == 3) {
        //           const ur1 =
        //               'https://bidhannagarcitypolice.gov.in/police_station.php';
        //           if (await canLaunchUrl(Uri.parse(ur1))) {
        //             await launchUrl(
        //               Uri.parse(ur1),
        //               mode: LaunchMode.externalApplication,
        //             );
        //           } else {
        //             debugPrint("Could not launch $ur1");
        //           }
        //         } else if (index == 4) {
        //           const ur1 = 'https://cybercrime.gov.in/Webform/Index.aspx';
        //           if (await canLaunchUrl(Uri.parse(ur1))) {
        //             await launchUrl(
        //               Uri.parse(ur1),
        //               mode: LaunchMode.externalApplication,
        //             );
        //           } else {
        //             debugPrint('Could not Lauch $ur1');
        //           }
        //         }
        //       },
        //       type: BottomNavigationBarType.fixed,
        //       backgroundColor: Colors.white,
        //       elevation: 0,

        //       // ✅ Better colors
        //       selectedItemColor: Colors.blue.shade900,
        //       unselectedItemColor: Colors.grey.shade500,

        //       // ✅ Font improvements
        //       selectedFontSize: 10,
        //       unselectedFontSize: 9,
        //       selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        //       unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),

        //       iconSize: 20,

        //       items: const [
        //         BottomNavigationBarItem(
        //           icon: Icon(Icons.home_outlined),
        //           label: "Home",
        //         ),
        //         BottomNavigationBarItem(
        //           icon: Icon(Icons.phone_enabled_outlined),
        //           label: "Contact",
        //         ),
        //         BottomNavigationBarItem(
        //           icon: ImageIcon(
        //             AssetImage('assets/images/sos_1894555.png'),
        //             size: 38, // 🔥 bigger center icon
        //             color: Colors.red,
        //           ),
        //           label: "SOS",
        //         ),
        //         BottomNavigationBarItem(
        //           icon: Icon(Icons.location_on_outlined),
        //           label: "Locate me",
        //         ),
        //         BottomNavigationBarItem(
        //           icon: Icon(Icons.comment_outlined),
        //           label: "Complaint",
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12),
            FloatingActionButton(
              backgroundColor: Colors.white,
              heroTag: 'btn2',
              onPressed: () async {
                const ur1 = 'https://wa.me/+919147889491';

                if (await canLaunchUrl(Uri.parse(ur1))) {
                  await launchUrl(
                    Uri.parse(ur1),
                    mode: LaunchMode.platformDefault,
                  );
                } else {
                  debugPrint("Could not launch $ur1");
                }
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('WhatsApp helpline..')));
              },
              child: Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.green,
                size: 45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Reusable Service Button Widget with Icon + Text
class ServiceButton extends StatelessWidget {
  final String title;
  final String imagepath;
  final VoidCallback? onTap;

  const ServiceButton({
    super.key,
    required this.title,
    required this.imagepath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            shadowColor: Colors.black,
          ),
          onPressed: onTap ?? () {},
          child: Image.asset(
            imagepath,
            height: 30,
            width: 30,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.013,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// reuse tiles button
class tilesButton extends StatelessWidget {
  final String title;
  final String imagepath;
  final VoidCallback? onTap;

  const tilesButton({
    super.key,
    required this.title,
    required this.imagepath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        shadowColor: Colors.black,
      ),
      onPressed: onTap ?? () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(imagepath, height: 40, width: 40, fit: BoxFit.cover),
          SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.015,

              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildExpansionTile({
  required IconData icon,
  required String title,
  required List<Widget> children,
}) {
  return ExpansionTile(
    leading: Icon(icon, color: Colors.blue),
    title: Text(
      title,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    ),
    children: children,
  );
}

Widget _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
  return ListTile(
    leading: Icon(icon, color: Colors.blue),
    title: Text(title, style: const TextStyle(fontSize: 13)),
    onTap: onTap ?? () {},
  );
}

// 🔹 Reusable Button Widget
Widget buttonWidget(String text) {
  return InkWell(
    onTap: () {
      debugPrint("$text Button Pressed");
    },
    borderRadius: BorderRadius.circular(7),
    child: Container(
      height: 35,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 3,
            offset: const Offset(1, 2),
          ),
        ],
        color: const Color(0xFFfcf6fe),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    ),
  );
}

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableTextWidget({
    super.key,
    required this.text,
    this.maxLines = 2,
  });

  @override
  _ExpandableTextWidgetState createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: isExpanded ? null : widget.maxLines,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? "Read less" : "Read more",
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

// Blinking
class _BlinkingContainer extends StatefulWidget {
  final Widget child;
  const _BlinkingContainer({required this.child});

  @override
  State<_BlinkingContainer> createState() => _BlinkingContainerState();
}

class _BlinkingContainerState extends State<_BlinkingContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true); // fade in/out
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _controller, child: widget.child);
  }
}

class SettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const SettingsPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool localDarkMode;

  @override
  void initState() {
    super.initState();
    localDarkMode = widget.isDarkMode; // sync initial
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        localDarkMode ? "Dark Mode" : "Light Mode",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),

      secondary: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          localDarkMode ? Icons.dark_mode : Icons.light_mode,
          key: ValueKey(localDarkMode),
          color: localDarkMode ? Colors.white : Colors.black87,
        ),
      ),

      activeThumbColor: Colors.amberAccent,
      value: localDarkMode,

      onChanged: (value) {
        setState(() => localDarkMode = value); // instant UI update
        widget.onThemeChanged(value); // notify parent
      },
    );
  }
}
