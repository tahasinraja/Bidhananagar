import 'package:bidhannagarpoliceapp/knowps.dart';
import 'package:flutter/material.dart';



class TrafficContactsPage extends StatelessWidget {
    final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const TrafficContactsPage({super.key,
  

  required this.onThemeChanged,
  required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
       backgroundColor:isDarkMode ? Colors.black : Color(0xFFe9e4de),
      appBar: AppBar(
         backgroundColor:isDarkMode ? Colors.black : Color(0xFFe9e4de),
        title: const Text("Traffic Guard Offices"),
 
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟢 Zone I
            Text(
              "Zone I",
              style: TextStyle(
                fontSize: h * 0.028,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: h * 0.015),

            psdetailscard(
              context,
              title: "Office of the DCP (Traffic)",
              number: "2324-1073",
              mail: "dctrafficbdn@gmail.com",
              h: h,
              w: w,
              mapurl:
                  "https://maps.google.com/maps?cid=8444730777834325007",
            ),
            psdetailscard(
              context,
              title: "Office of the ACP (Traffic-I)",
              number: "2367-0063",
              mail: "acptraffic2bdn@gmail.com",
              h: h,
              w: w,
              mapurl:
                  "https://maps.google.com/maps?cid=8460894588741293578",
            ),
            psdetailscard(
              context,
              title: "Office of the TI Bidhannagar TG",
              number: "8583933445",
              mail: "bidhannagartraffic@gmail.com",
              h: h,
              w: w,
              mapurl:
                  "https://maps.app.goo.gl/QHZct3BCYGvwQtUX8.",),
            psdetailscard(
              context,
              title: "Office of the TI Nabadiganta TG",
              number: "9062018399",
              mail: "nabadigantatraffic@gmail.com",
              h: h,
              w: w,
              mapurl:
                  "https://maps.google.com/maps?cid=8042765525035391524",
            ),
            psdetailscard(
              context,
              title: "Office of the TI New Town TG",
              number: "2324-6088",
              mail: "newtowntraffic2012@gmail.com",
              h: h,
              w: w,
              mapurl:
                  "https://maps.app.goo.gl/FKzkMKdT6JDKjvUNA",),
            psdetailscard(
              context,
              title: "Office of the Eco Park STG",
              number: "6291781544",
              mail: "ecoparkstg@gmail.com",
              h: h,
              w: w,
              mapurl:
                  "https://maps.app.goo.gl/YMrfPd2wcS6wSBmDA",),
            psdetailscard(
              context,
              title: "Office of the Rajarhat TG",
              number: "9874477734",
              mail: "tirajarhat.tg@gmail.com",
              h: h,
              w: w,
              mapurl:
                  "https://maps.app.goo.gl/PG3JeuDmvFfoW78m6",),

            SizedBox(height: h * 0.04),

            // 🔵 Zone II
            Text(
              "Zone II",
              style: TextStyle(
                fontSize: h * 0.028,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: h * 0.015),

            psdetailscard(
              context,
              title: "Office of the ACP (Traffic-II)",
              number: "8945535071",
              mail: "acptraffic1bdn@gmail.com",
              h: h,
              w: w,
              mapurl:
                  "https://maps.google.com/maps?cid=2979802119739665409",
            ),
            psdetailscard(
              context,
              title: "Office of the Baguiati TG",
              number: "2591-0061",
              mail: "baguiatitg@gmail.com",
              h: h,
              w: w,
              mapurl:
                  "https://maps.google.com/maps?cid=3649071845517150121",
            ),
            psdetailscard(
              context,
              title: "Office of the Lake Town TG",
              number: "25212262",
              mail: "lkttrafficlkt@gmail.com",
              h: h,
              w: w,
              mapurl:
                  "https://maps.google.com/maps?cid=16727257990037349714",
            ),
            psdetailscard(
              context,
              title: "Office of the Airport TG",
              number: "8910782826",
              mail: "tiairporttgbdn@gmail.com",
              h: h,
              w: w,
              mapurl:
                  "https://maps.google.com/maps?cid=5687738206537428680",
            ),
            psdetailscard(
              context,
              title: "Office of the Kaikhali STG",
              number: "9123370452",
              mail: "kaikhalitgbdn@gmail.com",
              h: h,
              w: w,
              mapurl:
                  "https://maps.google.com/maps?cid=10140332630769892779",
            ),
            psdetailscard(
              context,
              title: "Office of the NSCBI STG",
              number: "9051418134",
              mail: "tinscbiairporttgbdn@gmail.com",
              h: h,
              w: w,
              mapurl:
                  "https://maps.app.goo.gl/RkgauRCXsxRWcuvf7",
            ),
            psdetailscard(
              context,
              title: "Office of the Narayanpur TG",
              number: "9051122860",
              mail: "narayanpurtgbdn@gmail.com",
              h: h,
              w: w,
              mapurl:
                  "https://maps.app.goo.gl/2YG29EvpZSigbr5e6",
            ),
          ],
        ),
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
              fontSize: h * 0.025,
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
                      decoration: TextDecoration.underline,
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
                   // decoration: TextDecoration.underline,
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
                      //decoration: TextDecoration.underline,
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
                      label: const Text(
                        "Website",
                        style: TextStyle(color: Colors.white),
                      ),
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
                      onPressed:
                          () => mapurl.launchIt(), // Direct Google Maps URL
                      icon: const Icon(Icons.location_on, color: Colors.white),
                      label: const Text(
                        "Map",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    ),
  );
}
