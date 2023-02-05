import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:webscaletech_task/screens/home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpaceX Launches',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.deepPurpleAccent),
          displayMedium: TextStyle(color: Colors.orange),
          bodyMedium: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.pinkAccent),
          bodySmall: TextStyle(color: Colors.white),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}
