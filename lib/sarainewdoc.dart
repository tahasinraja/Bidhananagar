import 'package:flutter/material.dart';
class sarainewdocpage extends StatefulWidget {
    final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const sarainewdocpage({super.key, required this.onThemeChanged, required this.isDarkMode});

  @override
  State<sarainewdocpage> createState() => _sarainewdocpageState();
}

class _sarainewdocpageState extends State<sarainewdocpage> {
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
            "Nature of Documents in New Case of Sarai",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        
          const SizedBox(height: 12),
        
          /// Numbered List
          buildDocItem(1, "Application Form with stamp"),
          buildDocItem(2, "Photograph of the Sarai"),
          buildDocItem(3, "Trade License u/s 201 of WBMA 1993"),
          buildDocItem(4, "Fire Safety Certificate from Fire Department"),
          buildDocItem(5, "Consent to Operate from of West Bengal Pollution Control Board (WBPCB)"),
          buildDocItem(6, "Income Tax clearance certificate"),
          buildDocItem(7, "GST payment update"),
          buildDocItem(8, "Enrolment of Professional Tax"),
          buildDocItem(9, "Sanctioned Building plan by Municipal Authority"),
          buildDocItem(10, "Site Plan / Layout (Hard Copy and Soft Copy Both)"),
          buildDocItem(11, "Details of security measures including CCTV installation (Hard Copy and Soft Copy Both)"),
          buildDocItem(12, "Installation of C-Form and I-Form software from Technix India"),
          buildDocItem(13, "NOC from land owner in case rented house or Lease Deed"),
          buildDocItem(14, "Electrical System Fitness Certificate"),
          buildDocItem(15, "Police Clearance Certificate (PCC) from Residential Area of Owner of the Sarai"),
          buildDocItem(16, "Declaration of Parking Availability"),
        
          const SizedBox(height: 10),
        
          /// Sub-section
          const Text(
            "17. Declaration Form with stamp paper of Rs 10*: Points are",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        
          const SizedBox(height: 6),
        
          /// Sub points
          buildSubPoint("i", "Whether any part of the building, in which the Sarais situated is use as residence or not? (Yes / No)"),
          buildSubPoint("ii", "Whether the applicant is ready to perform the duties of a Sarai Keeper as prescribed by Sec. 7 of the Sarais Act, 1867?	(Yes)"),
          buildSubPoint("iii", "Whether the applicant is ready to maintain a register of lodgers as in Sec. 5 of the Sarais Act, 1867?     (Yes)"),
          buildSubPoint("iv", "Whether the applicant is ready to produce a certificate of character from a Gazetted Officer or not (Sec 6 of the Act) ?	(Yes)"),
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
        Expanded(child: Text(text,style: TextStyle(),)),
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
        Expanded(child: Text(text,style: TextStyle(fontSize: 14),)),
      ],
    ),
  );
}

}