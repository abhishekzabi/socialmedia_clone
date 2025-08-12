import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class CloudinaryMultiUploader extends StatefulWidget {
  const CloudinaryMultiUploader({Key? key}) : super(key: key);

  @override
  _CloudinaryMultiUploaderState createState() =>
      _CloudinaryMultiUploaderState();
}

class _CloudinaryMultiUploaderState extends State<CloudinaryMultiUploader> {
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  String cloudName = "dt7qnqy5z"; // Your Cloudinary cloud name
  String uploadPreset = "flutter_unsigned"; // Unsigned preset name
  Future<void> _pickAndUploadImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in first")),
      );
      return;
    }

    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => isLoading = true);

      try {
        String fileName = path.basename(pickedFile.path);

        // Upload to Cloudinary (inside a folder named by userId)
        var request = http.MultipartRequest(
          'POST',
          Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload"),
        );

        request.fields['upload_preset'] = uploadPreset;
        request.fields['folder'] = "users/${user.uid}";
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          pickedFile.path,
        ));

        var response = await request.send();
        var responseData = await http.Response.fromStream(response);
        var data = json.decode(responseData.body);

        if (data['secure_url'] != null) {
          String imageUrl = data['secure_url'];

          // --- CHANGE: use client-side Timestamp here (allowed inside arrays) ---
          Map<String, dynamic> imageData = {
            "url": imageUrl,
            "timestamp": Timestamp.now(), // client-generated timestamp
          };

          // Store image data in Firestore (array of maps)
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .update({
            "images": FieldValue.arrayUnion([imageData])
          }).catchError((_) async {
            // If user document doesn't exist, create it with images array
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .set({
              "images": [imageData]
            });
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Image uploaded successfully!")),
          );
        } else {
          throw Exception("Upload failed: ${data['error']}");
        }
      } catch (e) {
        print(" Upload error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
      ),
      body: Column(
        children: [
          if (isLoading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _pickAndUploadImage,
                child: const Text(
                  "Upload Image",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF106837),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    )),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: user == null
                ? const Center(child: Text("Please login to see images"))
                : StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      var data =
                          snapshot.data!.data() as Map<String, dynamic>? ?? {};
                      List images = data["images"] ?? [];
                      if (images.isEmpty) {
                        return const Center(child: Text("No images uploaded"));
                      }
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          var imageData = images[index] as Map<String, dynamic>;
                          return Image.network(
                            imageData["url"],
                            fit: BoxFit.cover,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
