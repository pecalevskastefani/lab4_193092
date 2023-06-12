import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lab4_193092/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions( apiKey: "AIzaSyBf7JJxgPbWQU1N77stEIyv4zzleK8w4ZE",
    appId: "1:269635080180:android:010b3ae77767e5401173a1",
      messagingSenderId: "269635080180",
      projectId: "app4-4fc7b", ), );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: MyHomePage(),
    );
  }
}



