import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plants/pages/login.dart';
import 'package:plants/service/language.dart';

class Myplants extends StatelessWidget {
  const Myplants({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Languages.translate('History')!,
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.white60,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: user == null
          ? Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Background color
                  onPrimary: Colors.white, // Text color
                ),
                child: Text(
                  Languages.translate('Please login first to check history')!,                  
                  ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
              ),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('history')
                  .doc(user!.uid)
                  .collection('images')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                List<DocumentSnapshot> documents = snapshot.data!.docs;
                List<String> imageUrls =
                    documents.map((doc) => doc['imageUrl'] as String).toList();
                if (imageUrls.isEmpty) {
                  return Center(
                    child: Text(
                      'Scan your plant',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.green,
                        fontSize: 18,
                      ),
                    ),
                  );
                }
                return ImageList(images: imageUrls);
              },
            ),
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
        return Dismissible(
          key: Key(images[index]),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            deleteImage(context, index, images);
          },
          background: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 20.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(83, 0, 0, 0),
            ),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: ListTile(
            title: Card(
              child: Image.network(
                images[index],
                width: 200,
                height: 150,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          ),
        );
      },
    );
  }

  void deleteImage(BuildContext context, int index, List<String> images) async {
    try {
      String imageUrlToDelete = images[index];
      User? user = FirebaseAuth.instance.currentUser;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('history')
          .doc(user!.uid)
          .collection('images')
          .where('imageUrl', isEqualTo: imageUrlToDelete)
          .limit(1)
          .get();
      if (querySnapshot.size > 0) {
        await querySnapshot.docs.first.reference.delete();
        images.removeAt(index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image deleted'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {},
            ),
          ),
        );
      } else {
        print('No document found with imageUrl: $imageUrlToDelete');
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }
}
