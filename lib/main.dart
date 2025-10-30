import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'screens/log_entry.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove 'const' here
      debugShowCheckedModeBanner: false,
      initialRoute: '/login_page',
      routes: {
        '/login_page': (context) => const LoginPage(),
        '/home_page': (context) => const HomePage(),
        '/log_entry': (context) => const QuickLogEntryPage(),
      },
    );
  }
}
