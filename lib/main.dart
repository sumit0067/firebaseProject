import 'package:flutter/material.dart';
import 'screen/HomePage.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Cafe Code",
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.redAccent,
        accentColor: Colors.blue,
      ),

    ),
  );
}
