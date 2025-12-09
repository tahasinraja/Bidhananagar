import 'dart:convert';
import 'package:bidhannagarpoliceapp/forgetpage.dart';
import 'package:bidhannagarpoliceapp/registerotppage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class testlogin extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const testlogin({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  _testloginState createState() => _testloginState();
}

class _testloginState extends State<testlogin> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  bool isLoading = false;

  Future<void> submit() async {
    String? token=await FirebaseMessaging.instance.getToken();
    print('Fcm token:$token');
    final phone = phoneController.text.trim();
    final pin = pinController.text.trim();

    if (phone.isEmpty || pin.isEmpty) {
      _showMessage("❌ Enter mobile number and MPIN");
      return;
    }
    if (pin.length != 4) {
      _showMessage("❌ PIN must be 4 digits");
      return;
    }

    setState(() => isLoading = true);

    try {
      final loginUrl = Uri.parse(
        "https://bnpcdeveloper.co.in/bnpolice/app/profile_login_check.php",
      );
      final loginResponse = await http.post(
        loginUrl,
        body: {"ph": phone, "mpin": pin},
      );

      final loginData = json.decode(loginResponse.body);
      final loginStatus = loginData['status'] ?? '';
      final loginMessage = loginData['message'] ?? '';

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (loginStatus.toLowerCase() == 'success') {
        await prefs.setString('ph', phone);
        await prefs.setBool('isloggedin', true);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login Succesfully')));
        //  _showMessage("✅ $loginMessage");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => homepage(
                  onThemeChanged: widget.onThemeChanged,
                  isDarkMode: widget.isDarkMode,
                ),
          ),
        );
      } else {
        // new user → create profile
        final createUrl = Uri.parse(
          "https://bnpcdeveloper.co.in/bnpolice/app/verify_otp.php",
          // "https://bnpcdeveloper.co.in/bnpolice/app/profile_create.php",
        );
        final createResponse = await http.post(
          createUrl,
          body: {"ph": phone, "mpin": pin},
        );

        final createData = json.decode(createResponse.body);
        final createStatus = createData['status'] ?? '';
        final createMessage = createData['message'] ?? '';

        if (createStatus.toLowerCase() == 'success') {
          await prefs.setString('ph', phone);
          await prefs.setBool('isloggedin', true);
            ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('New User Succesfully Registered')));
        //  _showMessage("✅ $createMessage");

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => homepage(
                    onThemeChanged: widget.onThemeChanged,
                    isDarkMode: widget.isDarkMode,
                  ),
            ),
          );
        } else {
            ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Phone Number is not registered')));
         // _showMessage("❌ $createMessage");
        }
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
                //  Divider(thickness: 10,),
                SizedBox(height: 20,),
                Center(
  child: ShaderMask(
    shaderCallback: (Rect bounds) {
      return LinearGradient(
        colors: [Colors.blue.shade800, Colors.lightBlueAccent],
      ).createShader(bounds);
    },
    child: Text(
      "Login",
      style: TextStyle(
        fontSize: h * 0.035,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        letterSpacing: 1.5,
      ),
    ),
  ),
),

                  SizedBox(height: h * 0.04),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Enter Mobile Number",
                      counterText: '',
                      prefixText: '+91',
                      prefixIcon: Icon(Icons.phone_android,color:   Color.fromRGBO(21, 101, 192, 1)  ,),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Enter MPIN",
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
                    controller: pinController,
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
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => forgetpage(
                                      onThemeChanged: widget.onThemeChanged,
                                      isDarkMode: widget.isDarkMode,
                                    ),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot MPIN?',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => SendOtpPage(
                                      onThemeChanged: widget.onThemeChanged,
                                      isDarkMode: widget.isDarkMode,
                                    ),
                              ),
                            );
                          },
                          child: Text(
                            'New Registration?',
                            style: TextStyle(color: Colors.blue.shade800),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //   SizedBox(height: 10),
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
    );
  }
}
