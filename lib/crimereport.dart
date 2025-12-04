import 'dart:convert';
import 'dart:io';
import 'package:bidhannagarpoliceapp/homepage.dart';
import 'package:bidhannagarpoliceapp/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class crimereport extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const crimereport({
    super.key,

    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<crimereport> createState() => _crimereportState();
}

class _crimereportState extends State<crimereport> {
  bool isfieldname = false;
  bool isfieldemail = false;
  bool isLoading = false;
  String phone = '';
  Map<String, dynamic>? profile;
  //fetch ps list
  List<dynamic> locationlist = [
    // 'Airport PS',
    // 'Baguiati PS',
    // 'Bidhannagar East PS',
    // 'Bidhannagar North PS',
    // 'Cyber Crime PS',
    // 'Bidhannagar South PS',
    // 'Electronic Complex PS',
    // 'Eco Park PS',
    // 'Lakes PS',
    // 'Nabadiganta PS',
    // 'New Town PS',
    // 'Narayanpur PS',
    // 'Rajarhat PS',
    // 'Salt Lake PS',
    // 'Techno City PS',
    // 'Women PS'
  ];

  Future<void> fetchpslist() async {
    final url = Uri.parse(
      "https://bnpcdeveloper.co.in/bnpolice/app/fetch_policestation.php",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'].toLowerCase() == 'success') {
          setState(() {
            locationlist = List<String>.from(
              data['data'].map((item) => item['ps'] ?? ''),
            );
            isLoading = false;
          });

          print('locationlist: $locationlist');
        } else {
          throw Exception("Fetch Failed: ${data['message']}");
        }
      } else {
        throw Exception("Server Error");
      }
    } catch (e) {
      print("Error fetching list → $e");
    }
  }

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
            isfieldname =
                nameCtrl.text.isNotEmpty; // Check if nameCtrl.text is not empty
            phCtrl.text = P!['ph'] ?? '';
            emailCtrl.text = P!['email'] ?? '';
            isfieldemail =
                emailCtrl
                    .text
                    .isNotEmpty; // Check if emailCtrl.text is not empty
            // psCtrl.text = P!['ps'] ?? '';
            profile!['address'] ?? '';
            profile!['blood'] ?? '';

            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
          _showMessage("❌ No profile found");
        }
      } else {
        _showMessage("❌ Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _showMessage("❌ Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  //locatio list function

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  bool isloading = false;

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phCtrl = TextEditingController();
  final TextEditingController psCtrl = TextEditingController();
  final TextEditingController desCtrl = TextEditingController();
  final TextEditingController subCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController uidCtrl = TextEditingController();

  File? _photo;
  File? _video;
  double? latitude;
  double? longitude;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchpslist();
    _getLocation(); // auto get location
    _loadPhoneAndFetchProfile();
    emailCtrl.addListener(() => setState(() {})); // 👈 this line is key
    nameCtrl.addListener(() => setState(() {}));
  }

  /// 🔹 Load phone from SharedPreferences then fetch profile
  Future<void> _loadPhoneAndFetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('ph') ?? ''; // make sure phone was saved on login
    if (phone.isNotEmpty) {
      fetchProfile(phone);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => testlogin(
                onThemeChanged: widget.onThemeChanged,
                isDarkMode: widget.isDarkMode,
              ),
        ),
      );
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

  /// 🖼 Pick Image camera
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _photo = File(picked.path));
      debugPrint("📸 Image selected: ${picked.path}");
    }
  }

  // pick image from gallery
  Future<void> _pickImagegallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _photo = File(picked.path));
      debugPrint("📸 Image selected: ${picked.path}");
    }
  }

  /// 🎥 Pick Video from gallery
  Future<void> _pickVideo() async {
    final picked = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _video = File(picked.path));
      debugPrint("🎬 Video selected: ${picked.path}");
    }
  }

  //pick video from camera
  Future<void> _pickVideocamera() async {
    final picked = await ImagePicker().pickVideo(source: ImageSource.camera);
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
      'https://bnpcdeveloper.co.in/bnpolice/app/report_crime.php',
    );
    debugPrint("🚀 Sending POST request to: $uri");

    final request = http.MultipartRequest('POST', uri);
    request.fields['name'] = nameCtrl.text;
    request.fields['ph'] = phCtrl.text;
    request.fields['uid'] = uidCtrl.text;
    request.fields['email'] = emailCtrl.text;
    request.fields['sub'] = subCtrl.text;
    request.fields['ps'] = psCtrl.text;
    request.fields['latitude'] = latitude?.toString() ?? '';
    request.fields['longitude'] = longitude?.toString() ?? '';
    request.fields['des'] = desCtrl.text;

    debugPrint("🧾 Fields Sent: ${request.fields}");

    if (_photo != null) {
      request.files.add(await http.MultipartFile.fromPath('pic', _photo!.path));
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
          // await Future.delayed(const Duration(seconds: 2));
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
          Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : const Color(0xFFe9e4de),

      appBar: AppBar(
        title: const Text('Report Crime'),
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : const Color(0xFFe9e4de),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameCtrl,
                readOnly: isfieldname,
                decoration: InputDecoration(
                  label: RichText(
                    text: TextSpan(
                      text: 'Name',
                      style: TextStyle(
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors
                                    .white // Dark Mode
                                : Colors.black87,
                      ),
                      children: [
                        TextSpan(
                          text: "*",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                validator: (v) => v!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: phCtrl,
                readOnly: isfieldname,
                decoration: InputDecoration(
                  label: RichText(
                    text: TextSpan(
                      text: 'Phone',
                      style: TextStyle(
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors
                                    .white // Dark Mode
                                : Colors.black87,
                      ),
                      children: [
                        TextSpan(
                          text: "*",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'Enter phone' : null,
              ),
              TextFormField(
                controller: emailCtrl,
                readOnly: isfieldemail, //agar emty ho fill kare
                decoration: const InputDecoration(labelText: 'Email'),
                //    validator: (v) => v!.isEmpty ? 'Enter email' : null,
              ),
              TextFormField(
                controller: uidCtrl,
                decoration: const InputDecoration(labelText: 'Aadhar Number'),
                keyboardType: TextInputType.phone,
                maxLength: 12,
                //  validator: (v) => v!.isEmpty ? 'Enter subject' : null,
              ),
              TextFormField(
                controller: subCtrl,
                decoration: InputDecoration(
                  label: RichText(
                    text: TextSpan(
                      text: 'Subject',
                      style: TextStyle(
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors
                                    .white // Dark Mode
                                : Colors.black87,
                      ),
                      children: [
                        TextSpan(
                          text: "*",
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors
                                        .white // Dark Mode
                                    : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                validator: (v) => v!.isEmpty ? 'Enter subject' : null,
              ),

              isLoading
                  ? CircularProgressIndicator()
                  : DropdownButtonFormField(
                    items:
                        locationlist
                            .map(
                              (ps) =>
                                  DropdownMenuItem(value: ps, child: Text(ps)),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        psCtrl.text = value.toString();
                      });
                    },
                    decoration: InputDecoration(
                      label: RichText(
                        text: TextSpan(
                          text: "Police Station",
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors
                                        .white // Dark Mode
                                    : Colors.black87,
                          ),

                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                    validator:
                        (value) =>
                            value == null || value.toString().isEmpty
                                ? "Select Police Station"
                                : null,
                  ),

              // TextFormField(
              //   controller: psCtrl,
              //   decoration: const InputDecoration(labelText: 'Police Station'),
              //   validator: (v) => v!.isEmpty ? 'Enter P.S' : null,
              // ),
              TextFormField(
                controller: desCtrl,
                decoration: InputDecoration(
                  label: RichText(
                    text: TextSpan(
                      text: 'Description',
                      style: TextStyle(
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors
                                    .white // Dark Mode
                                : Colors.black87,
                      ),
                      children: [
                        TextSpan(
                          text: "*",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Enter discription' : null,
              ),

              const SizedBox(height: 20),
              // Text('📍 Lat: ${latitude ?? "..."}, Lng: ${longitude ?? "..."}'),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Select Image Source'),
                                  content: Row(
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: _pickImagegallery,
                                        icon: const Icon(Icons.image),
                                        label: Text('Gallery'),
                                      ),
                                      SizedBox(width: 6),

                                      ElevatedButton.icon(
                                        onPressed: _pickImage,
                                        icon: const Icon(Icons.camera_alt),
                                        label: Text('Camera'),
                                      ),
                                      
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.image),
                          label: const Text('Pick Photo'),
                        ),
                        const SizedBox(height: 16),

                        // 📸 Image Preview
                        if (_photo != null)
                        Icon(Icons.check_circle, color: Colors.green),
                    
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Select Video Source'),
                                  content: Row(
                                    children: [
                                      ElevatedButton.icon(onPressed: _pickVideo,
                                      icon: const Icon(Icons.video_file),
                                       label: const Text('Gallery'),),
                                       SizedBox(width: 6),
                                             SizedBox(width: 6),
                                      ElevatedButton.icon(onPressed: _pickVideocamera,
                                      icon: const Icon(Icons.video_call),
                                       label: Text('Camera'),),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.video_file),
                          label: const Text('Pick Video'),
                        ),
                        const SizedBox(height: 20),
                        if (_video != null)
                        Icon(Icons.check_circle, color: Colors.green),
                          // Column(
                          //   children: [
                          //     const Text(
                          //       "🎬 Selected Video:",
                          //       style: TextStyle(fontWeight: FontWeight.bold),
                          //     ),
                          //     SizedBox(height: 10),
                          //     Text(
                          //       _video!.path.split('/').last,
                          //       style: const TextStyle(
                          //         color: Colors.blueGrey,
                          //         overflow: TextOverflow.ellipsis,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              isloading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: _submitData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 40,),
                 Container(
  padding: EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.red.withOpacity(0.1),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.red, width: 1),
  ),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(Icons.info, color: Colors.red, size: 22),
      SizedBox(width: 10),
      Expanded(
        child: Text(
          "Disclaimer:\nTo register FIR please visit Police Station",
          style: TextStyle(
            color: Colors.red.shade900,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  ),
),
 
            ],
          ),
        ),
      ),
    );
  }
}
