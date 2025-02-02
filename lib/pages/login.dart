import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plants/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userName= '';
  String role='';
  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
  Future<void> _signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      //////////////////get user role and user name
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        // Extract data from DocumentSnapshot
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Access specific fields
         userName = userData['userName'];
         role = userData['role'];

        // Print or use the extracted data
        print('Username: $userName');
        print('Role: $role');
      }

      ////////////////
      // User signed in successfully
      print('User signed in: ${userCredential.user!.uid}');
      _showSnackBar(context, "Hello $userName", Colors.green);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  Home(userName:userName,role:role)));

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


  @override
  void initState(){

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child:
                  Image.asset(
                    'assets/Logo.png',
                    width: 50.0,
                  ),
                ),
                const SizedBox(height: 40.0),
                const Text(
                  'Login to Your Account',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25.0),
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
                    final email = emailController.text;
                    final password = passwordController.text;

                    if (email.isNotEmpty && password.isNotEmpty) {
                      print(email);
                      _signInWithEmailAndPassword(email, password);
                     // Navigator.pushNamed(context, '/home');
                    } else {

                    }
                  },

                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.green,
                    ),
                  ),
                ),


                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
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
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}


class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomElevatedButton({super.key, 
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
      ),
      child: Text(text),
    );
  }
}
