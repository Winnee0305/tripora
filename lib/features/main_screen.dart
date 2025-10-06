import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/navigation/viewmodels/navigation_viewmodel.dart';
import 'package:tripora/features/navigation/views/navigation_shell.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigationViewModel(),
      child: const NavigationShell(),
    );
  }
}
