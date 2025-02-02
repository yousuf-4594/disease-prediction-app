import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plants/pages/home.dart';
import 'package:plants/pages/login.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:plants/service/language.dart';

Uint8List preprocessImage(File imageFile) {
  List<int> imageBytes = imageFile.readAsBytesSync();

  print('Total image bytes: ${imageBytes.length}');
  img.Image image = img.decodeImage(Uint8List.fromList(imageBytes))!;
  img.Image resizedImage = image;
  List<List<List<double>>> imgArray = [];
  for (int y = 0; y < resizedImage.height; y++) {
    List<List<double>> row = [];
    for (int x = 0; x < resizedImage.width; x++) {
      int pixel = resizedImage.getPixel(x, y);
      int r = img.getRed(pixel);
      int g = img.getGreen(pixel);
      int b = img.getBlue(pixel);

      double normalizedR = r / 255.0;
      double normalizedG = g / 255.0;
      double normalizedB = b / 255.0;
      row.add([normalizedR, normalizedG, normalizedB]);
    }
    imgArray.add(row);
  }

  List<List<List<List<double>>>> imgArrayWithBatch = [];
  imgArrayWithBatch.add(imgArray);

  List<double> flattenedList = imgArrayWithBatch
      .expand((batch) => batch
          .expand((row) => row.expand((col) => col.map<double>((val) => val))))
      .toList();

  Uint8List normalizedBytes = Uint8List.fromList(
      flattenedList.map((value) => (value * 255).toInt()).toList());

  return normalizedBytes;
}

class ScanedPhoto extends StatefulWidget {
  final File? scannedImage;
  const ScanedPhoto({super.key, this.scannedImage});

  @override
  State<ScanedPhoto> createState() => _ScanedPhotoState();
}

class _ScanedPhotoState extends State<ScanedPhoto> {
  String imageUrl = '';
  User? user = FirebaseAuth.instance.currentUser;
  bool _uploading = false;

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void _onSaveImageSuccess(BuildContext context) {
    _showSnackBar(context, 'Image saved successfully', Colors.green);
  }

