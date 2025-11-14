import 'dart:convert';
import 'dart:io';
import 'package:bidhannagarpoliceapp/homepage.dart';
import 'package:bidhannagarpoliceapp/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class trafficreport extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const trafficreport({
    super.key,

    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<trafficreport> createState() => _trafficreportState();
}

class _trafficreportState extends State<trafficreport> {
  bool isnamefilled = false;
  bool isloading = false;
  //fetch function
  String phone = '';
  Map<String, dynamic>? profile;
    final List<String>? locationlist = [
 
 
  'Airport PS',
  'Baguiati PS',
  'Bidhannagar East PS',
  'Bidhannagar North PS',
  'Cyber Crime PS',
  'Bidhannagar South PS',
  'Electronic Complex PS',
  'Eco Park PS',
  'Lakes PS',
  'Nabadiganta PS',
  'New Town PS',
  'Narayanpur PS',
  'Rajarhat PS',
  'Salt Lake PS',
  'Techno City PS',
  'Women PS'

  ];
  //fetch data function
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
          final P = data['stock'][0];
          setState(() {
            profile = P;
            nameCtrl.text = P!['name'] ?? '';
            isnamefilled = nameCtrl.text.isNotEmpty;
            phCtrl.text = P!['ph'] ?? '';

            profile!['address'] ?? '';
            profile!['blood'] ?? '';

            isloading = false;
          });
        } else {
          setState(() => isloading = false);
          _showMessage("❌ No profile found");
        }
      } else {
        _showMessage("❌ Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _showMessage("❌ Error: $e");
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phCtrl = TextEditingController();
  final TextEditingController localityCtrl = TextEditingController();
  final TextEditingController desCtrl = TextEditingController();
  final TextEditingController uidCtrl = TextEditingController();

  File? _photo;
  File? _video;
  double? latitude;
  double? longitude;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getLocation(); 
    _loadprofiledata();// auto get location
     nameCtrl.addListener(() => setState(() {}));
  }

  Future<void> _loadprofiledata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('ph') ?? ''; // make sure phone was saved on login
    if (phone.isNotEmpty) {
      fetchProfile(phone);
    } else {
       Navigator.pushReplacement(context, MaterialPageRoute(builder:
       (context) => testlogin(onThemeChanged: widget.onThemeChanged, isDarkMode: widget.isDarkMode,)));
    }
  }

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

  /// 🖼 Pick Image
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _photo = File(picked.path));
      debugPrint("📸 Image selected: ${picked.path}");
    }
  }

  /// 🎥 Pick Video
  Future<void> _pickVideo() async {
    final picked = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _video = File(picked.path));
      debugPrint("🎬 Video selected: ${picked.path}");
    }
  }

  /// 📤 Submit Data
  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isloading = true);
    final uri = Uri.parse(
      'https://bnpcdeveloper.co.in/bnpolice/app/trafic_incident.php',
    );
    debugPrint("🚀 Sending POST request to: $uri");

    final request = http.MultipartRequest('POST', uri);
    request.fields['name'] = nameCtrl.text.trim();
    request.fields['ph'] = phCtrl.text.trim();
    request.fields['locality'] = localityCtrl.text;
    request.fields['latitude'] = latitude?.toString() ?? '';
    request.fields['longitude'] = longitude?.toString() ?? '';
    request.fields['des'] = desCtrl.text;
  request.fields['uid'] = uidCtrl.text;
    debugPrint("🧾 Fields Sent: ${request.fields}");

    if (_photo != null) {
      request.files.add(
        await http.MultipartFile.fromPath('photo', _photo!.path),
      );
      debugPrint("📎 Photo attached: ${_photo!.path}");
    }
    if (_video != null) {
      request.files.add(
        await http.MultipartFile.fromPath('video', _video!.path),
      );
      debugPrint("📎 Video attached: ${_video!.path}");
    }

    try {
      final res = await request.send();
      debugPrint("📡 Response Status Code: ${res.statusCode}");

      final body = await res.stream.bytesToString();
      debugPrint("📦 Raw Response Body: $body");

      if (res.statusCode == 200) {
        final data = jsonDecode(body);
        debugPrint("✅ Decoded Response: $data");

        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Report submitted successfully!')),
          );
          await Future.delayed(const Duration(seconds: 3));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => homepage(
                    onThemeChanged: widget.onThemeChanged,
                    isDarkMode: widget.isDarkMode,
                  ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ Error: ${data['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '⚠️please wait for a moment. Your report is being processed.',
            ),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => homepage(
                  onThemeChanged: widget.onThemeChanged,
                  isDarkMode: widget.isDarkMode,
                ),
          ),
        );
      }
    } catch (e) {
      debugPrint("💥 Exception caught: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.isDarkMode ? Colors.black : const Color(0xFFe9e4de),
      appBar: AppBar(
        title: const Text('Report Traffic Incident'),
        backgroundColor:
            widget.isDarkMode ? Colors.black : const Color(0xFFe9e4de),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameCtrl,
                readOnly: isnamefilled,
              //  readOnly: nameCtrl.text.isNotEmpty,// agar emty mile to edit ho jaaye
                decoration: const InputDecoration(labelText: 'Name'),
                // validator: (v) => v!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: phCtrl,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                // validator: (v) => v!.isEmpty ? 'Enter phone' : null,
              ),
                TextFormField(
                controller: uidCtrl,
                //readOnly: true,
                decoration: const InputDecoration(labelText: 'Aadhar Number'),
                keyboardType: TextInputType.phone,
                maxLength: 12,
                // validator: (v) => v!.isEmpty ? 'Enter phone' : null,
              ),
              TextFormField(
                controller: localityCtrl,
                decoration: const InputDecoration(labelText: 'Locality'),
                validator: (v) => v!.isEmpty ? 'Enter locality' : null,
              ),
              TextFormField(
                controller: desCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              Text('📍 Lat: ${latitude ?? "..."}, Lng: ${longitude ?? "..."}'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Pick Photo'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickVideo,
                    icon: const Icon(Icons.video_file),
                    label: const Text('Pick Video'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              isloading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: _submitData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Submit', style: TextStyle(fontSize: 16,color: Colors.white)),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
