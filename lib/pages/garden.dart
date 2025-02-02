import 'package:flutter/material.dart';

import 'package:plants/pages/tomato.dart';
import 'package:plants/service/language.dart';

class garden extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Languages.translate('STEPS TO BUILD YOUR GARDEN')!,
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.white60,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: ListView(
        children: [
          SizedBox(height: 50),
          CustomCard(
            imagePath: 'assets/tomato.png',
            blackText: Languages.translate('tomato')!,
            greenText: Languages.translate('Grow a tomato')!,
            destinationPage: Tomato(),
          ),
// Other cards...
// Conditional card for admins
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String imagePath;
  final String blackText;
  final String greenText;
  final Widget destinationPage;

  const CustomCard({
    super.key,
    required this.imagePath,
    required this.blackText,
    required this.greenText,
    required this.destinationPage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
        );
      },
      child: Card(
        elevation: 5,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                imagePath,
                width: 100.0,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blackText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    greenText,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


