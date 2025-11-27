import 'dart:convert';

import 'package:bidhannagarpoliceapp/sarainewdoc.dart';
import 'package:bidhannagarpoliceapp/tenantregistration.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class saranewpage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const saranewpage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<saranewpage> createState() => _saranewpageState();
}

class _saranewpageState extends State<saranewpage> {
  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  bool isLoading = false;
  Future<void> postnewformdata() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();
   const status = "new";  // 🔥 always send "new"

    if (phone.isEmpty || phone.isEmpty) {
      _showMessage("❌ Enter mobile number");
      return;
    }
    if (name.isEmpty) {
      _showMessage("❌ Enter name");
      return;
    }
    if (address.isEmpty) {
      _showMessage("❌ Enter address");
      return;
    }
    if (status.isEmpty) {
      _showMessage("❌ Enter status");
      return;
    }

    setState(() => isLoading = true);

    final posturls = Uri.parse(
      'https://bnpcdeveloper.co.in/bnpolice/app/sarai_insert.php',
    );
    try {
      final response = await http.post(
        posturls,
        body: {'name': name, 'ph': phone, 'address': address, 'status': status},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final createStatus = data['status'] ?? '';
        final createMessage = data['message'] ?? '';
print('createStatus:$createStatus');
        if (createStatus.toLowerCase() == 'success') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => docsdownviewpage(
                    filePath: 'assets/images/Sarai Application.pdf',
                    title: 'Download Sarai Application',
                  ),
            ),
          );
        }

        print('success');
      } else {
        print('failed');
      }
    } catch (e) {
      print('error:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFe9e4de),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : const Color(0xFFe9e4de),
        title: const Text('Sarai New Application'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(12),
          child: Column(
           // mainAxisAlignment: MainAxisAlignment.center,
        
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>sarainewdocpage(onThemeChanged:widget. onThemeChanged, 
                          isDarkMode:widget. isDarkMode)
                          
                          
                          //  docsdownviewpage(
                          //   filePath: 'assets/images/sasainew_documentation.pdf',
                          //   title: 'Document to attach',
                          // ),
                    ),
                  );
                },
                icon: const Icon(Icons.app_registration),
                label: const Text('View Documentations'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white, // FIX TEXT COLOR
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
        SizedBox(height: 50,),
        Column(
          children: [
         
        
     Card(
  elevation: 3,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [

        Text(
          'Fill the following details to download form:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),

        const SizedBox(height: 16),

        // NAME
        _modernTextField(
          context: context,
          controller: nameController,
          label: "Name",
        ),

        const SizedBox(height: 12),

        // PHONE
        _modernTextField(
          context: context,
          controller: phoneController,
          label: "Phone",
          isNumber: true,
          maxLength: 10,
        ),

        const SizedBox(height: 12),

        // ADDRESS
        _modernTextField(
          context: context,
          controller: addressController,
          label: "Address",
        ),

        const SizedBox(height: 20),

        // BUTTON
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: postnewformdata,
            icon: const Icon(Icons.download),
            label: const Text('Download Form'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

      ],
    ),
  ),
)

        
          ],
        )
        
          
            
            ],
          ),
        ),
      ),
    );
  }
  Widget _modernTextField({
  required BuildContext context,
  required TextEditingController controller,
  required String label,
  bool isNumber = false,
  int? maxLength,
}) {
  return TextField(
    controller: controller,
    keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    maxLength: maxLength,
    decoration: InputDecoration(
      counterText: "",
      label: RichText(
        text: TextSpan(
          text: " $label",
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
          children: const [
            TextSpan(
              text: " *",
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      filled: true,
      fillColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[900]
          : Colors.grey[200],
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.blueAccent,
          width: 1.5,
        ),
      ),
    ),
  );
}

}
