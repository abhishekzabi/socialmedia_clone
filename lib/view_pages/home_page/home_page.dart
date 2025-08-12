
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllPostsPage extends StatefulWidget {
  @override
  _AllPostsPageState createState() => _AllPostsPageState();
}

class _AllPostsPageState extends State<AllPostsPage> {
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    setState(() => isLoading = true);

    // QuerySnapshot snapshot = await FirebaseFirestore.instance
    //     .collection("users")
    //     .get();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
    .collection("users")
    .get(const GetOptions(source: Source.server));


    List<Map<String, dynamic>> loadedPosts = [];

    for (var doc in snapshot.docs) {
      var userData = doc.data() as Map<String, dynamic>;
      var imagesCollection = await FirebaseFirestore.instance
          .collection("users")
          .doc(doc.id)
          .collection("images")
          .orderBy("timestamp", descending: true)
          .get();

      for (var imageDoc in imagesCollection.docs) {
        var imageData = imageDoc.data() as Map<String, dynamic>;
        loadedPosts.add({
          "userId": doc.id,
          "username": userData["fullname"] ?? "Unknown",
          "imageUrl": imageData["url"],
          "timestamp": imageData["timestamp"]
        });
      }
    }

    loadedPosts.sort((a, b) =>
        (b["timestamp"] as Timestamp)
            .compareTo(a["timestamp"] as Timestamp));

    setState(() {
      posts = loadedPosts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Posts")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchPosts,
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  var post = posts[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post["username"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          post["imageUrl"],
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
