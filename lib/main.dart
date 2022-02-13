import 'package:flutter/material.dart';
import 'view/splashpage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Times New Roman',
        textTheme: const TextTheme(
        headline6: TextStyle(fontSize: 20.0),
        bodyText1: TextStyle(fontSize:12.0, fontFamily: 'Georgia', color: Colors.amberAccent),
        )
      ),
      title: 'TMJ',
      home: const Scaffold(
        body: SplashPage(),
        ),
    );
  }
}