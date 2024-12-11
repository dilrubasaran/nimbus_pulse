import 'package:flutter/material.dart';
import 'pages/dashboard_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Nunito Sans",
        scaffoldBackgroundColor: (Colors.white10),
      ),
      home: DashboardHome(),
    );
  }
}
