import 'package:flutter/material.dart';
class saraiolddocpage extends StatefulWidget {
    final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const saraiolddocpage({super.key, required this.onThemeChanged, required this.isDarkMode});

  @override
  State<saraiolddocpage> createState() => _saraiolddocpageState();
}

class _saraiolddocpageState extends State<saraiolddocpage> {
  @override
  Widget build(BuildContext context) {
     final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
backgroundColor: isDark ? Colors.black : const Color(0xFFe9e4de),
      body: SingleChildScrollView(
        child: Padding(padding: 
        EdgeInsets.all(12),
        child: Column(
       
          children: [
            SizedBox(height: MediaQuery.of( context).size.height * 0.3),
           Card(
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                     elevation: 3,
                     margin: const EdgeInsets.symmetric(vertical: 12),
                     child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                   
                     /// Heading
                     const Text(
            "Nature of Documents in Renewal of Sarai ",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
                     ),
                   
                     const SizedBox(height: 12),
                   
                     /// Numbered List
                     buildDocItem(1, "Income Tax Clearance Certificate"),
                     buildDocItem(2, "Trade License u/s 201 of WBMA 1993"),
                     buildDocItem(3, "Consent to Operate from of West  Bengal Pollution Control Board (WBPCB)"),
                     buildDocItem(4, "Fire Safety Certificate from Fire Department"),
                     buildDocItem(5, "GST payment update"),
                 
                     const SizedBox(height: 6),
                   
               
                   ],
            ),
                     ),
                   )
        
          ],
        ),
        
        ),
      ),
    );
  }
  Widget buildDocItem(int number, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$number. ",
            style: const TextStyle(fontWeight: FontWeight.w600)),
        Expanded(child: Text(text,style: TextStyle(fontSize: 14))),
      ],
    ),
  );
}

Widget buildSubPoint(String no, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$no) ",
            style: const TextStyle(fontWeight: FontWeight.w600)),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

}