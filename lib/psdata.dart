import 'package:flutter/material.dart';
class psdata extends StatefulWidget {
  const psdata({super.key});

  @override
  State<psdata> createState() => _psdataState();
}

class _psdataState extends State<psdata> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
  onTap: () {
    double lat = 22.5867;
    double lng = 88.4173;
    "geo:$lat,$lng".launchIt(); // Direct Google Maps open
  },
  child: Row(
    children: const [
      Icon(Icons.location_on, color: Colors.red),
      SizedBox(width: 8),
      Text(
        "View on Map",
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    ],
  ),
),

      ),
    );
  }
}

extension on String {
  void launchIt() {}
}