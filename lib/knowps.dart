import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// 🔹 Extension (class ke bahar hona chahiye)
extension LaunchIt on String {
  Future<void> launchIt({String? scheme}) async {
    final Uri uri = scheme != null
        ? Uri(scheme: scheme, path: this)  // tel/mailto
        : Uri.parse(this);                 // normal URL

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication); // opens dialer / email / browser
    } else {
      throw "❌ Could not launch $uri";
    }
  }
}





class knowpspage extends StatefulWidget {
    final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const knowpspage({super.key,
  
  required this.onThemeChanged,
  required this.isDarkMode,
  });

  @override
  State<knowpspage> createState() => _knowpspageState();
}

class _knowpspageState extends State<knowpspage> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
       backgroundColor:widget. isDarkMode ? Colors.black : Color(0xFFe9e4de),
      
      appBar: AppBar(
         backgroundColor:widget. isDarkMode ? Colors.black : Color(0xFFe9e4de),
        title: Text('All Police Stations',style: TextStyle(color:widget. isDarkMode ? Colors.white : Colors.black ),),
      ),
      body: ListView(
        padding: EdgeInsets.all(w * 0.04),
        children: [
        
          psdetailscard(context, title: 'Airport PS',
           number: '9147889436'
           , mail: 'icairportps@gmail.com',
           mapurl:'https://maps.app.goo.gl/dA4TXeYgP8Bb2DfC6',
            h: h, w: w),

              psdetailscard(context, title: 'Baguiati PS',
           number: '9147889475'
           , mail: ' ocbaguiatips@gmail.com',
           mapurl:'https://maps.app.goo.gl/NDpLMXyzdw4NRivk6',
            h: h, w: w),
          
                psdetailscard(context, title: 'Bidhannagar East PS',
           number: '9147889451'
           , mail: ' icbidhannagareastps@gmail.com',
           mapurl:'https://maps.app.goo.gl/zxj6SasrcnLWL8cRA',
            h: h, w: w),    psdetailscard(context,
             title: 'Bidhannagar North PS',
           number: '9147889485'
           , mail: 'icbidhannagarnorthps@gmail.com',
           mapurl:'https://maps.app.goo.gl/8F6ja1zMoGBV8gJL9',
            h: h, w: w),    psdetailscard(context,
             title: 'Bidhannagar South PS',
           number: '9147889481'
           , mail: ' icbidhannagarsouthps@gmail.com',
           mapurl:'https://maps.app.goo.gl/s5XMj1EDQMh4bs3z8',
            h: h, w: w), 
                psdetailscard(context,
             title: 'Cyber Crime Police',
           number: '9147889474'
           , mail: 'bdncyberps@gmail.com',
           mapurl:'https://www.google.com/maps/dir/2nd+Floor,+ED+market,+Bidhannagar+Cyber+Crime+Police+Station,+Karunamoyee+Housing+Estate,+Samata+Co-Operative+Bank+Building,+Salt+Lake+Bypass,+ED+Block,+Sector+II,+Bidhannagar,+Kolkata,+West+Bengal/2nd+Floor,+ED+market,+Karunamoyee+Housing+Estate,+Samata+Co-Operative+Bank+Building,+Salt+Lake+Bypass,+ED+Block,+Sector+II,+Bidhannagar,+Kolkata,+West+Bengal+700091/@22.5829294,88.3394578,12z/data=!3m1!4b1!4m13!4m12!1m5!1m1!1s0x3a02750bc33b263b:0xfaa4b1e67ceef5f3!2m2!1d88.4218606!2d22.5827919!1m5!1m1!1s0x3a02750bc33b263b:0xfaa4b1e67ceef5f3!2m2!1d88.4218606!2d22.5827919?entry=ttu&g_ep=EgoyMDI1MTAyNi4wIKXMDSoASAFQAw%3D%3D',
            h: h, w: w), 
            
               psdetailscard(context,
             title: 'Electronics Complex PS',
           number: '9147889450'
           , mail: 'icelectronicscomplexps@gmail.com',
           mapurl:'https://maps.app.goo.gl/XGb2eSzLaSn255H96',
            h: h, w: w),    psdetailscard(context,
             title: 'ECO PARK PS',
           number: '9147889509'
           , mail: ' ecoparkpolicestation@gmail.com',
           mapurl:'https://maps.app.goo.gl/EJy686RzNqK84PkdA',
            h: h, w: w),    psdetailscard(context, 
            title: 'Lake Town PS',
           number: '9147889479'
           , mail: ' iclaketownps@gmail.com',
           mapurl:'https://maps.app.goo.gl/mbD2oGEmoA9CFLEH8',
            h: h, w: w),    psdetailscard(context,
             title: 'Narayanpur PS',
           number: '9147889511'
           , mail: ' icnarayanpurps@gmail.com',
           mapurl:'https://maps.app.goo.gl/7CYx3VMxXPNuabjn9',
            h: h, w: w), 
               psdetailscard(context, title: 'New Town PS',
           number: '9147889505'
           , mail: ' ocnewtownps@gmail.com',
           mapurl:'https://maps.app.goo.gl/rfznXD3XSUuFrZoa6',
            h: h, w: w),    psdetailscard(context,
             title: 'NSCBI Airport PS',
           number: '9147889465',
           
           mail:'icnscbips@gmail.com',
           mapurl: 'https://maps.app.goo.gl/AM8f1vDbyQ1wcX949',
            h: h, w: w), 
               psdetailscard(context,
                title: 'Rajarhat PS',
           number: '9147889441'
           , mail: ' rajarhatps@gmail.com',
           mapurl:'https://maps.app.goo.gl/7RQLbqzGLyov2Gjc9',
            h: h, w: w),
            psdetailscard(context, title: 'Techno City PS',
           number: '9147889510'
           , mail: 'technocitypsbdn@gmail.com',
           mapurl:'https://maps.app.goo.gl/Rz8CWb9AhX6XQkEB6',
            h: h, w: w),
              psdetailscard(context, title: 'Women Police Station',
           number: '9147889440'
           , mail: 'womenpsbidhannagar@gmail.com',
           mapurl:'https://maps.app.goo.gl/bH1cZcsXWPboAeTY6',
            h: h, w: w),
            
           
        ],
      ),
    );
  }
}

