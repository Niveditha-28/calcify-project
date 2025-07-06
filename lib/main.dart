import 'package:flutter/material.dart';
import 'views/home_page.dart';

import 'dart:async';

void main() {
  runZonedGuarded(() {
    runApp(calcify_app());
  }, (error, stack) {
    print('Caught Zone Error: $error');
  });
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

