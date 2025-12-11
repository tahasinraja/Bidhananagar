import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class mpinupdatebyotp extends StatefulWidget {
  final String phone;
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const mpinupdatebyotp({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
    required this.phone,
  });

  @override
  _mpinupdatebyotpState createState() => _mpinupdatebyotpState();
}

class _mpinupdatebyotpState extends State<mpinupdatebyotp> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController mpinController = TextEditingController();
  bool otpVerified = false;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  bool isLoading = false;

  Future<void> submit() async {
     String? token=await FirebaseMessaging.instance.getToken();
     if(token==null){
       print('token is null');
     }
     else{
       print('Fcm token:$token');
     }
    
    if (otpController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter OTP")));
      return;
    }
    if (mpinController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter MPIN")));
      return;
    }
    // final phone = phoneController.text.trim();
    // final pin = pinController.text.trim();

    // if (phone.isEmpty || pin.isEmpty) {
    //   _showMessage("❌ Enter mobile number and PIN");
    //   return;
    // }

    // if (pin.length != 4) {
    //   _showMessage("❌ PIN must be 4 digits");
    //   return;
    // }

    setState(() => isLoading = true);

    try {
      final loginUrl = Uri.parse('https://bnpcdeveloper.co.in/bnpolice/app/mpin_update.php?',
       // "https://bnpcdeveloper.co.in/bnpolice/app/verify_otp.php",
        //  "https://bnpcdeveloper.co.in/bnpolice/app/profile_login_check.php",
      );
      final loginResponse = await http.post(
        loginUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "ph": widget.phone,
          "otp": otpController.text,
          "mpin": mpinController.text,
        }),

        // body: {"ph": phone,
        // "mpin": pin},
      );
      final data = jsonDecode(loginResponse.body);
      print("🔽 VERIFY RESPONSE: ${loginResponse.body}");

      // final loginData = json.decode(loginResponse.body);
      // final loginStatus = loginData['status'] ?? '';
      // final loginMessage = loginData['message'] ?? '';

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (data['status'].toLowerCase() == 'success') {
        await prefs.setString('ph', widget.phone);
        await prefs.setBool('isloggedin', true);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("OTP & MPIN Verified ✔")));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => homepage(
                  onThemeChanged: widget.onThemeChanged,
                  isDarkMode: widget.isDarkMode,
                  phoneNumber: phoneController.text,
                ),
          ),
        );
        // Navigate to Signup or Home page
      }

      // if (loginResponse.toLowerCase() == 'success') {
      //   await prefs.setString('ph', phone);
      //   await prefs.setBool('isloggedin', true);

      //   _showMessage("✅ $loginMessage");

      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder:
      //           (_) => homepage(
      //             onThemeChanged: widget.onThemeChanged,
      //             isDarkMode: widget.isDarkMode,
      //           ),
      //     ),
      //   );
      // } else {

      //  new user → create profile

      // final createUrl = Uri.parse(
      //   "https://bnpcdeveloper.co.in/bnpolice/app/profile_create.php",
      // );
      // final createResponse = await http.post(
      //   createUrl,
      //   body: {"ph": widget.phone, "mpin": mpinController},
      // );

      // final createData = json.decode(createResponse.body);
      // final createStatus = createData['status'] ?? '';
      // final createMessage = createData['message'] ?? '';

      // if (createStatus.toLowerCase() == 'success') {
      //   await prefs.setString('ph', widget.phone);
      //   await prefs.setBool('isloggedin', true);
      //   _showMessage("✅ $createMessage");

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder:
      //         (_) => homepage(
      //           onThemeChanged: widget.onThemeChanged,
      //           isDarkMode: widget.isDarkMode,
      //         ),
      //   ),
      // );
      // }
      //  else {
      //   _showMessage("❌ $createMessage");
      // }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Invalid OTP')));
      }
    } catch (e) {
      _showMessage("❌ Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
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
                  SizedBox(height: h * 0.07),
                  // TextField(
                  //   controller: phoneController,
                  //   keyboardType: TextInputType.phone,
                  //   maxLength: 10,
                  //   style: const TextStyle(
                  //     fontSize: 22,
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.black,
                  //   ),
                  //   decoration: const InputDecoration(
                  //     hintText: "Enter Mobile Number",
                  //     counterText: '',
                  //     prefixText: '+91',
                  //   ),
                  // ),
             Center(
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'OTP',
        style: TextStyle(
          color: Colors.blue.shade800,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: ' requested for ',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: ' ${widget.phone} ',
            style: TextStyle(
              color: Colors.blue.shade800,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  ),
),

               
                  // Text(
                  //   ' ${widget.phone}.',
                  //   textAlign: TextAlign.center,
                  // ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "ENTER OTP",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    // obscureText: true,
                    animationType: AnimationType.fade,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 55,
                      fieldWidth: 55,
                      activeFillColor: Colors.white,
                      selectedFillColor: Colors.grey.shade200,
                      inactiveFillColor: Colors.grey.shade100,
                      activeColor: Colors.blue,
                      selectedColor: Colors.blueAccent,
                      inactiveColor: Colors.grey,
                    ),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "UPDATE MPIN",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  PinCodeTextField(
                    appContext: context,
                    length: 4,
                    controller: mpinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    animationType: AnimationType.fade,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 55,
                      fieldWidth: 55,
                      activeFillColor: Colors.white,
                      selectedFillColor: Colors.grey.shade200,
                      inactiveFillColor: Colors.grey.shade100,
                      activeColor: Colors.blue,
                      selectedColor: Colors.blueAccent,
                      inactiveColor: Colors.grey,
                    ),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: h * 0.07,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child:
                          isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
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
                                        phoneNumber: '',
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
    );
  }
}
