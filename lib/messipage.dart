import 'package:flutter/material.dart';
class Messipage extends StatefulWidget {
   final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const Messipage({super.key, required this.onThemeChanged, required this.isDarkMode});

  @override
  State<Messipage> createState() => _MessipageState();
}

class _MessipageState extends State<Messipage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   backgroundColor:      Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : const Color(0xFF5c717d),
      body: SizedBox.expand(child: Image.asset('assets/images/messiimg.jpg',fit: BoxFit.cover,)),
    );
  }
}