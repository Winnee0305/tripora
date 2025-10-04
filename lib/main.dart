import 'package:flutter/material.dart';
import 'package:tripora/features/login/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'package:tripora/features/poi/views/poi_page.dart';
import 'features/home/views/home_page.dart';
import 'features/login/views/auth_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthViewModel())],
      child: const TriporaApp(),
    ),
  );
}

class TriporaApp extends StatelessWidget {
  const TriporaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tripora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routes: {
        // '/': (context) => const AuthPage(),
        // '/home': (context) => const HomePage(),
      },

      // home: const ThemePreviewPage(),
      // home: const AuthPage(),
      home: const HomePage(),
      // home: const PoiPage(),
    );
  }
}
