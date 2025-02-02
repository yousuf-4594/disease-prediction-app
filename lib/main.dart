import 'package:flutter/material.dart';
import 'package:plants/l10n/l10n.dart';
import 'package:plants/pages/home.dart';
import 'package:plants/pages/signup.dart';
import 'package:plants/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plants/pages/startpage.dart';
import 'package:plants/service/language.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Import the AuthProvider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize language setting
  await Languages.initLanguage();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('ar', ''),
      ],
      initialRoute: '/startpage',
      routes: {
        '/startpage': (context) => const Startpage(),
        '/login': (context) => const Login(),
        '/signup': (context) => Signup(),
        '/home': (context) => Home(userName: '', role: ''),
      },
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }
}
