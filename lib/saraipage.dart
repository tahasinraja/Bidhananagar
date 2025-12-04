import 'package:bidhannagarpoliceapp/sarainewpage.dart';
import 'package:bidhannagarpoliceapp/saraioldpage.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class saraipage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const saraipage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<saraipage> createState() => _saraipageState();
}

class _saraipageState extends State<saraipage> {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFe9e4de),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 45),

        child: Column(
          children: [
            // Card
            Card(
              color: Theme.of(context).cardColor, // DARK/LIGHT AUTO
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              shadowColor: Colors.blueAccent.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WELCOME TO',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      'Sarai Registration',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'An initiative by Bidhannagar Police',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Registration of Sarai within the jurisdiction of Bidhannagar Police Commissionerate is mandatory under the Sarais Act,'
                      ' 1867. All owners/keepers of hotels, lodges, guest houses, dormitories and similar establishments are required to furnish accurate details of their premises,'
                      ' management and occupants through this form for regulatory, security and law-and-order purposes. The information collected will be used for licensing and verification,'
                     '  and will be stored with utmost confidentiality. '

                     'Owners/keepers are requested to submit this form promptly and renew registration within the prescribed time or whenever there is any material change in ownership or use of the premises.'
                      
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Registration Form Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => saranewpage(
                          onThemeChanged: widget.onThemeChanged,
                          isDarkMode: widget.isDarkMode,
                        ),
                  ),
                );
              },
              icon: const Icon(Icons.app_registration),
              label: const Text('New Application '),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white, // FIX TEXT COLOR
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => saraioldpage(
                          onThemeChanged: widget.onThemeChanged,
                          isDarkMode: widget.isDarkMode,
                        ),
                  ),
                );
              },
              icon: const Icon(Icons.app_registration),
              label: const Text('Application for Renewal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white, // FIX TEXT COLOR
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
