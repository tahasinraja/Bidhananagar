import 'package:bidhannagarpoliceapp/homepage.dart';
import 'package:flutter/material.dart';
class parkingscreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
final bool isDarkMode;
  const parkingscreen({super.key,
   required this.onThemeChanged,
  required this.isDarkMode,
  });

  @override
  State<parkingscreen> createState() => _parkingscreenState();
}

class _parkingscreenState extends State<parkingscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => homepage(onThemeChanged:widget. onThemeChanged, isDarkMode:widget.isDarkMode),));
        }, child: Text('Coming soon.. Click here to Back')
        
        )
      ),
    );
  }
}