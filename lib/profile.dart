import 'dart:convert';
import 'dart:io';

import 'package:bidhannagarpoliceapp/imageviwer.dart';
import 'package:bidhannagarpoliceapp/mailotppage.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bidhannagarpoliceapp/login.dart';

class profilescreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const profilescreen({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<profilescreen> createState() => _profilescreenState();
}

class _profilescreenState extends State<profilescreen> {
  File? _photo;


  Future<bool> checkVerified(String email) async {
    print("📩 Checking verification for email: $email");
    print("📱 Phone: $phone");

    final resp = await http.post(
      Uri.parse(
        "https://bnpcdeveloper.co.in/bnpolice/app/profile_update.php?ph=$phone",
      ),
      body: {
        "ph": phone,
        "email": email},
    );

    print("⬇️ Raw Response Body:");
    print(resp.body); // <-- DEBUG PRINT

    try {
      final data = json.decode(resp.body);

      print("📌 Decoded Response:");
       print(data);
      Navigator.push(context, 
      MaterialPageRoute(builder: (context) => Sendmailotp(
        onThemeChanged:widget. onThemeChanged,
       isDarkMode:widget. isDarkMode,
        phone: phone,
        email: email,
        ),));  
     

      bool isVerified = data["verified"] == 1;

      print("🔍 Verified Status: $isVerified");

      return isVerified;
    } catch (e) {
      print("❌ JSON Decode Error: $e");
      return false;
    }
  }

  /// 🖼 Pick Image gallery
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _photo = File(picked.path));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Selected image is :${_photo}')));
      debugPrint("📸 Image selected: ${picked.path}");
    }
    // 🔥 Auto close dialog after selecting image
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  bool isLoading = false;
  bool isUpdating = false;

  String phone = '';
  Map<String, dynamic>? profile;

  final nameController = TextEditingController();
  final psController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final bloodController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  //image pick

  Future<void> loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneNumber = prefs.getString('ph');

    if (phoneNumber == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => testlogin(
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
            profile!['image'];
            debugPrint("IMAGE URL FROM API: ${profile!['image']}");

            nameController.text = profile!['name'] ?? '';
            psController.text = profile!['ps'] ?? '';
            dobController.text = profile!['dob'] ?? '';
            addressController.text = profile!['address'] ?? '';
            bloodController.text = profile!['blood'] ?? '';
            emailController.text = profile!['email'] ?? '';
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

Future<void> updateProfile() async {
  if (isUpdating) return; // double-click protection
  setState(() => isUpdating = true);

  try {
    final url = Uri.parse(
      'https://bnpcdeveloper.co.in/bnpolice/app/profile_update.php',
    );

    debugPrint('🔗 API URL: $url');

    final request = http.MultipartRequest('POST', url);

    // ------------ Sending Fields ------------
    request.fields['ph'] = phone;
    request.fields['name'] = nameController.text.trim();
    request.fields['ps'] = psController.text.trim();
    request.fields['dob'] = dobController.text.trim();
    request.fields['address'] = addressController.text.trim();
    request.fields['email'] = emailController.text.trim();
    request.fields['blood'] = bloodController.text.trim();

    debugPrint('📨 Sending Fields → ${request.fields}');

    // ------------ Attach Image ------------
    if (_photo != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', _photo!.path),
      );
      debugPrint("📸 Uploading Image: ${_photo!.path}");
    }

    // ------------ Server Response ------------
    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    debugPrint("📦 Server Raw Response → $responseString");

    final data = json.decode(responseString);
    final status = data['status'] ?? '';
    final message = data['message'] ?? '';

    // ------------ Success Case ------------
    if (status.toLowerCase() == 'success') {
      _showMessage("✅ Profile updated...");

      await fetchProfile(phone);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Profile updated successfully!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 20),
            duration: Duration(seconds: 1),
          ),
        );
      }

      await Future.delayed(const Duration(seconds: 1));

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => profilescreen(
              onThemeChanged: widget.onThemeChanged,
              isDarkMode: widget.isDarkMode,
            ),
          ),
        );
      }
    }
    // ------------ Failed Case ------------
    else {
      _showMessage("❌ $message");
    }
  } catch (e) {
    _showMessage("❌ Error: $e");
    debugPrint("🔥 Exception: $e");
  }

  if (mounted) {
    setState(() => isUpdating = false);
  }
  
}
void _showMessage(String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg)),
  );
}



  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : const Color(0xFFe9e4de),
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Profile',
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Spacer(),

      
            TextButton.icon(
              style: TextButton.styleFrom(backgroundColor: Color(0xFFe9e4de)),
              icon: Icon(
                Icons.logout_outlined,
                color: widget.isDarkMode ? Colors.white : Colors.black,
                size: 28,
              ),
              label: Text(
                'Log Out',
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => testlogin(
                          onThemeChanged: widget.onThemeChanged,
                          isDarkMode: widget.isDarkMode,
                        ),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    // 🔹 Header
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // 🟦 Background Container
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                            color:
                                widget.isDarkMode ? Colors.black : Colors.white,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40),
                              ),
                              gradient: LinearGradient(
                                colors:
                                    widget.isDarkMode
                                        ? [
                                          Colors.black,
                                          Colors.grey.shade900,
                                        ] // dark mode shades
                                        : [
                                          Colors.white,
                                          Colors.white,
                                        ], // light mode shades
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                
                          ),
                        ),

                        // 🟨 Profile Image overlapping bottom edge
                        Positioned(
                          top: 74, // adjust this to overlap more or less
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 3),
                                    //blurRadius: 8,
                                  ),
                                ],
                              ),
                              child:
                              GestureDetector(
  onTap: () {
    // 👉 Agar profile null hai ya image nahi hai → ImageViewer na khole
    if (profile != null &&
        profile!['image'] != null &&
        profile!['image'].toString().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Imageviwer(
            Imageview: profile!['image'],
          ),
        ),
      );
    }
  },
  child: ClipOval(
    child: (profile == null)
        ? Image.asset(
            'assets/images/man_4140037.png',
            fit: BoxFit.cover,
          )
        : (profile!['image'] != null &&
                profile!['image'].toString().isNotEmpty)
            ? Image.network(
                profile!['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/man_4140037.png');
                },
              )
            : Image.asset(
                'assets/images/man_4140037.png',
                fit: BoxFit.cover,
              ),
  ),
),

                            ),
                          ),
                        ),
                        Positioned(
                          top: 65,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: SizedBox(
                              height: 140,
                              width: 140,
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/line.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 70),

                    // 🔹 Info Card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 25,
                      ),
                      decoration: BoxDecoration(
                        color:
                            widget.isDarkMode ? Colors.grey[900] : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child:
                          profile == null
                              ? const Center(
                                child: Text(
                                  'No Profile Found',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                              : buildProfileInfo(profile!, widget.isDarkMode),
                    ),

                    const SizedBox(height: 35),

                    // 🔹 Update Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                widget.isDarkMode
                                    ? Colors.grey[850]
                                    : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(color: Colors.white),
                            ),
                            elevation: 2,
                          ),
                          onPressed: _showEditBottomSheet,
                          child: Text(
                            "Update Profile",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
    );
  }
  void _showEditBottomSheet() {
  showModalBottomSheet(
    context: context,
    backgroundColor:
        widget.isDarkMode ? Colors.grey[900] : const Color(0xFFf8f6f2),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    isScrollControlled: true,
    builder: (_) {
      bool localUpdating = false; // 🔹 Local state for Save button
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _editField("Name", nameController),
                       TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        final email = emailController.text.trim();

                        if (email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please enter email")),
                          );
                          return;
                        }

                        checkVerified(email); // ← OTP bhejega
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        child: Text(
                          "Verify",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                  _editField("Address", addressController),
                  _editField("PS", psController),
                  _editField("Blood Group", bloodController),
                  TextField(
                    controller: dobController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "DOB",
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        dobController.text =
                            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                      }
                    },
                  ),
                  const SizedBox(height: 25),
              
               
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: 150,
                                  child: AlertDialog(
                                    title: Text('Profile Image'),
                                    content: SizedBox(
                                      height: 150,
                                      child: Column(
                                        children: [
                                          Text(
                                            'If you are change or upload new profile image then click Gallery  or cancle it',
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextButton(
                                                onPressed: _pickImage,
                                                child: Text("Gallery"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("close"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          label: Text('Profile Image'),
                          icon: Icon(Icons.image),
                        ),

                    if (_photo != null)
                      Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),

                const SizedBox(height: 25),


                  ElevatedButton.icon(
                    onPressed: localUpdating
                        ? null
                        : () async {
                            setModalState(() => localUpdating = true);
                            await updateProfile();
                            setModalState(() => localUpdating = false);
                          },
                    icon: localUpdating
                        ? SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(Icons.save),
                    label: Text(localUpdating ? "Updating please wait.." : "Save"),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}


//   void _showEditBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor:
//           widget.isDarkMode ? Colors.grey[900] : const Color(0xFFf8f6f2),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       isScrollControlled: true,
//       builder: (_) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 20,
//             right: 20,
//             top: 20,
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Edit Profile",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: widget.isDarkMode ? Colors.white : Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 _editField("Name", nameController),
//                // _editField("Email", emailController),
//                 TextField(
//                   controller: emailController,
//                   decoration: InputDecoration(
//                     labelText: "Email",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     suffixIcon: InkWell(
//                       onTap: () {
//                         final email = emailController.text.trim();

//                         if (email.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("Please enter email")),
//                           );
//                           return;
//                         }

//                         checkVerified(email); // ← OTP bhejega
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//                         child: Text(
//                           "Verify",
//                           style: TextStyle(
//                             color: Colors.blue,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: 10),
           
//                 _editField("Address", addressController),
//                 _editField("PS", psController),
//                 _editField("Blood Group", bloodController),

//                 TextField(
//                   controller: dobController,
//                   readOnly: true,
//                   decoration: const InputDecoration(
//                     labelText: "DOB",
//                     suffixIcon: Icon(Icons.calendar_today),
//                   ),
//                   onTap: () async {
//                     DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime.now(),
//                     );
//                     if (pickedDate != null) {
//                       dobController.text =
//                           "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
//                     }
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     isLoading
//                         ? const Center(child: CircularProgressIndicator())
//                         : ElevatedButton.icon(
//                           onPressed: () {
//                             showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return SizedBox(
//                                   height: 150,
//                                   child: AlertDialog(
//                                     title: Text('Profile Image'),
//                                     content: SizedBox(
//                                       height: 150,
//                                       child: Column(
//                                         children: [
//                                           Text(
//                                             'If you are change or upload new profile image then click Gallery  or cancle it',
//                                           ),
//                                           SizedBox(height: 20),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               TextButton(
//                                                 onPressed: _pickImage,
//                                                 child: Text("Gallery"),
//                                               ),
//                                               TextButton(
//                                                 onPressed: () {
//                                                   Navigator.pop(context);
//                                                 },
//                                                 child: Text("close"),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                           label: Text('Profile Image'),
//                           icon: Icon(Icons.image),
//                         ),

//                     if (_photo != null)
//                       Icon(Icons.check_circle, color: Colors.green),
//                   ],
//                 ),

//                 const SizedBox(height: 25),

               
// ElevatedButton.icon(
//   onPressed: isUpdating  ? null : updateProfile,
//   icon: isUpdating 
//       ? SizedBox(
//           height: 18,
//           width: 18,
//           child: CircularProgressIndicator(
//             color: Colors.white,
//             strokeWidth: 2,
//           ),
//         )
//       : Icon(Icons.save),
//   label: Text(
//     isUpdating ? "Saving..." : "Save",
//   ),
// ),



//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

  Widget _editField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
      ),
    );
  }
}

Widget buildProfileInfo(Map<String, dynamic> profile, bool isDarkMode) {
  final textStyleLabel = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    color: isDarkMode ? Colors.white : Colors.black,
  );

  final textStyleValue = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: isDarkMode ? Colors.white70 : Colors.black,
  );

  return Table(
    columnWidths: const {
      0: IntrinsicColumnWidth(),
      1: FixedColumnWidth(25),
      2: FlexColumnWidth(),
    },
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    children: [
      _buildTableRow("Name:", profile['name'], textStyleLabel, textStyleValue),
      _buildTableRow("Mobile:", profile['ph'], textStyleLabel, textStyleValue),
      _buildTableRow(
        "Email:",
        profile['email'],
        textStyleLabel,
        textStyleValue,
      ),
      _buildTableRow(
        "Address:",
        profile['address'],
        textStyleLabel,
        textStyleValue,
      ),
      _buildTableRow("PS:", profile['ps'], textStyleLabel, textStyleValue),
      _buildTableRow("D.O.B:", profile['dob'], textStyleLabel, textStyleValue),
      _buildTableRow(
        "Blood Group:",
        profile['blood'],
        textStyleLabel,
        textStyleValue,
      ),
    ],
  );
}

TableRow _buildTableRow(
  String label,
  String? value,
  TextStyle labelStyle,
  TextStyle valueStyle,
) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(label, style: labelStyle),
      ),
      const SizedBox(),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(value ?? '-', style: valueStyle),
      ),
    ],
  );
}
