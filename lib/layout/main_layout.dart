import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'header.dart';

class MainLayout extends StatelessWidget {
  final Widget body; // Dinamik olarak içeriği değiştirmek için

  const MainLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(), // Header bileşeni
      body: Row(
        children: [
          Sidebar(), // Sidebar bileşeni
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: body, // Ana içerik
            ),
          ),
        ],
      ),
    );
  }
}
