// import 'package:flutter/material.dart';
// import 'package:socialmediaclone/view_pages/profile_page/profile_page.dart';

// class CreatePost extends StatelessWidget {
//   const CreatePost({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: Text(
//             "Create Post",
//             style: TextStyle(color: Colors.black, fontSize: 20),
//           ),
//           actions: [
//             IconButton(
//               onPressed: () {},
//               icon: Icon(
//                 Icons.notifications_none,
//                 size: 28,
//               ),
//               color: Colors.red,
//             ),
//             IconButton(
//               onPressed: () {
//                 Navigator.of(context).push(
//                     MaterialPageRoute(builder: (context) => ProfilePage()));
//               },
//               icon: Icon(
//                 Icons.person,
//                 size: 28,
//               ),
//               color: const Color.fromARGB(255, 32, 109, 186),
//             ),
//           ]),
//       body: GestureDetector(
//         onTap: (){
//           print("create post icon pressed");
//         },
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage("assets/images/create_post.png"),
//                 fit: BoxFit.cover),
//           ),
//           child: Center(
//             child: Text(
//               "Tap to upload images",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class MultipleImageUploader extends StatefulWidget {
  @override
  _MultipleImageUploaderState createState() => _MultipleImageUploaderState();
}

class _MultipleImageUploaderState extends State<MultipleImageUploader> {
  List<XFile>? _images = [];

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedImages = await picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _images = pickedImages;
      });
    }
  }

  // Future<void> _uploadImages() async {
  //   for (var image in _images!) {
  //     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //     Reference ref = FirebaseStorage.instance.ref().child('uploads/$fileName');
  //     await ref.putFile(File(image.path));
  //     String downloadUrl = await ref.getDownloadURL();

  //     // Save URL to Firestore
  //     await FirebaseFirestore.instance.collection('posts').add({
  //       'image_url': downloadUrl,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });
  //   }
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Images Uploaded!')),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: Text("Create Post")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
                width: double.infinity,
                        height: 48,
              child: ElevatedButton(
                onPressed: _pickImages,
                  style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 209, 247, 226),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                child: Text("Select Images",style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 18),),
              ),
            ),
            const SizedBox(height: 16,),
            Expanded(
              child: GridView.builder(
                itemCount: _images?.length ?? 0,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  return Image.file(File(_images![index].path), fit: BoxFit.cover);
                },
              ),
            ),
          
            SizedBox(
                width: double.infinity,
                      height: 48,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF106837),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                onPressed:(){},
                //  _images!.isNotEmpty ? _uploadImages : null,
                child: Text("Upload Images",style: TextStyle(color: Colors.white, fontSize: 18),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
