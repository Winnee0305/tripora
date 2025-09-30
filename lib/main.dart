import 'package:flutter/material.dart';
import 'package:tripora/features/login/viewmodels/auth_viewmodel.dart';
import 'example/login_page.dart';
import 'example/home_screen.dart';
import 'package:tripora/features/login/views/auth_page.dart';
import 'package:provider/provider.dart';
import 'features/login/viewmodels/login_viewmodel.dart';
import 'theme_preview.dart';
import 'core/theme/app_theme.dart';
import 'package:tripora/features/home/views/home_page.dart';

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
      // home: const AuthPage(),`
      home: const HomePage(),
    );
  }
}
