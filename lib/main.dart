import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'home_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: "AIzaSyAg8lfBrHbFc6JR76unr7H52tfdVJ4ksew",
    authDomain: "workout-log-sync.firebaseapp.com",
    projectId: "workout-log-sync",
    storageBucket: "workout-log-sync.firebasestorage.app",
    messagingSenderId: "149427565389",
    appId: "1:149427565389:web:acfdc6b4514ca8e65a7d04",));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return const HomeScreen(); // placeholder for now
          }
          return const LoginScreen();
        },
      ),
    );
  }
}