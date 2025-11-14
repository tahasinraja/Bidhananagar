import 'dart:convert';
import 'package:bidhannagarpoliceapp/homepage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bidhannagarpoliceapp/login.dart';

class feedbackpage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const feedbackpage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<feedbackpage> createState() => _feedbackpageState();
}

class _feedbackpageState extends State<feedbackpage> {
  bool isLoading = true;
  bool isUpdating = false;

  String phone = '';
  Map<String, dynamic>? profile;

  final nameController = TextEditingController();
  final feedbackController = TextEditingController();
    double? latitude;
  double? longitude;

  //final _formKey = GlobalKey<FormState>();

    /// 🧭 Get Location (with Debug Print)
  Future<void> _getLocation() async {
    debugPrint("🔍 Getting current location...");
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("⚠️ Location services disabled!");
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        debugPrint("🚫 Location permission permanently denied!");
        return;
      }
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      latitude = pos.latitude;
      longitude = pos.longitude;
    });

    debugPrint("✅ Location fetched: lat=$latitude, long=$longitude");
  }

  @override
  void initState() {
    super.initState();
    loadProfile();
    _getLocation();
  }


  Future<void> loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneNumber = prefs.getString('ph');

    if (phoneNumber == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => testlogin(
            onThemeChanged: widget.onThemeChanged,
            isDarkMode: widget.isDarkMode,
          ),
        ),
      );
      return;
    }

    phone = phoneNumber;
    await fetchProfile(phoneNumber);
  }

  Future<void> fetchProfile(String phoneNumber) async {
    try {
      final url = Uri.parse(
        'https://bnpcdeveloper.co.in/bnpolice/app/profile_fetch.php?ph=$phoneNumber',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['stock'] != null &&
            data['stock'] is List &&
            data['stock'].isNotEmpty) {
          setState(() {
            profile = data['stock'][0];
            nameController.text = profile!['name'] ?? '';
          });
        } else {
          _showMessage("❌ No profile found");
        }
      } else {
        _showMessage("❌ Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _showMessage("❌ Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> feedbacksend() async {
    if (feedbackController.text.trim().isEmpty) {
      _showMessage("⚠️ Please write your feedback before submitting!");
      return;
    }

    setState(() => isUpdating = true);
    try {
      final url = Uri.parse(
        'https://bnpcdeveloper.co.in/bnpolice/app/feedback_insert.php',
      );
      final response = await http.post(url, body: {
        'ph': phone,
        'name': nameController.text.trim(),
        'feedbacks': feedbackController.text.trim(),
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      });

      final data = json.decode(response.body);
      final status = data['status'] ?? '';
      final message = data['message'] ?? '';

      if (status.toLowerCase() == 'success') {
        _showMessage("✅ Feedback submitted successfully!");
        await Future.delayed(const Duration(seconds: 2));
        print("Feedback submitted successfully!");
        print("Feedback: ${feedbackController.text.trim()}");
        print('Latitude: $latitude, Longitude: $longitude');
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => homepage(
                onThemeChanged: widget.onThemeChanged,
                isDarkMode: widget.isDarkMode,
              ),
            ),
          );
        }
      } else {
        _showMessage("❌ $message");
      }
    } catch (e) {
      _showMessage("❌ Error: $e");
    } finally {
      setState(() => isUpdating = false);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.isDarkMode ? Colors.black : const Color(0xFFe9e4de),
      appBar: AppBar(
        title: const Text(
          'Feedback',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor:
            widget.isDarkMode ? Colors.black : const Color(0xFFe9e4de),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, ${nameController.text}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color:
                          widget.isDarkMode ? Colors.white : Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "We value your feedback. Please share your thoughts below:",
                    style: TextStyle(
                      color:
                          widget.isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 🟢 Direct feedback note box
                  Container(
                    decoration: BoxDecoration(
                      color: widget.isDarkMode
                          ? Colors.grey[900]
                          : const Color(0xFFF8F6F2),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: feedbackController,
                      maxLines: 10,
                      minLines: 6,
                      style: TextStyle(
                        color: widget.isDarkMode
                            ? Colors.white
                            : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: "Write your feedback here...",
                        hintStyle: TextStyle(
                          color: widget.isDarkMode
                              ? Colors.white54
                              : Colors.grey[600],
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🔹 Submit button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: isUpdating ? null : feedbacksend,
                      icon: isUpdating
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.send,color: Colors.green,),
                      label: Text(
                        isUpdating ? "Submitting..." : "Submit Feedback",
                        style:  TextStyle(fontSize: 16,
                        color: widget.isDarkMode? Colors.white : Colors.black
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isDarkMode
                            ? Colors.black
                            : Colors.white,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