// 🔹 Police Station Card
Widget psdetailscard(
  BuildContext context, {
  required String title,
  required String number,
  String? landlinenumber,
  required String mail,
  required double h,
  required double w,
  String? weburl,
  String? mapurl, // ✅ direct map url

}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    elevation: 6,
    shadowColor: Colors.blueAccent.withOpacity(0.3),
    color: Colors.grey.shade50,
    margin: EdgeInsets.symmetric(vertical: h * 0.015, horizontal: w * 0.02),
    child: Padding(
      padding: EdgeInsets.all(w * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Title
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: h * 0.028,
              color: Colors.red,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 3,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: h * 0.02),

          // 📧 Email
          GestureDetector(
            onTap: () => mail.launchIt(scheme: 'mailto'),
            child: Row(
              children: [
                const Icon(Icons.email, color: Colors.deepOrange),
                SizedBox(width: w * 0.03),
                Expanded(
                  child: Text(
                    mail,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: h * 0.020,
                      color: Colors.blue.shade700,
                     //decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.018),

          // 📞 Phone
          GestureDetector(
            onTap: () => number.launchIt(scheme: 'tel'),
            child: Row(
              children: [
                const Icon(Icons.phone, color: Colors.green),
                SizedBox(width: w * 0.03),
                Text(
                  number,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: h * 0.020,
                    color: Colors.blue.shade700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),

          // ☎️ Landline
          if (landlinenumber != null) ...[
            SizedBox(height: h * 0.015),
            GestureDetector(
              onTap: () => "tel:$landlinenumber".launchIt(),
              child: Row(
                children: [
                  const Icon(Icons.call, color: Colors.teal),
                  SizedBox(width: w * 0.03),
                  Text(
                    landlinenumber,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: h * 0.020,
                      color: Colors.blue.shade700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // 🌐 Website + 📍 Map
 // 🌐 Website + 📍 Map (Direct URL support)
if (weburl != null || mapurl != null) ...[
  SizedBox(height: h * 0.018),
  Row(
    children: [
      if (weburl != null)
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => weburl.launchIt(), // Website open
            icon: const Icon(Icons.public, color: Colors.white),
            label: const Text("Website",
                style: TextStyle(color: Colors.white)),
          ),
        ),
      if (weburl != null && mapurl != null) SizedBox(width: w * 0.03),
      if (mapurl != null)
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => mapurl.launchIt(), // Direct Google Maps URL
            icon: const Icon(Icons.location_on, color: Colors.white),
            label: const Text(
              "Map",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
    ],
  ),
]

        ],
      ),
    ),
  );
}
