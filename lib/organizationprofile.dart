

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Organizationpage extends StatelessWidget {
    final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const Organizationpage({super.key,
  required this.onThemeChanged,
    required this.isDarkMode,
  });

  // Future<void> _makePhoneCall(String phoneNumber) async {
  //   final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  //   await launchUrl(launchUri);
  // }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
      ? Colors.black
      : const Color(0xFFe9e4de),
        appBar: AppBar(
          title:  Text(
            "Organization Profile",
            style: TextStyle(fontWeight: FontWeight.bold,
             color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white      // Dark Mode
          : Colors.black87,
            ),
          ),
         backgroundColor: Theme.of(context).brightness == Brightness.dark
      ? Colors.black
      : const Color(0xFFe9e4de),
      
          foregroundColor: Colors.white,
        ),
        body:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('The overall administration of the commissionerate is vested in the Commissioner of Police. The various units of Bidhannagar Police working under the general supervision of Commissioner of Police are as follows –',
                 style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16,
                        height: 1.5, 
                      ),textAlign: TextAlign.center,
                ),
              ),
            ),
                ),
                Container(
                  child: Column(
                    children: [
                      _buildExpansionSection(context, title: 'Headquarter Division',
                       h: h, children: [
                 _buildHelplineCard(
  'Jt. Commissioner of Police',
  Department: {
    'ACP, Armed Police': [
      'Reserve Inspector',
    ],

    'ACP, Enforcement Branch': [
      'Officer-in-Charge Enforcement Branch',
    ],

    'ACP, Headquarter': [
      'Inspector Telecom',
      'Court Inspector',
      'Inspector-in-charge Control Room',
    ],
  },
  h: h,
  w: w,
),







   ],
                  ),

                  _buildExpansionSection(context, title: 'Bidhannagar Division',
                       h: h, children: [
                        SizedBox(
                        //  height: 50,
                          width: w*0.99,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.008),
                            child: Card(
                              
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: Text('DCP Bidhannagar',  style: TextStyle(
                                                fontSize: h * 0.020,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.redAccent,
                                              ),textAlign: TextAlign.center,
                                              ),
                                              
                            ),
                          ),
                        ),
// _buildHelplineCard(
//   ' DCP Bidhannagar ',
//   Department: {
//     '': ['' ,''


  

//     ],
    
  
//   },
//   h: h,
//   w: w,
// ),
_buildHelplineCard(
  ' Addl. DCP Bidhannagar',
  Department: {
    'ACP North': ['North PS' ,'East PS', 'Lake Town PS'


  

    ],
    
  
  },
  h: h,
  w: w,
),

]    ),

 //Airport
    _buildExpansionSection(context, title: 'DCP Bidhannagar',
                       h: h, children: [


_buildHelplineCard(
  'DCP Airport',
  Department: {
    'ACP Airport': [
      'IC Airport PS',
      'IC NSCBI Airport PS',
      'IC Baguiati PS',
    ],
  },
  h: h,
  w: w,
),

]    ),
 //new town
    _buildExpansionSection(context, title: 'DCP Bidhannagar',
                       h: h, children: [

//newtown
_buildHelplineCard(
  'DCP New Town',
  Department: {
    'ACP New Town': [
      'IC New Town PS',
      'IC Techno City PS',
      'IC Eco Park PS',
    ],
    'ACP Rajarhat': [
      'IC Rajarhat PS',
      'IC Narayanpur PS',
    ],
  },
  h: h,
  w: w,
),
]    ),              
 //DD   
      _buildExpansionSection(context, title: 'DCP Bidhannagar',
                       h: h, children: [

// dd
_buildHelplineCard(
  'DCP DD',
  Department: {
    'ADCP DD': [],
    'ACP DD I': [
      'Insp DD',
      'OC Women PS',
    ],
    'ACP DD II': [
      'IC Cyber Crime PS',
    ],
  },
  h: h,
  w: w,
),
]    ),           
           
  //sb
    _buildExpansionSection(context, title: 'DCP Bidhannagar',
                       h: h, children: [

//sb
_buildHelplineCard(
  'ADCP SB',
  Department: {
    'ACP SB': [
      'Insp SB',
    ],
  },
  h: h,
  w: w,
),

]    ),    
//traffic         
      _buildExpansionSection(context, title: 'DCP Bidhannagar',
                       h: h, children: [

// traffic 
_buildHelplineCard(
  'DCP Traffic',
  Department: {
    'ACP Traffic I': [
      'TI Bidhannagar',
      'TI Nabadiganta',
      'TI New Town',
      'TI Rajarhat',
   
    ],
    'ACP Traffic II': [
      'TI Airport',
      'TI Baguiati (Addl. charge of TI HQ)',
      'TI Lake Town',
      'TI Narayanpur',
      'OC Kaikhali STG',
      'OC NSCBI Airport STG',
    ],
  },
  h: h,
  w: w,
),

]    ),        
              ],
                
              
            ),
          ),
              ]
                    
            )
        
      ),
      ),
    )

    );                     
                          
                    
                        
      
                          
                        
                     
                    
        
     
    
  }

  /// Expansion Section
