import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmediaclone/view_pages/home_page/entry.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData({
    required String uid,
    required String fullname,
    required String email,
    required int age,
    required String address,
    required String phone,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'fullname': fullname,
      'email': email,
      'age': age,
      'address': address,
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

class SaveUserDataForm extends StatefulWidget {
  @override
  _SaveUserDataFormState createState() => _SaveUserDataFormState();
}

class _SaveUserDataFormState extends State<SaveUserDataForm> {
  final _formKey = GlobalKey<FormState>();

  final _fullnameController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  User? user;

  bool _isSaving = false;

  final firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF2F2F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      );

  Future<void> saveData() async {
    if (!_formKey.currentState!.validate()) return;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No logged-in user found')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await firestoreService.saveUserData(
        uid: user!.uid,
        fullname: _fullnameController.text.trim(),
        email: user!.email ?? '',
        age: int.parse(_ageController.text.trim()),
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User data saved successfully!')),
      );
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => EntryPage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Save User Data')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isSaving
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _fullnameController,
                      decoration: _inputDecoration('Full Name'),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Enter full name' : null,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: user?.email ?? '',
                      readOnly: true,
                      decoration: _inputDecoration('Email'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _ageController,
                      decoration: _inputDecoration('Age'),
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Enter age';
                        if (int.tryParse(val) == null)
                          return 'Enter valid number';
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: _inputDecoration('Address'),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Enter address' : null,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: _inputDecoration('Phone Number'),
                      keyboardType: TextInputType.phone,
                      validator: (val) => val == null || val.isEmpty
                          ? 'Enter phone number'
                          : null,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: saveData,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF106837),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            )),
                        child: Text(
                          'Save Data',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
