import 'dart:async';
import 'package:bidhannagarpoliceapp/homepage.dart';
import 'package:bidhannagarpoliceapp/login.dart';
import 'package:bidhannagarpoliceapp/registerotppage.dart';
import 'package:bidhannagarpoliceapp/signuppage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isloggedin') ?? false;
  bool isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    isDarkMode: isDarkMode,
  ));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  final bool isDarkMode;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    required this.isDarkMode,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;
  late bool isLoggedIn;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    isLoggedIn = widget.isLoggedIn;
  }

  // 🔥 THEME TOGGLE FUNCTION
  void _toggleTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isDarkMode = value;
    });

    await prefs.setBool('isDarkMode', value);

  //  Optional SnackBar
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //       value ? "🌙 Dark Mode Enabled" : "☀️ Light Mode Enabled",
    //     ),
    //     duration: const Duration(seconds: 1),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // THEME FIX: Rebuilds instantly on toggle
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),

      // Page control
      home: isLoggedIn
          ? homepage(
              onThemeChanged: _toggleTheme,
              isDarkMode: isDarkMode,
            )
          : SplashScreen(
              onThemeChanged: _toggleTheme,
              isDarkMode: isDarkMode,
            ),
    );
  }
}

// -----------------------------------------
// SPLASH SCREEN
// -----------------------------------------
class SplashScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const SplashScreen({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 900),
        pageBuilder: (context, animation, secondaryAnimation) =>testlogin(
          onThemeChanged:widget. onThemeChanged,
           isDarkMode:widget. isDarkMode
        
           ),
        //  signuppage(
        //   onThemeChanged: widget.onThemeChanged,
        //   isDarkMode: widget.isDarkMode,
        // ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          var tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeInOut));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration:  BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/app_login.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
