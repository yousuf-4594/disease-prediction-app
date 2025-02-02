import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:plants/pages/home.dart';
class Startpage extends StatefulWidget {
  const Startpage({super.key});

  @override
  State<Startpage> createState() => _StartpageState();
}

class _StartpageState extends State<Startpage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLogin = false;

  checkIfLogin() async{
    _auth.authStateChanges().listen((User? user) {
      if(user != null && mounted){
        setState(() {
          isLogin = true;

        });

      }
    });
  }
  @override
  void initState() {
    super.initState();
    checkIfLogin();

    Future.delayed(const Duration(seconds: 3), () {
      if(isLogin){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  Home(userName:'',role:'')));

      }else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Logo.png',
              width: 100.0,
            ),
            const SizedBox(height: 20.0),
            const Text(
              ' Welcome to ZAD',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