  void _onSaveImageError(BuildContext context, String errorMessage) {
    _showSnackBar(context, ' $errorMessage', Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Languages.translate('SCANNED')!,
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.white60,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 500,
            child: Image.file(widget.scannedImage!, fit: BoxFit.cover),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _uploading
                  ? CircularProgressIndicator(
                      color: Colors.green,
                      strokeWidth: 3.0,
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        if (_uploading) return;

                        setState(() {
                          _uploading = true;
                        });

                        if (user == null) {
                          _onSaveImageError(
                              context, "Please Login first to save image");
                          Future.delayed(Duration(seconds: 3), () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          });
                          return;
                        }

                        String uniqueFileName =
                            DateTime.now().microsecondsSinceEpoch.toString();
                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDirImages =
                            referenceRoot.child('images');
                        Reference referenceImageToUpload =
                            referenceDirImages.child(uniqueFileName);

                        try {
                          await referenceImageToUpload
                              .putFile(File(widget.scannedImage!.path));
                          imageUrl =
                              await referenceImageToUpload.getDownloadURL();
                          print(imageUrl);

                          DocumentReference userDocRef = FirebaseFirestore
                              .instance
                              .collection('history')
                              .doc(user!.uid);
                          CollectionReference imagesCollectionRef =
                              userDocRef.collection('images');
                          await imagesCollectionRef.add({
                            'imageUrl': imageUrl,
                          });
                          print('Data is saved');
                          _onSaveImageSuccess(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Home(userName: '', role: '')));
                        } catch (error) {
                          print('$error');
                        } finally {
                          setState(() {
                            _uploading = false;
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                      ),
                      child: Text(
                        Languages.translate('Save')!,
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.white),
                      ),
                    ),
              ElevatedButton(
                onPressed: () {
                  if (widget.scannedImage != null) {
                    try {
                      identifyDisease(widget.scannedImage!, context);
                    } catch (error) {
                      print('Error reading image file: $error');
                      _onSaveImageError(context, 'Error reading image file');
                    }
                  } else {
                    _onSaveImageError(context, 'Scanned image is null');
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
                child: Text(
                  Languages.translate('Identify Disease')!,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home(userName: '', role: '')));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
                child: Text(
                  Languages.translate('Close')!,
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void _showSnackBar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
    ),
  );
}

void _onSaveImageError(BuildContext context, String errorMessage) {
  _showSnackBar(context, ' $errorMessage', Colors.green);
}

class DiseaseInfo {
  final String title;
  final String description;
  final List<String> treatmentSteps;
  final List<String> preventionMeasures;

  DiseaseInfo({
    required this.title,
    required this.description,
    required this.treatmentSteps,
    required this.preventionMeasures,
  });
}

DiseaseInfo tomatoBacterialSpot = DiseaseInfo(
  title: 'Tomato Bacterial spot',
  description:
      'Tomato Bacterial Spot is a common and often serious disease affecting tomatoes. It presents as small, dark, water-soaked spots on leaves, stems, and fruits. These spots can develop into brown scabs on fruits. The disease thrives in warm, humid conditions and can rapidly devastate crops if not managed effectively.',
  treatmentSteps: [
    '1. Immediate Removal: At the first sign of infection, remove and destroy affected plant parts or entire plants to prevent the spread of the bacteria',
    '2. Water Management: Water plants at the base to avoid splashing and wetting the leaves, which can spread the bacteria. Consider using drip irrigation or soaker hoses.',
    '3. Sanitation: Clean tools and equipment with a bleach solution or commercial sanitizer to prevent spreading the bacteria to healthy plants',
  ],
  preventionMeasures: [
    '1. Seed Treatment: Only use high-quality, disease-free seeds. Consider treating seeds with hot water or a bleach solution to kill any potential bacteria.',
    '2. Crop Rotation: Avoid planting tomatoes or related crops (e.g., peppers, eggplants) in the same soil.',
    '3. Field Sanitation: Remove and destroy crop residues at the end of the season. Manage weeds and volunteer plants that can harbor the bacteria.',
    '4. Avoid Working in Wet Conditions: Do not handle, tie, or work with tomato plants when they are wet, as this can easily spread the bacteria.',
  ],
);
DiseaseInfo Earlyblight = DiseaseInfo(
  title: 'Tomato Early Blight',
  description:
      'Early blight, is a significant disease affecting tomatoes. Its characterized by brownish-black spots on the lower leaves that can expand and display concentric rings. These spots may be surrounded by a yellow halo and can lead to extensive leaf tissue destruction. If untreated, early blight can progress up the plant, causing defoliation, particularly of lower leaves, and can even result in plant death.',
  treatmentSteps: [
    '1. Remove Infected Parts: At the first sign of infection, remove affected leaves or plants to prevent the spread. Its crucial to properly dispose of infected plant.',
    '2. Increase Air Circulation and Sun Exposure: Pruning plants to remove lower leaves and suckers helps increase air circulation and reduces the humidity around the plants, making the environment less favorable for the disease.',
  ],
  preventionMeasures: [
    '1. Mulching: Apply mulch around your plants to create a barrier that prevents fungal spores in the soil from splashing onto lower leaves during rainfall or watering',
    '2. Proper Spacing: Ensure adequate spacing between plants to improve air circulation and reduce humidity levels around the foliage',
    '3. Water Carefully: Water plants at the base to avoid wetting the leaves, which can facilitate the spread of fungal spores.',
    '4. Crop Rotation: Rotate crops every 2-3 years to reduce inoculum density in the soil. Avoid planting tomatoes or related crops in the same area consecutively.',
  ],
);

DiseaseInfo tomatoBacterialSpotAR = DiseaseInfo(
  title: 'Tomato Bacterial spot',
  description:
      'بقعة البكتيريا على الطماطم هي مرض شائع وغالبًا ما يكون خطيرًا يصيب الطماطم. يظهر على شكل بقع صغيرة، داكنة، مشبعة بالماء على الأوراق والسيقان والثمار. يمكن أن تتطور هذه البقع إلى قشور بنية على الثمار. ينمو المرض في الظروف الدافئة والرطبة ويمكن أن يدمر المحاصيل بسرعة إذا لم يتم التحكم فيه بشكل فعال.',
  treatmentSteps: [
    '1. - الإزالة الفورية: عند أول علامة للعدوى، قم بإزالة وتدمير الأجزاء المصابة من النبات أو النباتات بأكملها لمنع انتشار البكتيريا.',
    '2. إدارة المياه: قم بسقي النباتات من القاعدة لتجنب رش الماء وتبليل الأوراق، مما قد ينشر البكتيريا. فكر في استخدام الري بالتنقيط أو خراطيم النقع.',
    '3. النظافة: نظف الأدوات والمعدات بمحلول مبيض أو مطهر تجاري لمنع انتشار البكتيريا إلى النباتات السليمة.',
  ],
  preventionMeasures: [
    '1. معالجة البذور: استخدم فقط بذور عالية الجودة وخالية من الأمراض. فكر في معالجة البذور بماء ساخن أو محلول مبيض لقتل أي بكتيريا محتملة.',
    '2. تناوب المحاصيل: تجنب زراعة الطماطم أو المحاصيل المرتبطة (مثل الفلفل، الباذنجان) في نفس التربة.',
    '3. نظافة الحقل: أزل ودمر بقايا المحاصيل في نهاية الموسم. إدارة الأعشاب الضارة والنباتات الطوعية التي يمكن أن تأوي البكتيريا.',
    '4. تجنب العمل في الظروف الرطبة: لا تتعامل أو تربط أو تعمل مع نباتات الطماطم عندما تكون رطبة، حيث يمكن أن ينتشر البكتيريا بسهولة.',
  ],
);
DiseaseInfo EarlyblightAR = DiseaseInfo(
  title: 'Tomato Early Blight',
  description:
      'اللفحة المبكرة، هي مرض كبير يصيب الطماطم. يتميز بوجود بقع بنية سوداء على الأوراق السفلية التي يمكن أن تتوسع وتظهر حلقات متحدة المركز. قد تحيط هذه البقع بهالة صفراء ويمكن أن تؤدي إلى تدمير واسع لأنسجة الأوراق. إذا لم يتم علاجها، يمكن أن تتقدم اللفحة المبكرة على النبات، مما يسبب تساقط الأوراق، خاصة الأوراق السفلية، وحتى يمكن أن يؤدي إلى موت النبات.',
  treatmentSteps: [
    '1. إزالة الأجزاء المصابة: عند أول علامة للعدوى، قم بإزالة الأوراق أو النباتات المصابة لمنع الانتشار. من الضروري التخلص بشكل صحيح من النبات المصاب.',
    '2. زيادة التهوية والتعرض للشمس: تقليم النباتات لإزالة الأوراق السفلية والفروع الجانبية يساعد على زيادة التهوية ويقلل من الرطوبة حول النباتات، مما يجعل البيئة أقل ملاءمة للمرض.',
  ],
  preventionMeasures: [
    '1. التغطيس: ضع الغطاء حول نباتاتك لإنشاء حاجز يمنع الأبواغ الفطرية في التربة من الرش على الأوراق السفلية أثناء هطول الأمطار أو السقي.',
    '2. التباعد الصحيح: ضمان مسافة كافية بين النباتات لتحسين التهوية وتقليل مستويات الرطوبة حول الأوراق.',
    '3. السقي بعناية: سقي النباتات من القاعدة لتجنب تبليل الأوراق، والذي يمكن أن يسهل انتشار الأبواغ الفطرية.',
    '4. تناوب المحاصيل: قم بتناوب المحاصيل كل 2-3 سنوات لتقليل كثافة الأبواغ في التربة. تجنب زراعة الطماطم أو المحاصيل المتعلقة في نفس المنطقة بشكل متتالي.',
  ],
);

Map<String, DiseaseInfo> diseaseInfoMap = {
  'Bacterial spot': tomatoBacterialSpot,
  'Early blight': Earlyblight,
  'Bacterial spotAR': tomatoBacterialSpotAR,
  'Early blightAR': EarlyblightAR,
};

Future<void> identifyDisease(File scannedImage, BuildContext context) async {
  if (scannedImage == null) {
    _onSaveImageError(context, 'Scanned image is null');
    return;
  }

  print('Loading TensorFlow Lite model...');
  await Tflite.loadModel(
    model: 'assets/model.tflite',
    labels: 'assets/labels.txt',
  );

  List<dynamic>? results = await Tflite.runModelOnImage(
      path: scannedImage.path,
      numResults: 10,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5);

  if (results != null && results.isNotEmpty) {
    String predictedLabel = results[0]['label'] ?? 'Unknown';
    print('Predicted Disease: $predictedLabel');

    DiseaseInfo? diseaseInfo = diseaseInfoMap[predictedLabel];

    if (Languages.language == 'ar') {
      diseaseInfo = diseaseInfoMap[predictedLabel + 'AR'];
    }

    print("Disease: $diseaseInfo");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            Languages.translate('Identified Disease')!,
          ),
          content: Text('Predicted Disease: $predictedLabel'),
          actions: [
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        Languages.translate('Treatment')!,
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(diseaseInfo!.title),
                            SizedBox(height: 8),
                            Text(diseaseInfo.description),
                            SizedBox(height: 16),
                            Text('Steps to Treat ${diseaseInfo.title}'),
                            SizedBox(height: 8),
                            ...diseaseInfo.treatmentSteps
                                .map((step) => Text(step)),
                            SizedBox(height: 16),
                            Text('Prevention of ${diseaseInfo.title}'),
                            SizedBox(height: 8),
                            ...diseaseInfo.preventionMeasures
                                .map((measure) => Text(measure)),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            Languages.translate('Close')!,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                Languages.translate('Remedy')!,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                Languages.translate('OK')!,
              ),
            ),
          ],
        );
      },
    );
  } else {
    print('Error: No results received from TensorFlow Lite model');
  }
}
