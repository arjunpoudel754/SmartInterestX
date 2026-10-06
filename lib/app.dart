import 'package:flutter/material.dart';
import 'package:my_backend_app_2/screens/dashboard/dashboard_screen.dart';
import 'package:my_backend_app_2/screens/home/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartInterestX',
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}