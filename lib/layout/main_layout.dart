import 'package:flutter/material.dart';
import 'package:nimbus_pulse/layout/header.dart';
import 'package:nimbus_pulse/layout/sidebar.dart';
import '../styles/consts.dart';

class MainLayout extends StatelessWidget {
  final Widget body;

  const MainLayout({
    Key? key,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgSecondaryColor,
        body: Row(
          children: [
            Sidebar(currentRoute: ModalRoute.of(context)?.settings.name ?? ''),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
