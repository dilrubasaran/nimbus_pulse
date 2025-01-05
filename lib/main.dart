import 'package:flutter/material.dart';
import 'package:nimbus_pulse/navigation/route_generator.dart';
import 'package:provider/provider.dart';
import 'package:nimbus_pulse/providers/theme_provider.dart';
import 'package:nimbus_pulse/core/theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Nimbus Pulse',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: '/login',
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}
