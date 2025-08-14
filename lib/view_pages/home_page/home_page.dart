import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialmediaclone/view_pages/notification_page.dart';

class PostsFeedPage extends StatefulWidget {
  @override
  _PostsFeedPageState createState() => _PostsFeedPageState();
}

class _PostsFeedPageState extends State<PostsFeedPage> {
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;
  String? currentUserId;
  Map<String, TextEditingController> commentControllers = {};
  Map<String, String> userIdToFullname = {};

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
    fetchPosts();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        currentUserId = user?.uid;
      });
      fetchPosts();
    });
  }

  Future<void> fetchPosts() async {
    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      List<Map<String, dynamic>> tempPosts = [];
      Set<String> commenterIds = {};

      for (var userDoc in usersSnapshot.docs) {
        final data = userDoc.data() as Map<String, dynamic>;
        final userId = userDoc.id;
        final fullName = data['fullname'] ?? 'Unknown';
        final profileImage = data['profileImage'] ?? '';

        if (data.containsKey('images') && data['images'] is List) {
          List<dynamic> images = data['images'];

          for (var img in images) {
            if (img is Map<String, dynamic>) {
              //  Privacy filtering
              final String privacy = img['privacy'] ?? 'public';
              final List allowedUsers = List.from(img['allowedUsers'] ?? []);

              bool canSeePost = false;
              if (privacy == 'public') {
                canSeePost = true;
              } else if (privacy == 'custom') {
                canSeePost = (userId == currentUserId) ||
                    allowedUsers.contains(currentUserId);
              } else if (privacy == 'private') {
                canSeePost = (userId == currentUserId);
              }

              // if (privacy == 'public') {
              //   canSeePost = true;
              // } else if (privacy == 'custom') {
              //   canSeePost = allowedUsers.contains(currentUserId);
              // } else if (privacy == 'private') {
              //   canSeePost = (userId == currentUserId);
              // }

              if (!canSeePost) continue; // skip post if not allowed

              // Handle comments list
              List<Map<String, dynamic>> comments =
                  List<Map<String, dynamic>>.from(img['comments'] ?? []);

              for (var comment in comments) {
                final cUserId = comment['userId'];
                if (cUserId != null) {
                  commenterIds.add(cUserId);
                }
              }

              String postId = img['url'];
              commentControllers[postId] ??= TextEditingController();

              tempPosts.add({
                'postId': postId,
                'userId': userId,
                'userName': fullName,
                'userProfile': profileImage,
                'url': img['url'],
                'timestamp': img['timestamp'],
                'likes': List<String>.from(img['likes'] ?? []),
                'comments': comments,
              });
            }
          }
        }
      }

      // Fetch commenter names
      if (commenterIds.isNotEmpty) {
        List<String> idsList = commenterIds.toList();
        for (var i = 0; i < idsList.length; i += 10) {
          final batchIds = idsList.sublist(
              i, i + 10 > idsList.length ? idsList.length : i + 10);
          var usersQuery = await FirebaseFirestore.instance
              .collection('users')
              .where(FieldPath.documentId, whereIn: batchIds)
              .get();

          for (var userDoc in usersQuery.docs) {
            final data = userDoc.data();
            userIdToFullname[userDoc.id] = data['fullname'] ?? userDoc.id;
          }
        }
      }

      // Sort posts
      tempPosts.sort((a, b) {
        Timestamp t1 = a['timestamp'] ?? Timestamp.now();
        Timestamp t2 = b['timestamp'] ?? Timestamp.now();
        return t2.compareTo(t1);
      });

      setState(() {
        posts = tempPosts;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching posts: $e');
      setState(() => isLoading = false);
    }
  }

  // Future<void> fetchPosts() async {
  //   try {
  //     QuerySnapshot usersSnapshot =
  //         await FirebaseFirestore.instance.collection('users').get();

  //     List<Map<String, dynamic>> tempPosts = [];
  //     Set<String> commenterIds = {};

  //     for (var userDoc in usersSnapshot.docs) {
  //       final data = userDoc.data() as Map<String, dynamic>;
  //       final userId = userDoc.id;
  //       final fullName = data['fullname'] ?? 'Unknown';
  //       final profileImage = data['profileImage'] ?? '';

  //       if (data.containsKey('images') && data['images'] is List) {
  //         List<dynamic> images = data['images'];

  //         for (var img in images) {
  //           if (img is Map<String, dynamic>) {
  //             List<Map<String, dynamic>> comments =
  //                 List<Map<String, dynamic>>.from(img['comments'] ?? []);

  //             for (var comment in comments) {
  //               final cUserId = comment['userId'];
  //               if (cUserId != null) {
  //                 commenterIds.add(cUserId);
  //               }
  //             }

  //             String postId = img['url'];
  //             commentControllers[postId] ??= TextEditingController();

  //             tempPosts.add({
  //               'postId': postId,
  //               'userId': userId,
  //               'userName': fullName,
  //               'userProfile': profileImage,
  //               'url': img['url'],
  //               'timestamp': img['timestamp'],
  //               'likes': List<String>.from(img['likes'] ?? []),
  //               'comments': comments,
  //             });
  //           }
  //         }
  //       }
  //     }

  //     if (commenterIds.isNotEmpty) {
  //       List<String> idsList = commenterIds.toList();
  //       for (var i = 0; i < idsList.length; i += 10) {
  //         final batchIds = idsList.sublist(
  //             i, i + 10 > idsList.length ? idsList.length : i + 10);
  //         var usersQuery = await FirebaseFirestore.instance
  //             .collection('users')
  //             .where(FieldPath.documentId, whereIn: batchIds)
  //             .get();

  //         for (var userDoc in usersQuery.docs) {
  //           final data = userDoc.data();
  //           userIdToFullname[userDoc.id] = data['fullname'] ?? userDoc.id;
  //         }
  //       }
  //     }

  //     tempPosts.sort((a, b) {
  //       Timestamp t1 = a['timestamp'] ?? Timestamp.now();
  //       Timestamp t2 = b['timestamp'] ?? Timestamp.now();
  //       return t2.compareTo(t1);
  //     });

  //     setState(() {
  //       posts = tempPosts;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     print('Error fetching posts: $e');
  //     setState(() => isLoading = false);
  //   }
  // }

  Future<void> toggleLike(int index) async {
    final post = posts[index];
    List<String> likes = List<String>.from(post['likes']);
    final userId = currentUserId;
    if (userId == null) return;

    final userLiked = likes.contains(userId);

    if (userLiked) {
      likes.remove(userId);
    } else {
      likes.add(userId);
    }

    setState(() {
      posts[index]['likes'] = likes;
    });

    await _updatePostLikes(post, likes);
  }

  Future<void> _updatePostLikes(
      Map<String, dynamic> post, List<String> likes) async {
    try {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(post['userId']);
      final userSnapshot = await userDoc.get();
      if (userSnapshot.exists) {
        final data = userSnapshot.data()!;
        List<dynamic> images = data['images'] ?? [];

        for (int i = 0; i < images.length; i++) {
          if (images[i]['url'] == post['url']) {
            images[i]['likes'] = likes;
            break;
          }
        }

        await userDoc.update({'images': images});
      }
    } catch (e) {
      print('Error updating likes: $e');
    }
  }

  Future<void> addComment(int index) async {
    final post = posts[index];
    final userId = currentUserId;
    if (userId == null) return; // not logged in

    final controller = commentControllers[post['postId']];
    final commentText = controller?.text.trim();
    if (commentText == null || commentText.isEmpty) return;

    List<Map<String, dynamic>> comments =
        List<Map<String, dynamic>>.from(post['comments']);
    comments.add({
      'userId': userId,
      'text': commentText,
      'timestamp': Timestamp.now(),
    });

    setState(() {
      posts[index]['comments'] = comments;
    });

    controller?.clear();

    try {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(post['userId']);
      final userSnapshot = await userDoc.get();
      if (userSnapshot.exists) {
        final data = userSnapshot.data()!;
        List<dynamic> images = data['images'] ?? [];

        for (int i = 0; i < images.length; i++) {
          if (images[i]['url'] == post['url']) {
            images[i]['comments'] = comments;
            break;
          }
        }

        await userDoc.update({'images': images});
      }
    } catch (e) {
      print('Error updating comments: $e');
    }
  }

  String formatTimestamp(Timestamp ts) {
    final date = ts.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget buildCommentItem(Map<String, dynamic> comment) {
    final commenterId = comment['userId'] ?? '';
    final commenterName = userIdToFullname[commenterId] ?? commenterId;
    final commentText = comment['text'] ?? '';
    final timestamp = comment['timestamp'] as Timestamp?;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            child: Text(commenterName.isNotEmpty
                ? commenterName[0].toUpperCase()
                : '?'),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(commenterName,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(commentText),
                if (timestamp != null)
                  Text(
                    formatTimestamp(timestamp),
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    commentControllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: const Text(
            'SNAP_GRAM',
            style: TextStyle(
                color: const Color(0xFF106837),
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
              icon: Icon(
                Icons.notifications,
                color: const Color(0xFF106837),
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.logout,
                color: const Color(0xFF106837),
              )),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.only(bottom: 16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final liked =
                    (post['likes'] as List<String>).contains(currentUserId);

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(255, 150, 237, 189),
                            child: Text(post['userName'][0].toUpperCase()),
                          ),
                          title: Text(
                            post['userName'],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(formatTimestamp(post['timestamp'])),
                        ),
                        Container(height: 1, color: const Color(0xFF106837)),
                        Image.network(
                          post['url'],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          height: 1,
                          color: const Color.fromARGB(59, 0, 0, 0),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  liked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: liked ? Colors.red : Colors.grey,
                                ),
                                onPressed: () => toggleLike(index),
                              ),
                              Text('${post['likes'].length}'),
                              SizedBox(width: 16),
                              Icon(Icons.comment_outlined),
                              SizedBox(width: 4),
                              Text('${post['comments'].length}'),
                            ],
                          ),
                        ),
                        if ((post['comments'] as List).isNotEmpty)
                          Container(
                            height: 100,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: post['comments'].length,
                              itemBuilder: (context, cIndex) {
                                return buildCommentItem(
                                    post['comments'][cIndex]);
                              },
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller:
                                      commentControllers[post['postId']],
                                  decoration: InputDecoration(
                                    hintText: 'Write a comment...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: const Color(0xFF106837),
                                  size: 30,
                                ),
                                onPressed: () => addComment(index),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
