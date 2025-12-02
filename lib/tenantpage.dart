
import 'package:bidhannagarpoliceapp/login.dart';
import 'package:bidhannagarpoliceapp/registerotppage.dart';
import 'package:bidhannagarpoliceapp/signuppage.dart';
import 'package:bidhannagarpoliceapp/webviewtenantpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class tenantpage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const tenantpage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<tenantpage> createState() => _tenantpageState();
}

class _tenantpageState extends State<tenantpage> {
   final TextEditingController phoneController = TextEditingController();
  final Uri saanjbaatihelp = Uri(scheme: 'tel', path: '9748898933');

  Future<void> sanjbaticont() async {
    if (await canLaunchUrl(saanjbaatihelp)) {
      await launchUrl(saanjbaatihelp);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch phone app")),
      );
    }
  }
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
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFe9e4de),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 45),

        child: Column(
          children: [
            // --------------------------------------------
            //  TOP WELCOME CARD
            // --------------------------------------------
            Card(
              color: isDark ? Colors.grey[900] : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              shadowColor: Colors.blueAccent.withOpacity(0.3),

              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WELCOME TO',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      'Tenant Registration',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      'An initiative by Bidhannagar Police',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Tenant Registration with Bidhannagar Police aims to enhance the safety and security of residents within the Commissionerate area.' 
                     ' \nAll landlords/owners letting out residential or commercial premises are requested to furnish accurate details of their tenants through this form for police records and verification purposes.'
                      ' The information provided will be used only for law and order, crime prevention, and verification, and will be treated with utmost confidentiality as per existing laws.'

'Landlords are requested to ensure timely submission of this form, preferably before handover of possession, and to intimate any subsequent change of tenancy or occupants without delay.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---------------------------------------------------
            //   REGISTRATION FORM BUTTON
            // ---------------------------------------------------
            ElevatedButton.icon(
              onPressed: () async {
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
                                        webviewtennatpage(onThemeChanged:widget. onThemeChanged,
                                         isDarkMode:widget. isDarkMode),
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
              
              // onPressed: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder:
              //           (context) => webviewtennatpage(
              //             onThemeChanged: widget.onThemeChanged,
              //             isDarkMode: widget.isDarkMode,
              //           ),
              //     ),
              //   );
              // },

              icon: const Icon(Icons.app_registration),
              label: const Text(
                'Registration Form',
                style: TextStyle(color: Colors.white),
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