/// ------------------------------
/// MAIN EXPANSION SECTION
/// ------------------------------
Widget _buildExpansionSection(
  BuildContext context, {
  required String title,
  required double h,
  required List<Widget> children,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Card(
    color: isDark ? Colors.grey[900] : Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 3,
    margin: EdgeInsets.symmetric(vertical: h * 0.01),
    child: ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      iconColor: Colors.redAccent,
      collapsedIconColor: isDark ? Colors.white70 : Colors.grey,
      childrenPadding: const EdgeInsets.only(bottom: 12),
      title: Text(
        title,
        style: TextStyle(
          fontSize: h * 0.022,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      children: children,
    ),
  );
}

/// ------------------------------
/// HELPLINE CARD
/// ------------------------------
Widget _buildHelplineCard(
  String title, {
  required Map<String, List<String>> Department,
  List<String>? emails,
  required double h,
  required double w,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.008),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(w * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: h * 0.020,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const Divider(),

            /// LOOP through MAP
            for (var entry in Department.entries)
              _buildNumberRow(
                entry.key,      // ← main head (ACP, Armed Police)
                h,
                w,
                extraNumbers: entry.value, // ← inner list
              ),

            if (emails != null && emails.isNotEmpty) ...[
              const Divider(),
              for (var email in emails) _buildEmailRow(email, h, w),
            ],
          ],
        ),
      ),
    ),
  );
}


/// ------------------------------
/// OUTER NUMBER ROW with INNER EXPANSION
/// ------------------------------
Widget _buildNumberRow(
  String number,
  double h,
  double w, {
  List<String>? extraNumbers, // optional inner expansion list
}) {
  return Padding(
    padding: EdgeInsets.only(top: h * 0.006),
    child: ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.only(left: w * 0.05),

      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(w * 0.02),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.person_2_outlined, color: Colors.green),
          ),
          SizedBox(width: w * 0.03),
          Text(
            number,
            style: TextStyle(
              fontSize: h * 0.020,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),

      /// Inner expansion content
      children: extraNumbers != null
          ? extraNumbers
              .map((e) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: _buildInnerNumber(e, h, w),
                  ))
              .toList()
          : [],
    ),
  );
}

/// ------------------------------
/// INNER NUMBER ITEM (expanded)
/// ------------------------------
Widget _buildInnerNumber(String number, double h, double w) {
  return GestureDetector(
    onTap: () {
      // call action
    },
 child: Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Icon(
      Icons.keyboard_arrow_right,
      size: h * 0.022,
      color: Colors.grey,
    ),
 
   // SizedBox(width: w * 0.02),
 
    Expanded(
      child: Text(
        number,
        style: TextStyle(
          fontSize: h * 0.018,
          color: isDarkMode ? Colors.white70 : Colors.black87,
        ),
        textAlign: TextAlign.left,
      ),
    ),
  ],
 ),


  );
}

/// ------------------------------
/// SIMPLE EMAIL ROW
/// ------------------------------
Widget _buildEmailRow(String email, double h, double w) {
  return Padding(
    padding: EdgeInsets.only(top: h * 0.006),
    child: Row(
      children: [
        Icon(Icons.email, color: Colors.redAccent, size: h * 0.024),
        SizedBox(width: w * 0.03),
        Text(
          email,
          style: TextStyle(
            fontSize: h * 0.020,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ],
    ),
  );
}


  /// Number Row with call action
//   Widget _buildNumberRow(String number, double h, double w) {
//     return GestureDetector(
//       onTap: () async {
//         // final Uri launchUri = Uri(scheme: 'tel', path: number);
//         // await launchUrl(launchUri);
//       },
//       child: Padding(
//         padding: EdgeInsets.only(top: h * 0.006),
//         child: Row(
//           children: [
//             Container(
//               padding: EdgeInsets.all(w * 0.02),
//               decoration: BoxDecoration(
//                 color: Colors.green.shade100,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(Icons.phone, color: Colors.green),
//             ),
//             SizedBox(width: w * 0.03),
//             Text(
//               number,
//               style: TextStyle(
//                 fontSize: h * 0.020,
//                  color:isDarkMode ? Colors.white : Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   Widget _buildEmailRow(String email, double h, double w) {
//   return GestureDetector(
//     onTap: () async {
//       final Uri emailUri = Uri(
//         scheme: 'mailto',
//         path: email,
//       );
//       await launchUrl(emailUri);
//     },
//     child: Padding(
//       padding: EdgeInsets.only(top: h * 0.006),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(w * 0.02),
//             decoration: BoxDecoration(
//               color: Colors.blue.shade100,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Icon(Icons.email, color: Colors.blue),
//           ),
//           SizedBox(width: w * 0.03),
//           Text(
//             email,
//         overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontSize: h * 0.020,
//               color: isDarkMode ? Colors.white : Colors.black,
             
           
              
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

}
