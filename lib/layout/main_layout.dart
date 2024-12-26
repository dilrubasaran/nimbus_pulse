import 'package:flutter/material.dart';
import 'header.dart';
import 'sidebar.dart';

class MainLayout extends StatelessWidget {
  final Widget body;
  final String title;

  const MainLayout({
    Key? key,
    required this.body,
    this.title = 'Dashboard',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(),
          Expanded(
            child: Column(
              children: [
                Header(title: title),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
