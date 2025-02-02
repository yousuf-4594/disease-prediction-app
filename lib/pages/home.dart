import 'package:flutter/material.dart';
import 'package:plants/pages/imageListScreen.dart';
import 'package:plants/pages/login.dart';
import 'package:plants/service/language.dart';
import 'GenerateReport.dart';
import 'garden.dart';
import 'scan.dart';
import 'myplants.dart';
import 'signup.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatelessWidget {
  final String userName;
  final String role;
  Home({super.key, required this.userName, required this.role});

  void _reloadHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Home(userName: userName, role: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    String _currentLanguage = Languages.language;
    var islogin = false;

    Future<void> signOut(BuildContext context) async {
      try {
        await FirebaseAuth.instance.signOut();
        Navigator.of(context, rootNavigator: true).pop(); // Close the menu
        // You might also want to navigate to the login or home screen after logout
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
        //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
      } catch (e) {
        print('Error signing out: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white60,
        iconTheme: const IconThemeData(color: Colors.green),
        title: Text('${Languages.translate('welcome')} $userName',
            style: TextStyle(color: Colors.green)),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                signOut(context);
              } else if (value == 'change_language_to_en') {
                Languages.setLanguage("en");
                _reloadHome(context);
              } else if (value == 'change_language_to_ar') {
                Languages.setLanguage("ar");
                _reloadHome(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                'Logout',
                'Change language to en',
                'Change language to ar',
              ].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice.toLowerCase().replaceAll(' ', '_'),
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              //const SizedBox(height: 20.0),
              //Container(
              //padding: const EdgeInsets.all(16.0),
              //   child: Image.asset(
              //     'assets/Logo.png',
              //     height: 50.0,
              //   ),
              // ),

              const SizedBox(height: 100.0),

              // Conditionally render the 'MY PLANTS' card for non-admin users
              role != 'Admin'
                  ? CustomCard(
                      imagePath: 'assets/MyPlants.png',
                      blackText: '${Languages.translate('My Plants')}',
                      greenText: '${Languages.translate('View Your history')}',
                      destinationPage: Myplants(),
                    )
                  : const SizedBox
                      .shrink(), // This will show nothing for admin users

              const SizedBox(height: 15.0),
              role == 'Admin'
                  ? CustomCard(
                      imagePath: 'assets/Report.png',
                      blackText: 'Reports',
                      greenText: 'Reports  ',
                      destinationPage: report(),
                    )
                  : CustomCard(
                      imagePath: 'assets/Pasted Graphic.png',
                      blackText: '${Languages.translate('Scan')}',
                      greenText:
                          '${Languages.translate('Try to scan the plants to know the type')}',
                      destinationPage: Scan(),
                    ),
              const SizedBox(height: 15.0),
              CustomCard(
                imagePath: 'assets/Garden.png',
                blackText: '${Languages.translate('Start up your garden')}',
                greenText: '${Languages.translate('Step by step instruction')}',
                destinationPage: garden(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

mixin hello {}

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
        margin: EdgeInsets.symmetric(horizontal: 20),
        elevation: 5,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                imagePath,
                width: 80.0, // Adjust the width as needed
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: Languages.language == 'ar'
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
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
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
