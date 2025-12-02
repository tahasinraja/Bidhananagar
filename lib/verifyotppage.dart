import 'dart:convert';

import 'package:bidhannagarpoliceapp/signuppage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VerifyAndMpinPage extends StatefulWidget {
  final String phone;
   final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const VerifyAndMpinPage({required this.phone, super.key,
  required this.onThemeChanged, required this.isDarkMode
  });

  @override
  State<VerifyAndMpinPage> createState() => _VerifyAndMpinPageState();
}

class _VerifyAndMpinPageState extends State<VerifyAndMpinPage> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController mpinController = TextEditingController();
  bool otpVerified = false;
  bool isLoading = false;

  Future<void> verifyOtpAndCreateMpin() async {
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

    setState(() => isLoading = true);

    final url = Uri.parse(
      "https://bnpcdeveloper.co.in/bnpolice/app/verify_otp.php",
    );

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "ph": widget.phone,
          "otp": otpController.text,
          "mpin": mpinController.text,
        }),
      );
      final data = jsonDecode(response.body);
      print("🔽 VERIFY RESPONSE: ${response.body}");

      if (data["status"] == "success") {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("OTP & MPIN Verified ✔")));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => signuppage(
                  onThemeChanged: widget.onThemeChanged,
                  isDarkMode:widget. isDarkMode,
                  phone: widget.phone,
                ),
          ),
        );
        // Navigate to Signup or Home page
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data["message"] ?? "Error")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP & Create MPIN")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Phone: ${widget.phone}"),
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: mpinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Enter MPIN",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : verifyOtpAndCreateMpin,
              child:
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Verify OTP & Create MPIN"),
            ),
          ],
        ),
      ),
    );
  }
}
