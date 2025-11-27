
import 'package:bidhannagarpoliceapp/login.dart';
import 'package:bidhannagarpoliceapp/signuppage.dart';
import 'package:bidhannagarpoliceapp/webviewsaanjhbati.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SaanjhBatiPage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const SaanjhBatiPage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<SaanjhBatiPage> createState() => _SaanjhBatiPageState();
}

class _SaanjhBatiPageState extends State<SaanjhBatiPage> {
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
            // Card for description
            Card(
              color: Theme.of(context).cardColor, // AUTO THEME CARD COLOR
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
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      'SAANJ BAATI',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'An initiative of Bidhannagar Police for elderly citizens',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Since its initial days, Salt Lake City, or Bidhannagar, has had a significant population of senior citizens who live alone. '
                      'And, to reach out to these people - for not only their safety and security, but also to take care of their health and happiness - '
                      'the Bidhannagar City Police, along with OFFER, a non-profit organisation, came up with Saanjhbaati, '
                      'a community policing project for elderly persons living alone in this jurisdiction.',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // PDF Button
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
                                        ) => signuppage(
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
                                        Webviewsaanjhbati(onThemeChanged:widget. onThemeChanged,
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
              
              // () async {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder:
              //           (context) => Webviewsaanjhbati(
              //             onThemeChanged: widget.onThemeChanged,
              //             isDarkMode: widget.isDarkMode,
              //           ),
              //     ),
              //   );
              // },
              icon: const Icon(Icons.app_registration),
              label: const Text('Registration Form'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white, // BUTTON TEXT COLOR FIX
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

            // Emergency Contact Button
            ElevatedButton.icon(
              onPressed: sanjbaticont,
              icon: const Icon(Icons.contact_phone),
              label: const Text('Emergency Contact'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white, // BUTTON TEXT COLOR FIX
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
          ],
        ),
      ),
    );
  }
}
