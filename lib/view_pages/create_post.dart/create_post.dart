// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:path/path.dart' as path;
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'dart:convert';

// // import 'package:socialmediaclone/view_pages/notification_page.dart';

// // class CloudinaryMultiUploader extends StatefulWidget {
// //   const CloudinaryMultiUploader({Key? key}) : super(key: key);

// //   @override
// //   _CloudinaryMultiUploaderState createState() =>
// //       _CloudinaryMultiUploaderState();
// // }

// // class _CloudinaryMultiUploaderState extends State<CloudinaryMultiUploader> {
// //   final ImagePicker _picker = ImagePicker();
// //   bool isLoading = false;

// //   String cloudName = "dt7qnqy5z";
// //   String uploadPreset = "flutter_unsigned";
// //   Future<void> _pickAndUploadImage() async {
// //     final user = FirebaseAuth.instance.currentUser;
// //     if (user == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Please log in first")),
// //       );
// //       return;
// //     }

// //     final XFile? pickedFile =
// //         await _picker.pickImage(source: ImageSource.gallery);

// //     if (pickedFile != null) {
// //       setState(() => isLoading = true);

// //       try {
// //         String fileName = path.basename(pickedFile.path);

// //         var request = http.MultipartRequest(
// //           'POST',
// //           Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload"),
// //         );

// //         request.fields['upload_preset'] = uploadPreset;
// //         request.fields['folder'] = "users/${user.uid}";
// //         request.files.add(await http.MultipartFile.fromPath(
// //           'file',
// //           pickedFile.path,
// //         ));

// //         var response = await request.send();
// //         var responseData = await http.Response.fromStream(response);
// //         var data = json.decode(responseData.body);

// //         if (data['secure_url'] != null) {
// //           String imageUrl = data['secure_url'];

// //           Map<String, dynamic> imageData = {
// //             "url": imageUrl,
// //             "timestamp": Timestamp.now(),
// //           };

// //           await FirebaseFirestore.instance
// //               .collection("users")
// //               .doc(user.uid)
// //               .update({
// //             "images": FieldValue.arrayUnion([imageData])
// //           }).catchError((_) async {
// //             await FirebaseFirestore.instance
// //                 .collection("users")
// //                 .doc(user.uid)
// //                 .set({
// //               "images": [imageData]
// //             });
// //           });

// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(content: Text("Image uploaded successfully!")),
// //           );
// //         } else {
// //           throw Exception("Upload failed: ${data['error']}");
// //         }
// //       } catch (e) {
// //         print(" Upload error: $e");
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text("Error: $e")),
// //         );
// //       } finally {
// //         setState(() => isLoading = false);
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final user = FirebaseAuth.instance.currentUser;

// //     return Scaffold(
// //       appBar: AppBar(
// //         automaticallyImplyLeading: false,
// //         title: Padding(
// //           padding: const EdgeInsets.only(left: 20),
// //           child: const Text(
// //             'SNAP_GRAM',
// //             style: TextStyle(
// //                 color: const Color(0xFF106837),
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.bold),
// //           ),
// //         ),
// //         actions: [
// //           IconButton(
// //               onPressed: () {
// //                 Navigator.of(context).push(MaterialPageRoute(
// //                     builder: (context) => NotificationPage()));
// //               },
// //               icon: Icon(
// //                 Icons.notifications,
// //                 color: const Color(0xFF106837),
// //               )),
// //           IconButton(
// //               onPressed: ()  {
// //               },
// //               icon: Icon(
// //                 Icons.logout,
// //                 color: const Color(0xFF106837),
// //               )),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           if (isLoading) const LinearProgressIndicator(),
// //           Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: SizedBox(
// //               width: double.infinity,
// //               height: 48,
// //               child: ElevatedButton(
// //                 onPressed: _pickAndUploadImage,
// //                 child: const Text(
// //                   "Upload Image",
// //                   style: TextStyle(color: Colors.white, fontSize: 18),
// //                 ),
// //                 style: ElevatedButton.styleFrom(
// //                     backgroundColor: const Color(0xFF106837),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(6),
// //                     )),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 20),
// //           Expanded(
// //             child: user == null
// //                 ? const Center(child: Text("Please login to see images"))
// //                 : StreamBuilder<DocumentSnapshot>(
// //                     stream: FirebaseFirestore.instance
// //                         .collection("users")
// //                         .doc(user.uid)
// //                         .snapshots(),
// //                     builder: (context, snapshot) {
// //                       if (!snapshot.hasData) {
// //                         return const Center(child: CircularProgressIndicator());
// //                       }
// //                       var data =
// //                           snapshot.data!.data() as Map<String, dynamic>? ?? {};
// //                       List images = data["images"] ?? [];
// //                       if (images.isEmpty) {
// //                         return const Center(child: Text("No images uploaded"));
// //                       }
// //                       return GridView.builder(
// //                         gridDelegate:
// //                             const SliverGridDelegateWithFixedCrossAxisCount(
// //                           crossAxisCount: 3,
// //                           crossAxisSpacing: 5,
// //                           mainAxisSpacing: 5,
// //                         ),
// //                         itemCount: images.length,
// //                         itemBuilder: (context, index) {
// //                           var imageData = images[index] as Map<String, dynamic>;
// //                           return Image.network(
// //                             imageData["url"],
// //                             fit: BoxFit.cover,
// //                           );
// //                         },
// //                       );
// //                     },
// //                   ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart' as path;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:convert';

