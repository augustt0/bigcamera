import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'MainPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Big Camera',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.workSansTextTheme(
            Theme.of(context).textTheme,
          ),
      ),
      home: MainPage(),
    );
  }
}