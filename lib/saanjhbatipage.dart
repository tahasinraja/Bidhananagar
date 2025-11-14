import 'package:bidhannagarpoliceapp/tenantregistration.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SaanjhBatiPage extends StatefulWidget {
  const SaanjhBatiPage({super.key});

  @override
  State<SaanjhBatiPage> createState() => _SaanjhBatiPageState();
}

class _SaanjhBatiPageState extends State<SaanjhBatiPage> {
  final Uri saanjbaatihelp = Uri(scheme: 'tel', path: '9748898933');

  Future<void> sanjbaticont() async {
    if (await canLaunchUrl(saanjbaatihelp)) {
      await launchUrl(saanjbaatihelp);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch phone app")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor:Color(0xFFe9e4de), 
    
      body: SingleChildScrollView(
        
        padding: const EdgeInsets.only(left: 16,right: 16,top: 45),

        child: Column(
          children: [
            // Card for description
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              shadowColor: Colors.blueAccent.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('WELCOME TO',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                    Text('SAANJ BAATI',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                    SizedBox(height: 15,),
                    Text(
                      'An initiative of Bidhannagar Police for elderly citizens',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Since its initial days, Salt Lake City, or Bidhannagar, has had a significant population of senior citizens who live alone. '
                      'And, to reach out to these people - for not only their safety and security, but also to take care of their health and happiness - '
                      'the Bidhannagar City Police, along with OFFER, a non-profit organisation, came up with Saanjhbaati, '
                      'a community policing project for elderly persons living alone in this jurisdiction.',
                      style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
 SizedBox(height: 20,),
               ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => docsdownviewpage(
                              filePath: 'assets/images/SAANJI BAATI.pdf',
                              title: 'SAANJ BAATI',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.app_registration),
                      label: const Text('Registration Form',style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                   SizedBox(height: 20,),
                        ElevatedButton.icon(
                      onPressed: sanjbaticont,
                      icon: const Icon(Icons.contact_phone),
                      label: const Text('Emergency Contact',style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

           
         
          ],
        ),
      ),
    );
  }
}
