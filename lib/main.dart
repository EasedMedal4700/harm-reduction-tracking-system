import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'screens/log_entry.dart';
import 'screens/analytics_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/catalog_page.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://grjukeipqjwcusmmirzw.supabase.co', // Your Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdyanVrZWlwcWp3Y3VzbW1pcnp3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkzMjU5NTgsImV4cCI6MjA3NDkwMTk1OH0.ovTstW0v7VHzx_Ua-Wcn2xGD6xVT7IB-v3CM0q_CjeE', // Your Supabase anon key
  );
  runApp(const MyApp());
}

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
        '/analytics': (context) => const AnalyticsPage(),
        '/catalog': (context) => const CatalogPage(),
      },
    );
  }
}
