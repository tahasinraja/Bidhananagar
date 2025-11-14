import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
   final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const HistoryPage({super.key,
  

  required this.onThemeChanged,
  required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: isDarkMode ? Colors.black : Color(0xFFe9e4de),
      appBar: AppBar(
        
       // title: const Text("History"),
         backgroundColor: isDarkMode ? Colors.black : Color(0xFFe9e4de),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "📜 History of Bidhannagar Police",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),

            Text(
              "• Shri Mukesh, IPS is the current Commissioner of the "
              "Bidhannagar Police Commissionerate.\n"
              "• Bidhannagar Police, established on 20 January 2012, "
              "is a police force with primary responsibilities in law enforcement "
              "and investigation within Bidhannagar Municipal Corporation and "
              "certain adjacent areas in Greater Kolkata (Salt Lake, Lake Town, "
              "Kestopur, Baguiati, Raghunathpur, Teghoria, Arjunpur, Kaikhali, "
              "Rajarhat, New Town, Dumdum/Kolkata Airport Area, Inside of NSCBI "
              "Airport, Gouripur, Michael Nagar, Ganganagar).\n\n"
              "• Vision: To ensure law enforcement, crime prevention, traffic "
              "management, public safety, and community service across "
              "Bidhannagar and adjoining areas, maintaining peace, security, "
              "and effective policing for citizens.\n\n"
              "• Headquarters: Gate No. 3, Salt Lake Stadium Rd, JB Block, "
              "Sector 3, Bidhannagar, Kolkata, West Bengal 700106\n\n"
              "• Contact Us: 033-23358788",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
