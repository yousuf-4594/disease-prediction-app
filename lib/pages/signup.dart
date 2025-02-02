import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plants/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signup extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  Signup({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> signInWithEmailAndPassword(String userName, String email, String password) async {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // User signed in successfully
        ////////////////////////////////save data to users table to get
        // Reference to the users collection
        CollectionReference users = FirebaseFirestore.instance.collection('users');

        // Add a new document with a unique ID
        await users.doc(userCredential.user!.uid).set({
          'userId': userCredential.user!.uid,
          'userName':userName,
          'role': 'User',
        });
          ////////////////////////// retrieve user rol
        ///////////////////////////////
        print('User signed in: ${userCredential.user!.uid}');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  Home(userName:'',role:'')));

      } on FirebaseAuthException catch (e) {
        // Handle authentication failures
        _showSnackBar(context, "${e.message}", Colors.redAccent);
        print('Authentication failed. Error: ${e.message}');
      }
      catch (e) {
        // Handle errors here
        _showSnackBar(context, "$e", Colors.redAccent);
        print('Error signing in: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white60,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Create Your Account', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100.0),
            Image.asset(
              'assets/Logo.png',
              width: 50.0,
            ),
            const SizedBox(height: 25.0),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  TextButton(
                    onPressed: () {
                      final username = usernameController.text;
                      final email = emailController.text;
                      final password = passwordController.text;

                      if (username.isEmpty || email.isEmpty || password.isEmpty) {

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text('Please fill in all fields.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {

                        print('Username: $username');
                        print('Email: $email');
                        print('Password: $password');

                        signInWithEmailAndPassword(username,email, password);
                       // Navigator.pushNamed(context, '/login');
                      }
                    },

                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.green,
                      ),
                    ),
                  ),

                  const SizedBox(height: 35.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },



                    child: const Text(
                      'Continue as a Guest',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
