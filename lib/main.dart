import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:portfoliobuilderslms/admin/dashboard.dart';
import 'package:portfoliobuilderslms/firebase_options.dart';
import 'package:portfoliobuilderslms/login.dart';
import 'package:portfoliobuilderslms/user/videosection.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    
      home: LoginPage(),
    );
  }
}

