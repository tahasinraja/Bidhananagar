import 'package:bidhannagarpoliceapp/tenantregistration.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class nocpage extends StatefulWidget {
    final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const nocpage({super.key, required this.onThemeChanged, required this.isDarkMode});

  @override
  State<nocpage> createState() => _nocpageState();
}

class _nocpageState extends State<nocpage> {
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
    final theme = Theme.of(context); // shortcut

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // AUTO THEME COLOR

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 45),

        child: Column(
          children: [
            // Card
            Card(
              color: theme.cardColor, // DARK/LIGHT AUTO
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
                      style: theme.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      'NOC Form for Meeting\nRally/Procession',
                      style: theme.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'An initiative by Bidhannagar Police',
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Text(
                    //   'No description available.....',
                    //   style: theme.textTheme.bodyMedium!.copyWith(
                    //     fontSize: 16,
                    //     height: 1.5,
                    //   ),
                    // ),
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
                    builder: (context) => docsdownviewpage(
                      filePath: 'assets/images/NOC.pdf',
                      title: 'NOC Form ',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.app_registration),
              label: const Text('Registration Form'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white, // FIX TEXT COLOR
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          ],
        ),
      ),
    );
  }
}