// import 'package:socialmediaclone/view_pages/notification_page.dart';

// class CloudinaryMultiUploader extends StatefulWidget {
//   const CloudinaryMultiUploader({Key? key}) : super(key: key);

//   @override
//   _CloudinaryMultiUploaderState createState() =>
//       _CloudinaryMultiUploaderState();
// }

// class _CloudinaryMultiUploaderState extends State<CloudinaryMultiUploader> {
//   final ImagePicker _picker = ImagePicker();
//   bool isLoading = false;

//   String cloudName = "dt7qnqy5z";
//   String uploadPreset = "flutter_unsigned";

//   List<Map<String, dynamic>> allUsers = [];
//   List<String> selectedUserIds = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchAllUsers();
//   }

//   Future<void> fetchAllUsers() async {
//     final currentUserId = FirebaseAuth.instance.currentUser?.uid;
//     var snapshot = await FirebaseFirestore.instance.collection('users').get();

//     List<Map<String, dynamic>> users = [];
//     for (var doc in snapshot.docs) {
//       if (doc.id != currentUserId) {
//         users.add({
//           "id": doc.id,
//           "name": doc['fullname'] ?? 'No Name',
//         });
//       }
//     }

//     setState(() {
//       allUsers = users;
//     });
//   }

//   Future<void> showUserSelectionDialog() async {
//     selectedUserIds = []; // reset previous selection

//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Select Users Who Can See Post"),
//           content: StatefulBuilder(
//             builder: (context, setState) {
//               return SizedBox(
//                 width: double.maxFinite,
//                 child: ListView(
//                   shrinkWrap: true,
//                   children: allUsers.map((user) {
//                     return CheckboxListTile(
//                       title: Text(user['name']),
//                       value: selectedUserIds.contains(user['id']),
//                       onChanged: (val) {
//                         setState(() {
//                           if (val == true) {
//                             selectedUserIds.add(user['id']);
//                           } else {
//                             selectedUserIds.remove(user['id']);
//                           }
//                         });
//                       },
//                     );
//                   }).toList(),
//                 ),
//               );
//             },
//           ),
//           actions: [
//             TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("Done"))
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _pickAndUploadImage() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please log in first")),
//       );
//       return;
//     }

//     final XFile? pickedFile =
//         await _picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       // Select users who can see the post
//       await showUserSelectionDialog();

//       setState(() => isLoading = true);

//       try {
//         String fileName = path.basename(pickedFile.path);

//         var request = http.MultipartRequest(
//           'POST',
//           Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload"),
//         );

//         request.fields['upload_preset'] = uploadPreset;
//         request.fields['folder'] = "users/${user.uid}";
//         request.files.add(await http.MultipartFile.fromPath(
//           'file',
//           pickedFile.path,
//         ));

//         var response = await request.send();
//         var responseData = await http.Response.fromStream(response);
//         var data = json.decode(responseData.body);

//         if (data['secure_url'] != null) {
//           String imageUrl = data['secure_url'];

//           Map<String, dynamic> imageData = {
//             "url": imageUrl,
//             "timestamp": Timestamp.now(),
//             "privacy": selectedUserIds.isEmpty ? "public" : "custom",
//             "allowedUsers": selectedUserIds,
//           };

