import 'package:flutter/material.dart';
import 'package:masak_apa/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Masakuy',
      theme: ThemeData(
        fontFamily: 'Poppins'
      ),
      home: const Home(),
    );
  }
}

