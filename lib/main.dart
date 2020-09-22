import 'package:flutter/material.dart';
import 'views/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Address Book',
      theme: ThemeData(
        primaryColor: Colors.teal[900],
      ),
      home: HomePage(),
    );
  }
}
