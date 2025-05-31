import 'package:flutter/material.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'form_page.dart';
import 'data_input_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Belajar Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/form': (context) => FormPage(),
        '/data_input': (context) => DataInputPage(),
      },
    );
  }
}
