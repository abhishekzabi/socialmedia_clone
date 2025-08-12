import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;  // Document ID from Firestore
  final String userId;  // UID of the user who created the post
  final String imageUrl;  // Download URL from Firebase Storage
  final String caption;  // Optional text description
  final Timestamp timestamp;  // When the post was created

  Post({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.caption,
    required this.timestamp,
  });

  // Convert Firestore document to Post object
  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      userId: data['userId'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      caption: data['caption'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  // Convert Post object to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'imageUrl': imageUrl,
      'caption': caption,
      'timestamp': timestamp,
    };
  }
}