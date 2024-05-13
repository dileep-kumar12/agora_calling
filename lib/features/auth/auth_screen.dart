import 'package:agora_voice_calling/features/home/screen/home.dart';
import 'package:agora_voice_calling/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
               bool isTrue =   await _signIn();
                 if(isTrue){
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Home()));
                 }
                },
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () async {
                bool isTrue = await  _signUp();
                  if(isTrue){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Home()));
                  }
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sign in with email and password
  Future<bool> _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      User? user = await _auth.signInWithEmailPassword(email, password);
      if (user != null) {
        print('Sign in success!');
        // Navigate to next screen
       return true;
      } else {
        print('Sign in failed. Invalid credentials.');
        return false;
      }
    } else {
      print('Please enter email and password.');
      return false;
    }
  }

  // Sign up with email and password
  Future<bool> _signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      User? user = await _auth.signUpWithEmailPassword(email, password);
      if (user != null) {

        return true;
      } else {
        print('Sign up failed. Please try again.');
        return false;
      }
    } else {
      print('Please enter email and password.');
      return false;
    }
  }
}