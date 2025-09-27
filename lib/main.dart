import 'package:flutter/material.dart';
import 'example/login_page.dart';
import 'example/home_screen.dart';
import 'package:tripora/features/login/views/login_page.dart';
import 'package:provider/provider.dart';
import 'features/login/viewmodels/login_viewmodel.dart';
import 'theme_preview.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LoginViewModel())],
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
      home: const LoginPage(), // 👈 Scaffold is now inside MaterialApp
      // home: const ThemePreviewPage(),
    );
  }
}
