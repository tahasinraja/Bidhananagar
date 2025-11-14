import 'package:bidhannagarpoliceapp/homepage.dart';
import 'package:flutter/material.dart';

class comingsoon extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const comingsoon({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<comingsoon> createState() => _comingsoonState();
}

class _comingsoonState extends State<comingsoon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe9e4de),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => homepage(
                      onThemeChanged: widget.onThemeChanged,
                      isDarkMode: widget.isDarkMode,
                    ),
              ),
            );
          },
          child: Text('Coming soon'),
        ),
      ),
    );
  }
}