//           await FirebaseFirestore.instance
//               .collection("users")
//               .doc(user.uid)
//               .update({
//             "images": FieldValue.arrayUnion([imageData])
//           }).catchError((_) async {
//             await FirebaseFirestore.instance
//                 .collection("users")
//                 .doc(user.uid)
//                 .set({
//               "images": [imageData]
//             });
//           });

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Image uploaded successfully!")),
//           );
//         } else {
//           throw Exception("Upload failed: ${data['error']}");
//         }
//       } catch (e) {
//         print("Upload error: $e");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: $e")),
//         );
//       } finally {
//         setState(() => isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Padding(
//           padding: EdgeInsets.only(left: 20),
//           child: Text(
//             'SNAP_GRAM',
//             style: TextStyle(
//                 color: Color(0xFF106837),
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold),
//           ),
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => NotificationPage()));
//               },
//               icon: const Icon(
//                 Icons.notifications,
//                 color: Color(0xFF106837),
//               )),
//           IconButton(
//               onPressed: () {},
//               icon: const Icon(
//                 Icons.logout,
//                 color: Color(0xFF106837),
//               )),
//         ],
//       ),
//       body: Column(
//         children: [
//           if (isLoading) const LinearProgressIndicator(),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SizedBox(
//               width: double.infinity,
//               height: 48,
//               child: ElevatedButton(
//                 onPressed: _pickAndUploadImage,
//                 child: const Text(
//                   "Upload Image",
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF106837),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(6),
//                     )),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: user == null
//                 ? const Center(child: Text("Please login to see images"))
//                 : StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection("users")
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) {
//                         return const Center(child: CircularProgressIndicator());
//                       }

//                       final currentUserId = user.uid;
//                       List allPosts = [];

//                       for (var doc in snapshot.data!.docs) {
//                         List images = [];
//                         if (doc.data() != null) {
//                           var data = doc.data() as Map<String, dynamic>;
//                           if (data.containsKey('images')) {
//                             images = data['images'] as List;
//                           }
//                         }

//                         for (var image in images) {
//                           if (image['privacy'] == 'public' ||
//                               (image['privacy'] == 'custom' &&
//                                   (image['allowedUsers'] as List)
//                                       .contains(currentUserId))) {
//                             allPosts.add(image);
//                           }
//                         }
//                       }

//                       if (allPosts.isEmpty) {
//                         return const Center(child: Text("No images available"));
//                       }

//                       return 
                      
//                        GridView.builder(
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                           crossAxisSpacing: 5,
//                           mainAxisSpacing: 5,
//                         ),
//                         itemCount: allPosts.length,
//                         itemBuilder: (context, index) {
//                           return 
//                           Image.network(
//                             allPosts[index]['url'],
//                             fit: BoxFit.cover,
//                           );
//                         },
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:socialmediaclone/view_pages/notification_page.dart';

class CloudinaryMultiUploader extends StatefulWidget {
  const CloudinaryMultiUploader({Key? key}) : super(key: key);

  @override
  _CloudinaryMultiUploaderState createState() =>
      _CloudinaryMultiUploaderState();
}

class _CloudinaryMultiUploaderState extends State<CloudinaryMultiUploader> {
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  String cloudName = "dt7qnqy5z";
  String uploadPreset = "flutter_unsigned";

  List<Map<String, dynamic>> allUsers = [];
  List<String> selectedUserIds = [];

  @override
  void initState() {
    super.initState();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    var snapshot = await FirebaseFirestore.instance.collection('users').get();

    List<Map<String, dynamic>> users = [];
    for (var doc in snapshot.docs) {
      if (doc.id != currentUserId) {
        users.add({
          "id": doc.id,
          "name": doc.data().containsKey('fullname')
              ? doc['fullname']
              : 'No Name',
        });
      }
    }

    setState(() {
      allUsers = users;
    });
  }

  Future<void> showUserSelectionDialog() async {
    selectedUserIds = []; // reset previous selection

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Users Who Can See Post"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: allUsers.map((user) {
                    return CheckboxListTile(
                      title: Text(user['name']),
                      value: selectedUserIds.contains(user['id']),
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            selectedUserIds.add(user['id']);
                          } else {
                            selectedUserIds.remove(user['id']);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Done"))
          ],
        );
      },
    );
  }

  Future<void> _pickAndUploadImage() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();

final username = userDoc.data()?['fullname'] ?? 'Unknown';

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
      // Select users who can see the post
      await showUserSelectionDialog();

      setState(() => isLoading = true);

      try {
        String fileName = path.basename(pickedFile.path);

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

          Map<String, dynamic> imageData = {
            "url": imageUrl,
            "timestamp": Timestamp.now(),
            "privacy": selectedUserIds.isEmpty ? "public" : "custom",
            "allowedUsers": selectedUserIds,
          };

          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .set({
            "images": FieldValue.arrayUnion([imageData]),
            "fullname": username,
          }, SetOptions(merge: true));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Image uploaded successfully!")),
          );
        } else {
          throw Exception("Upload failed: ${data['error']}");
        }
      } catch (e) {
        print("Upload error: $e");
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
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'SNAP_GRAM',
            style: TextStyle(
                color: Color(0xFF106837),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NotificationPage()));
              },
              icon: const Icon(
                Icons.notifications,
                color: Color(0xFF106837),
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.logout,
                color: Color(0xFF106837),
              )),
        ],
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

                      var userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
                      List images = userData.containsKey('images') ? userData['images'] : [];

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
                          return Image.network(
                            images[index]['url'],
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
