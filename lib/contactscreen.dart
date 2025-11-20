
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class contactscreen extends StatelessWidget {
    final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const contactscreen({super.key,
  required this.onThemeChanged,
    required this.isDarkMode,
  });

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
     backgroundColor: Theme.of(context).brightness == Brightness.dark
    ? Colors.black
    : const Color(0xFFe9e4de),

      appBar: AppBar(
        title:  Text(
          "Important Contacts",
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
      body: ListView(
        padding: EdgeInsets.all(w * 0.04),
        children: [
          _buildExpansionSection(
            context,
            title: "📍 Bidhannagar Control Room",
            h: h,
            children: [
              _buildHelplineCard("📞 Control Room (24x7)",
                  numbers: ["03323358788", "03323410465", "9147889470"], h: h, w: w),
              _buildHelplineCard("🚦 Traffic Control Room",
                  numbers: ["9051213100", "6291606161"], h: h, w: w),
              _buildHelplineCard("📞 Special Branch Control Room",
                  numbers: ["033-23343080"], h: h, w: w),
            ],
          ),
          _buildExpansionSection(
            context,
            title: "👮 Police Stations",
            h: h,
            children: [
              _buildHelplineCard("Airport PS",
                  numbers: ["9147889436", 
                  
                  ],
                 // emails: ["icairportps@gmail.com"],
                 emails: ['psairport@policewb.gov.in'],
                   h: h, w: w),
              _buildHelplineCard("Baguiati PS",
                  numbers: ["9147889475",],
//emails: ["ocbaguiatips@gmail.com"],
emails: ['psbaguiati@policewb.gov.in'],
                   h: h, w: w),
              _buildHelplineCard("Bidhannagar East PS",
                  numbers: ["9147889451", ],
               //   emails: ["icbidhannagareastps\n@gmail.com"],
               emails: ['psbdneast@policewb.gov.in'],
                   h: h, w: w),
              _buildHelplineCard("Bidhannagar North PS",
                  numbers: ["9147889485", ],
                 // emails: ["icbidhannagarnorthps\n@gmail.com"],
                 emails: ['psbdnnorth@mail.\nwbpolice.gov.in'],
                  
                   h: h, w: w),
                       _buildHelplineCard("Bidhannagar South PS",
                  numbers: ["9147889481  ", ],
               //   emails: ["icbidhannagarsouthps\n@gmail.com"],
               emails: ['psbdnsouth@police.gov.in'],
                   h: h, w: w),
              _buildHelplineCard("Cyber Crime PS",
                  numbers: ["9147889474", ],
                //  emails: ["bdncyberps@gmail.com"],
                emails: ['pscybercrime_bdn@mail.\nwbpolice.gov.in'],
                   h: h, w: w),

                  
             
         
              _buildHelplineCard("Electronics Complex PS",
                  numbers: ["9147889450", ],
               //   emails: ["icelectronicscomplexps\n@gmail.com"],
               emails: ['psecomplex@policewb.gov.in'],
                   h: h, w: w),
                     _buildHelplineCard("Eco Park PS",
                  numbers: ["9147889509", ],
                //  emails: ["ecoparkpolicestation\n@gmail.com"],
                emails: ['psecopark_bdn@mail.\nwbpolice.gov.in'],
                   h: h, w: w),

              _buildHelplineCard("Lake Town PS",
                  numbers: ["9147889479", ],
                //  emails: ["iclaketownps@gmail.com"],
                emails: ['pslaketown@policewb.gov.in'],
                   h: h, w: w),
                    
              _buildHelplineCard("Narayanpur PS",
                  numbers: ["9147889511", ],
                 // emails: ["icnarayanpurps@gmail.com"],
                 emails: ['psnarayanpur@mail.\nwbpolice.gov.in'],
                   h: h, w: w),
                   
              _buildHelplineCard("New Town PS",
                  numbers: ["9147889505", ],
                //  emails: ["ocnewtownps@gmail.com"],
                emails: ['psnewtown@policewb.gov.in'],
                   h: h, w: w),

                 
                   _buildHelplineCard("NSCBI Airport PS",
                  numbers: [ "9147889465"],
                //  emails: ["icnscbips@gmail.com"],
                emails: ['psnscbi@policewb.gov.in'],
                   h: h, w: w),
           
              _buildHelplineCard("Rajarhat PS",
                  numbers: ["9147889441", ],
                //  emails: ["rajarhatps@gmail.com"],
                emails: ['psrajarhat@policewb.gov.in'],
                   h: h, w: w),
                  _buildHelplineCard("Technocity PS",
                  numbers: ["9147889510", ],
                //  emails: ['technocitypsbdn@gmail.com'],
                emails: ['pstechnocity_bdn@mail.\nwbpolice.gov.in'],
                   h: h, w: w),

                  //  _buildHelplineCard("Cyber-Crime PS",
                  // numbers: ["9073343341", "23595589 "], h: h, w: w),

                   _buildHelplineCard("Women PS",
                  numbers: ["9147889440"],
                 // emails: ["womenpsbidhannagar\n@gmail.com"],
                 emails: ['womenps_bdn@mail.\nwbpolice.gov.in'],
                   h: h, w: w),
            ],
          ),

          // _buildExpansionSection(
          //   context,
          //   title: "🚨 Emergency Helpline",
          //   h: h,
          //   children: [
          //     _buildHelplineCard("🚒 Fire Brigade Helpline", numbers: ["101"], h: h, w: w),
          //     _buildHelplineCard("🚑 Ambulance Services", numbers: ["102"], h: h, w: w),
          //     _buildHelplineCard("📞 Cyber Crime", numbers: ["1930"], h: h, w: w),
          //     _buildHelplineCard("👩‍🦰 Women’s Helpline", numbers: ["1091"], h: h, w: w),
          //     _buildHelplineCard("👶 Child Helpline", numbers: ["1098"], h: h, w: w),
          //     _buildHelplineCard("📞 Disaster Management", numbers: ["1078"], h: h, w: w),
          //     _buildHelplineCard("📞 Railway Enquiry", numbers: ["139"], h: h, w: w),
          //   ],
          // ),
             _buildExpansionSection(
            context,
            title: "👮‍♂️ Senior Police Officers",
            h: h,
            children: [
          //     _buildHelplineCard("Commissioner of Police, Bidhannagar", numbers: ["9147889490"],
          //     emails: ["cpbidhannagar@gmail.com"], h: h, w: w),
          //     _buildHelplineCard("Jt. Commissioner of Police (HQ), Bidhannagar", numbers: ["9147889469"],
          //     h: h, w: w),
          //     _buildHelplineCard("DCP DD, BDN", numbers: ["9147889488"],
          //     emails: ["dcddbdnpc@gmail.com"], h: h, w: w),
          //     _buildHelplineCard("DCP BDN", numbers: ["9147889489"],
          //     emails: ["adcpbdn@gmail.com"], h: h, w: w),
          //     _buildHelplineCard("DCP Airport Division", numbers: ["9147889483"],
          // h: h, w: w),
              
          //     _buildHelplineCard("DCP New TOWN", numbers: ["9147889506"],
          //     h: h, w: w),
          //     _buildHelplineCard("Addl. Charge of ADCP SB", numbers: ["9147889468"],
          //      h: h, w: w),

               _buildHelplineCard("Additional Deputy Commissioner of Police, Bidhannagar Division", numbers: ["9147889458"],
               emails: ["adcpbdnpc@gmail.com"],
               h: h, w: w),
              _buildHelplineCard("Additional Deputy Commissioner of Police, Detective Department", numbers: ["9147889507"],
              emails: ["adcpdd.bdn@gmail.com"],
               h: h, w: w),
                _buildHelplineCard("Assistant Commissioner of Police, Airport Zone", numbers: ["9147889482"],
              emails: ["acpaptz2@gmail.com"], h: h, w: w),
              // _buildHelplineCard("COF, BDNPC", numbers: ["9147889480"],
              // h: h, w: w),
                _buildHelplineCard("Assistant Commissioner of Police, New Town Zone", numbers: ["9147889487"],
              emails: ["acpnewtownbdnpc\n@gmail.com"], h: h, w: w),
                 _buildHelplineCard("Assistant Commissioner of Police, North Zone", numbers: ["9147889438"],
              emails: ['acpbdn@gmail.com'],
             h: h, w: w),
                _buildHelplineCard("Assistant Commissioner of Police, Rajarhat Zone", numbers: ["9147889508"],
              emails: ["acprajarhat@gmail.com"], h: h, w: w),
              _buildHelplineCard("Assistant Commissioner of Police, South Zone", numbers: ["9147889456",],
              emails: ["acpbdnz1@gmail.com"], h: h, w: w),
                //  _buildHelplineCard("Assistant Commissioner of Police, Armed Police", numbers: ["9147889443"],
                //      emails: ["acpapbidhannagar\n@gmail.com"], 
                //    h: h, w: w),
                     _buildHelplineCard("Assistant Commissioner of Police, Detective Department", numbers: ["9147889466" ],
              emails: ["acpdd.bdnpc@gmail.com"], h: h, w: w),


                _buildHelplineCard("Assistant Commissioner of Police, Cyber", numbers: ["9147889466" ],
              emails: ["acpdd2bdn@policewb.gov.in"], h: h, w: w),

                   _buildHelplineCard("Assistant Commissioner of Police, Enforcement Branch", numbers: ["9147889459" ],
              emails: ["acpebbdnpc@gmail.com"], h: h, w: w),

              
              _buildHelplineCard("Assistant Commissioner of Police, Headquarter", numbers: ["9147889457"], 
              emails: ["acphqbdnpc2019@gmail.com"],h: h, w: w),

                _buildHelplineCard("Assistant Commissioner of Police, Special Branch",
                 numbers: ["9147171382" ],
              emails: ["dcsbcontrol@gmail.com"], h: h, w: w),
            
             
           
                  

            //   _buildHelplineCard("Additional charge of ACP Cyber", numbers: ["9147889459"],
            // h: h, w: w),
                _buildHelplineCard("Assistant Commissioner of Police - I, Traffic", numbers: ["9147889443"],
              emails: ["acptraffic1bdn@gmail.com"], h: h, w: w),

              _buildHelplineCard("Assistant Commissioner of Police - II, Traffic", numbers: ["9147889486"],
              emails: ["acptraffic1bdn@gmail.com"], h: h, w: w),
           
              
              
            

          

     //           _buildHelplineCard("IC North PS", numbers: ["9147889485"],
    //             emails: ["icbidhannagarnorthps\n@gmail.com"], h: h, w: w),
    // _buildHelplineCard("IC South PS", numbers: ["9147889481"],
    // emails: ["icbidhannagarsouthps\n@gmail.com"], h: h, w: w),
    // _buildHelplineCard("IC East PS", numbers: ["9147889451"],
    // emails: ["icbidhannagareastps\n@gmail.com"], h: h, w: w),
    // _buildHelplineCard("IC Electronics Complex PS", numbers: ["9147889450"],
    // emails: ["icelectronicscomplexps\n@gmail.com"], h: h, w: w),
    // _buildHelplineCard("IC Lake Town PS", numbers: ["9147889479"],
    // emails: ["iclaketownps@gmail.com"], h: h, w: w),
    // _buildHelplineCard("IC Baguiati PS", numbers: ["9147889475"],
    // emails: ["ocbaguiatips@gmail.com"], h: h, w: w),
    // _buildHelplineCard("IC Airport PS", numbers: ["9147889436"],
    // emails: ["icairportps@gmail.com"], h: h, w: w),
    // _buildHelplineCard("IC New Town PS", numbers: ["9147889505"],
    // emails: ["ocnewtownps@gmail.com"], h: h, w: w),
    // _buildHelplineCard("IC NSCBI PS", numbers: ["9147889465"],
    // emails: ["icnscbips@gmail.com"], h: h, w: w),
    // _buildHelplineCard("IC Rajarhat PS", numbers: ["9147889441"],
    // emails: ["rajarhatps@gmail.com"], h: h, w: w),
    // _buildHelplineCard("IC Narayanpur PS", numbers: ["9147889511"],
    // emails: ["icnarayanpurps@gmail.com"], h: h, w: w),
    // _buildHelplineCard("IC Technocity PS", numbers: ["9147889510"],
    // emails: ["technocitypsbdn@gmail.com"], h: h, w: w),
    // _buildHelplineCard("IC Cyber PS", numbers: ["9147889474"],
    // emails: ["bdncyberps@gmail.com"], h: h, w: w),
    // _buildHelplineCard("IC Eco Park PS", numbers: ["9147889509"],
    // emails: ["icecoparkpolicestation\n@gmail.com"], h: h, w: w),
    // _buildHelplineCard("O/C BDN Women PS", numbers: ["9147889440"],
    // emails: ["Womenpsbidhannagar\n@gmail.com"], h: h, w: w),
    // _buildHelplineCard("TI Bidhannagar", numbers: ["9147889461"],
    // emails: ["bdntraffic@gmail.com"], h: h, w: w),
    // _buildHelplineCard("TI Airport", numbers: ["9147889435"],
    // emails: ["tiairporttgbdn@gmail.com"], h: h, w: w),
    // _buildHelplineCard("TI Rajarhat", numbers: ["9147889463"],
    // emails: ["tirajarhat.tg@gmail.com"], h: h, w: w),
    // _buildHelplineCard("TI Lake Town", numbers: ["9147889476"],
    // emails: ["lkttrafficlkt@gmail.com"], h: h, w: w),
    // _buildHelplineCard("TI New Town", numbers: ["9147889462"],
    // emails: ["newtowntraffic2012\n@gmail.com"], h: h, w: w),
    // _buildHelplineCard("TI Baguiati", numbers: ["9147889446"],
    // emails: ["baguihatitg@gmail.com"], h: h, w: w),
    // _buildHelplineCard("TI Nabadiganta", numbers: ["9147889472"],
    // emails: ["nabadigantatraffic\n@gmail.com"], h: h, w: w),
    // _buildHelplineCard("OC Narayanpur TG", numbers: ["9147889473"],
    // emails: ["narayanpurtgbdn\n@gmail.com"], h: h, w: w),
    // _buildHelplineCard("Additional charge TI HQ", numbers: ["9147889448"],
    // emails: ["tihgbdnpc@gmail.com"], h: h, w: w),
    // _buildHelplineCard("RI Bidhannagar", numbers: ["9147889445"],
    // emails: ["ri-bdn@policewb.gov.in"], h: h, w: w),
    // _buildHelplineCard("RO Bidhannagar", numbers: ["9147889455"], 
    // emails: ["roi-bdn@policewb.gov.in"],h: h, w: w),
    // _buildHelplineCard("Insp. of DD BDN PC", numbers: ["9147889460"],
    // emails: ["insprdd1-bdn@policewb.gov.in"], h: h, w: w),
    // _buildHelplineCard("Insp. (HQ) & OC License", numbers: ["9147889464"],
    // emails: ["oc.licensebdn@policewb.gov.in"], h: h, w: w),
    // _buildHelplineCard("MTO BDNPC", numbers: ["9147889471"],
    // emails: ["mtobdnpc@gmail.com"], h: h, w: w),
    // _buildHelplineCard("Court Inspector, BDNPC", numbers: ["9147889449"],
  
    //  h: h, w: w),
    // _buildHelplineCard(
    //     "OC Computer Cell and Social Media Monitoring Cell, BDNPC",
    //     numbers: ["9147890644"],
    //    emails: ["occomputercellbdnpc\n@gmail.com"],
    //     h: h,
    //     w: w),
            ],
          ),
       
        ],
      ),
    );
  }

  /// Expansion Section
Widget _buildExpansionSection(BuildContext context,
    {required String title, required double h, required List<Widget> children}) {
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


  /// Helpline Card inside expansion
Widget _buildHelplineCard(
  String title, {
  required List<String> numbers,
  List<String>? emails, // <-- optional email parameter
  required double h,
  required double w,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.008),
    child: Card(
     // color: isDarkMode ? Colors.black : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(w * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: h * 0.020,
                fontWeight: FontWeight.w600,
                color: Colors.redAccent,
              ),
            ),
            const Divider(),
            // 📞 Phone numbers list
            for (var number in numbers) _buildNumberRow(number, h, w),

            // 📧 Emails list (if any)
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

  /// Number Row with call action
  Widget _buildNumberRow(String number, double h, double w) {
    return GestureDetector(
      onTap: () async {
        final Uri launchUri = Uri(scheme: 'tel', path: number);
        await launchUrl(launchUri);
      },
      child: Padding(
        padding: EdgeInsets.only(top: h * 0.006),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(w * 0.02),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.phone, color: Colors.green),
            ),
            SizedBox(width: w * 0.03),
            Text(
              number,
              style: TextStyle(
                fontSize: h * 0.020,
                 color:isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildEmailRow(String email, double h, double w) {
  return GestureDetector(
    onTap: () async {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
      );
      await launchUrl(emailUri);
    },
    child: Padding(
      padding: EdgeInsets.only(top: h * 0.006),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(w * 0.02),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.email, color: Colors.blue),
          ),
          SizedBox(width: w * 0.03),
          Text(
            email,
        overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: h * 0.020,
              color: isDarkMode ? Colors.white : Colors.black,
             
           
              
            ),
          ),
        ],
      ),
    ),
  );
}

}
