import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plants/pages/scanedphotoscreen.dart';
import 'dart:io';

import 'package:plants/service/language.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  File? selectedImage;
  void takePicture() async {
    print(' i  am in function initial');
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 100, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    selectedImage = File(pickedImage.path);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanedPhoto(scannedImage: selectedImage),
      ),
    );
    print(' i  am at last of the function');
  }

  void takePictureFromGallery() async {
    print(' i  am in function initial');
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    selectedImage = File(pickedImage.path);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanedPhoto(scannedImage: selectedImage),
      ),
    );
    print(' i  am at last of the function');
  }

  @override
  Widget build(BuildContext context) {
    print('i am in widget');
    Widget content = const Text(
      '...',
      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green),
    );
    //if(selectedImage!=null){
    // content= Image.file(selectedImage!, fit: BoxFit.cover);
    //}
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white60,
          iconTheme: const IconThemeData(color: Colors.green),
          title: Text(
            Languages.translate('SCAN YOUR PLANT')!,
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green),
          ),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
              height: 500,
              width: double.infinity,
              alignment: Alignment.center,
              child: content,
            ),
            const SizedBox(height: 100.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: takePictureFromGallery,
                  child: Image.asset(
                    'assets/icons8-gallery-48(@2×).png',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.contain,
                  ),
                ),
                TextButton(
                  onPressed: takePicture,
                  child: Image.asset(
                    'assets/icons8-camera-50.png',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ]),
        ));
  }
}
