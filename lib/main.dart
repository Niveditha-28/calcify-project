import 'package:flutter/material.dart';
import 'views/home_page.dart';

void main() {
  runApp(calcify_app());
}

class calcify_app extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calcify',
      home: HomePage(),
    );
  }
}
