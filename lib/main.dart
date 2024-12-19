import 'package:flutter/material.dart';
import 'navigation/route_generator.dart';

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
      initialRoute: '/dashboard', // Varsayılan olarak Dashboard açılır
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
