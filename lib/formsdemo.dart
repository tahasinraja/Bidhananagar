// lib/tenant_form_page.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class TenantFormPage extends StatefulWidget {
  final String
  submitUrl; // pass "https://bnpcdeveloper.co.in/bnpolice/tenantbdn/tenantform.php" if you like
  const TenantFormPage({super.key, this.submitUrl = ''});

  @override
  State<TenantFormPage> createState() => _TenantFormPageState();
}

class _TenantFormPageState extends State<TenantFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _ownerNameCtl = TextEditingController();
  final TextEditingController _tenantNameCtl = TextEditingController();
  final TextEditingController _mobileCtl = TextEditingController();
  final TextEditingController _emailCtl = TextEditingController();
  final TextEditingController _addressCtl = TextEditingController();
  final TextEditingController _idNumberCtl = TextEditingController();
  final TextEditingController _rentAmountCtl = TextEditingController();

  DateTime? _leaseStart;
  DateTime? _leaseEnd;
  String _propertyType = 'Flat';
  bool _isSubmitting = false;
  File? _photoFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _ownerNameCtl.dispose();
    _tenantNameCtl.dispose();
    _mobileCtl.dispose();
    _emailCtl.dispose();
    _addressCtl.dispose();
    _idNumberCtl.dispose();
    _rentAmountCtl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _photoFile = File(picked.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _photoFile = File(picked.path);
      });
    }
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final DateTime initial =
        isStart
            ? (_leaseStart ?? DateTime.now())
            : (_leaseEnd ?? DateTime.now());
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _leaseStart = picked;
        } else {
          _leaseEnd = picked;
        }
      });
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      color: Colors.blue.shade800,
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 48,
            width: 48,
            fit: BoxFit.contain,
            errorBuilder:
                (_, __, ___) => const Icon(Icons.home, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Tenant Registration Form',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // Basic lease date check
    if (_leaseStart == null || _leaseEnd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose lease start and end dates.'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final uri =
          widget.submitUrl.isNotEmpty
              ? Uri.parse(widget.submitUrl)
              : Uri.parse(
                'https://bnpcdeveloper.co.in/bnpolice/tenantbdn/tenantform.php',
              );

      final request = http.MultipartRequest('POST', uri);

      // Add fields
      request.fields['owner_name'] = _ownerNameCtl.text.trim();
      request.fields['tenant_name'] = _tenantNameCtl.text.trim();
      request.fields['mobile'] = _mobileCtl.text.trim();
      request.fields['email'] = _emailCtl.text.trim();
      request.fields['address'] = _addressCtl.text.trim();
      request.fields['id_number'] = _idNumberCtl.text.trim();
      request.fields['property_type'] = _propertyType;
      request.fields['rent_amount'] = _rentAmountCtl.text.trim();
      request.fields['lease_start'] = _leaseStart!.toIso8601String();
      request.fields['lease_end'] = _leaseEnd!.toIso8601String();

      if (_photoFile != null) {
        final fileStream = http.ByteStream(_photoFile!.openRead());
        final length = await _photoFile!.length();
        final multipartFile = http.MultipartFile(
          'photo',
          fileStream,
          length,
          filename: _photoFile!.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        // If server returns JSON status, try to parse
        String body = response.body;
        try {
          final jsonBody = json.decode(body);
          if (jsonBody is Map && jsonBody['status'] != null) {
            final ok = jsonBody['status'].toString().toLowerCase() == 'success';
            if (ok) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Form submitted successfully')),
              );
              _formKey.currentState!.reset();
              setState(() {
                _photoFile = null;
                _leaseStart = null;
                _leaseEnd = null;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(jsonBody['message'] ?? 'Submission failed'),
                ),
              );
            }
          } else {
            // fallback success
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Form submitted')));
          }
        } catch (_) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Form submitted')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double spacing = 12.0;
    return Scaffold(
    
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Grid-like layout: two columns on wide screens
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 700;
                            return Wrap(
                              runSpacing: spacing,
                              spacing: spacing,
                              children: [
                                SizedBox(
                                  width:
                                      isWide
                                          ? (constraints.maxWidth - spacing) / 2
                                          : constraints.maxWidth,
                                  child: TextFormField(
                                    controller: _ownerNameCtl,
                                    decoration: const InputDecoration(
                                      labelText: 'Owner Name',
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                    validator:
                                        (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'Enter owner name'
                                                : null,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      isWide
                                          ? (constraints.maxWidth - spacing) / 2
                                          : constraints.maxWidth,
                                  child: TextFormField(
                                    controller: _tenantNameCtl,
                                    decoration: const InputDecoration(
                                      labelText: 'Tenant Name',
                                      prefixIcon: Icon(Icons.person_outline),
                                    ),
                                    validator:
                                        (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'Enter tenant name'
                                                : null,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      isWide
                                          ? (constraints.maxWidth - spacing) / 2
                                          : constraints.maxWidth,
                                  child: TextFormField(
                                    controller: _mobileCtl,
                                    keyboardType: TextInputType.phone,
                                    decoration: const InputDecoration(
                                      labelText: 'Mobile',
                                      prefixIcon: Icon(Icons.phone),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'Enter mobile';
                                      }
                                      if (v.trim().length < 8) {
                                        return 'Invalid mobile';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      isWide
                                          ? (constraints.maxWidth - spacing) / 2
                                          : constraints.maxWidth,
                                  child: TextFormField(
                                    controller: _emailCtl,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      labelText: 'Email (optional)',
                                      prefixIcon: Icon(Icons.email),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth,
                                  child: TextFormField(
                                    controller: _addressCtl,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      labelText: 'Address',
                                      alignLabelWithHint: true,
                                      prefixIcon: Icon(Icons.home),
                                    ),
                                    validator:
                                        (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'Enter address'
                                                : null,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      isWide
                                          ? (constraints.maxWidth - spacing) / 2
                                          : constraints.maxWidth,
                                  child: TextFormField(
                                    controller: _idNumberCtl,
                                    decoration: const InputDecoration(
                                      labelText:
                                          'ID Number (Aadhaar / Govt ID)',
                                      prefixIcon: Icon(
                                        Icons.confirmation_number,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      isWide
                                          ? (constraints.maxWidth - spacing) / 2
                                          : constraints.maxWidth,
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _propertyType,
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Flat',
                                        child: Text('Flat'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'House',
                                        child: Text('House'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Shop',
                                        child: Text('Shop'),
                                      ),
                                    ],
                                    onChanged:
                                        (v) =>
                                            setState(() => _propertyType = v!),
                                    decoration: const InputDecoration(
                                      labelText: 'Property Type',
                                      prefixIcon: Icon(Icons.domain),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      isWide
                                          ? (constraints.maxWidth - spacing) / 2
                                          : constraints.maxWidth,
                                  child: TextFormField(
                                    controller: _rentAmountCtl,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Rent Amount',
                                      prefixIcon: Icon(Icons.money),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      isWide
                                          ? (constraints.maxWidth - spacing) / 2
                                          : constraints.maxWidth,
                                  child: GestureDetector(
                                    onTap: () => _pickDate(context, true),
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Lease Start',
                                          prefixIcon: const Icon(
                                            Icons.date_range,
                                          ),
                                          hintText:
                                              _leaseStart == null
                                                  ? 'Select start'
                                                  : '${_leaseStart!.day}/${_leaseStart!.month}/${_leaseStart!.year}',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      isWide
                                          ? (constraints.maxWidth - spacing) / 2
                                          : constraints.maxWidth,
                                  child: GestureDetector(
                                    onTap: () => _pickDate(context, false),
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Lease End',
                                          prefixIcon: const Icon(
                                            Icons.date_range,
                                          ),
                                          hintText:
                                              _leaseEnd == null
                                                  ? 'Select end'
                                                  : '${_leaseEnd!.day}/${_leaseEnd!.month}/${_leaseEnd!.year}',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Photo (Tenant / Document)',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          _photoFile != null
                                              ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.file(
                                                  _photoFile!,
                                                  width: 110,
                                                  height: 110,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                              : Container(
                                                width: 110,
                                                height: 110,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.photo_camera,
                                                  size: 34,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: _pickImage,
                                                icon: const Icon(
                                                  Icons.photo_library,
                                                ),
                                                label: const Text('Gallery'),
                                              ),
                                              const SizedBox(height: 8),
                                              ElevatedButton.icon(
                                                onPressed: _takePhoto,
                                                icon: const Icon(
                                                  Icons.camera_alt,
                                                ),
                                                label: const Text('Camera'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isSubmitting ? null : _submitForm,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                child:
                                    _isSubmitting
                                        ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                        : const Text(
                                          'Submit',
                                          style: TextStyle(fontSize: 16),
                                        ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            _formKey.currentState?.reset();
                            setState(() {
                              _photoFile = null;
                              _leaseStart = null;
                              _leaseEnd = null;
                            });
                          },
                          child: const Text('Reset form'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
