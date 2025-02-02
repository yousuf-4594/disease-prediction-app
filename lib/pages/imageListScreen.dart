import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ImageListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('history')
          .where('userId', isEqualTo: user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // or a loading indicator
        }

        List<DocumentSnapshot> documents = snapshot.data!.docs;
        List<String> imageUrls =
        documents.map((doc) => doc['imageUrl'] as String).toList();

        return ImageList(images: imageUrls);
      },
    );
  }
}

class ImageList extends StatelessWidget {
  final List<String> images;

  ImageList({required this.images});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Image.network(images[index]),
          // You can customize the ListTile to include additional information
          // about the image or provide actions like deletion, etc.
        );
      },
    );
  }
}
