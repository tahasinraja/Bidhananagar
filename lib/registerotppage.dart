import 'package:bidhannagarpoliceapp/homepage.dart';
import 'package:bidhannagarpoliceapp/login.dart';
import 'package:bidhannagarpoliceapp/signuppage.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pin_code_fields/pin_code_fields.dart';

class SendOtpPage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const SendOtpPage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });
  @override
  _SendOtpPageState createState() => _SendOtpPageState();
}

class _SendOtpPageState extends State<SendOtpPage> {
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;
  // 🔥 Random 6-digit OTP generate
  // String generatedOtp = (1000 + Random().nextInt(9999)).toString();
  Future<void> sendOtp() async {
    if (phoneController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Enter phone number')));
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse(
      'https://bnpcdeveloper.co.in/bnpolice/app/sent_otp.php', //user cheking vi hota hain
    ); // Replace with your API
    try {
      print("====================================");
      print("🔼 API CALL STARTED");
      print("API URL: $url");
      print("Phone Sent: ${phoneController.text}");
      // print("Generated OTP: $generatedOtp");

      final response = await http.post(
        url,
        body: {
          'ph': phoneController.text,
          // 'otp': generatedOtp
        },
      );
      print("====================================");
      print("🔽 API RESPONSE RECEIVED");
      print("Status Code: ${response.statusCode}");
      print("Raw Response Body: ${response.body}");

      final data = json.decode(response.body);

      // print('OTP is: $generatedOtp');        // <-- Correct OTP print
      print("====================================");
      print("📦 JSON DECODED RESPONSE:");
      print(data);

      print("====================================");
      print("SUCCESS FIELD: ${data['success']}");
      print("MESSAGE FIELD: ${data['message']}");

      // Case.1: NEW USER → SIGNUP
      if (data['status'] == "success") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => signuppage(
                  phone: phoneController.text,
                  onThemeChanged: widget.onThemeChanged,
                  isDarkMode: widget.isDarkMode,
                ),
          ),
        );
        return;
      }

      // Case.2: ALREADY REGISTERED USER → LOGIN PAGE
      if (data['status'] == "error" &&
          data['message'] != null &&
          data['message'].toString().toLowerCase().contains("already")) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Phone number already exists\n Please Login")));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => testlogin(
                  onThemeChanged: widget.onThemeChanged,
                  isDarkMode: widget.isDarkMode,
                ),
          ),
        );

        return;
      }

      // Case.3: OTHER ERRORS
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Failed to send OTP')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
       final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFe9e4de),
      // appBar: AppBar(title: Text('Bidhannagar Police'),centerTitle: true,),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.03,
              vertical: h * 0.04,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/images/BDN logo.png", height: h * 0.15),
                  SizedBox(height: h * 0.02),
                  Text(
                    "WELCOME TO",
                    style: TextStyle(
                      fontSize: h * 0.03,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    "BIDHANNAGAR POLICE",
                    style: TextStyle(
                      fontSize: h * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: h * 0.1),
                  
                
             
                  const SizedBox(height: 10),
               phoneInput(widget.isDarkMode),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: isLoading ? null : sendOtp,
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child:
                        isLoading
                            ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                            : Text("Send OTP"),
                  ),

                  
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "OR",
                          style: TextStyle(
                            fontSize: h * 0.02,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap:
                              () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => homepage(
                                        onThemeChanged: widget.onThemeChanged,
                                        isDarkMode: widget.isDarkMode,
                                      ),
                                ),
                              ),
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              fontSize: h * 0.03,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
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
        ),
      ),
      
      // Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Center(
      //     child: SizedBox(
      //       height: 450,
      //       child: Card(
      //         child: Column(
      //           // mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             SizedBox(height: 50),
      //             Image.asset('assets/images/BDN logo.png', height: 150),
      //             SizedBox(height: 60),
      //             phoneInput(widget.isDarkMode),
      //             // TextField(
      //             //   controller: phoneController,
      //             //   keyboardType: TextInputType.phone,
      //             //   decoration: InputDecoration(labelText: 'Phone Number'),
      //             // ),
      //             SizedBox(height: 20),
      //             ElevatedButton(
      //               onPressed: isLoading ? null : sendOtp,
      //               style: ElevatedButton.styleFrom(
      //                 elevation: 4,
      //                 backgroundColor: Colors.blueAccent,
      //                 foregroundColor: Colors.white,
      //                 minimumSize: Size(double.infinity, 55),
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(12),
      //                 ),
      //                 textStyle: TextStyle(
      //                   fontSize: 17,
      //                   fontWeight: FontWeight.w600,
      //                 ),
      //               ),
      //               child:
      //                   isLoading
      //                       ? SizedBox(
      //                         height: 24,
      //                         width: 24,
      //                         child: CircularProgressIndicator(
      //                           strokeWidth: 3,
      //                           color: Colors.white,
      //                         ),
      //                       )
      //                       : Text("Send OTP"),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget phoneInput(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color:
              isDarkMode ? Colors.white24 : Colors.blueAccent.withOpacity(0.4),
          width: 1.2,
        ),
      ),
      child: TextField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        maxLength: 10,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: Colors.blueAccent,
        decoration: InputDecoration(
          counterText: "",
          labelText: "Phone Number",
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.phone_iphone,
            color: isDarkMode ? Colors.white70 : Colors.blueAccent,
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
