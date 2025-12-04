import 'dart:convert';

import 'package:bidhannagarpoliceapp/homepage.dart';
import 'package:bidhannagarpoliceapp/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';

class forgetpage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const forgetpage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<forgetpage> createState() => _forgetpageState();
}

class _forgetpageState extends State<forgetpage> {
  bool isLoading = false;
  TextEditingController phcntroller = TextEditingController();
  TextEditingController mpincontroller = TextEditingController();

  Future<void> updatempin() async {
    final ph=phcntroller.text.trim();
    final mpin=mpincontroller.text.trim();  
    if (ph.isEmpty || mpin.isEmpty) {
      _showMessage("❌ Enter mobile number and PIN");
      return;
    }
       if (mpin.length != 4) {
      _showMessage("❌ PIN must be 4 digits");
      return;
    }
    setState(() => isLoading = true);
    final mpinurl = Uri.parse(
      "https://bnpcdeveloper.co.in/bnpolice/app/mpin_update.php?",
    );
    try {
      final response = await http.post(
        mpinurl,
        body: {"ph": phcntroller.text, "mpin": mpincontroller.text},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'].toLowerCase() == 'success') 
        
        {
          ScaffoldMessenger.of( context).showSnackBar(SnackBar(content: Text('Mpin updated successfully')));
          //  _showMessage("✅ ${data['message']}");
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
          setState(() {
            isLoading = false;
          });
        } else {
          throw Exception("Failed: ${data['message']}");
        }
      } else {
        throw Exception("Failed to update mpin");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updatempin();
  }

  @override
  Widget build(BuildContext context) {
      final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
   
      body:  Container(
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
                  TextField(
                    controller: phcntroller,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      hintText: " Registered Mobile Number",
                      counterText: '',
                      prefixText: '+91',
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Center(
                  //   child: Text(
                  //     "Enter MPIN",
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.blue.shade800,
                  //     ),
                  //   ),
                  // ),
                   SizedBox(height: 10),
                  PinCodeTextField(
                    appContext: context,
                    length: 4,
                    controller: mpincontroller,
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
                      onPressed: isLoading? null : updatempin,
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
                                "Update MPIN",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                    
                  ),
               
                  
                  Center(
                    child: Column(
                      children: [
                      
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap:
                              () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => 
                                      homepage(
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
