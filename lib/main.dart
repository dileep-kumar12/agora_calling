import 'package:agora_voice_calling/core/firebase/firebase_options.dart';
import 'package:agora_voice_calling/features/auth/auth_screen.dart';
import 'package:agora_voice_calling/features/home/screen/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseConfig.platformOptions
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

