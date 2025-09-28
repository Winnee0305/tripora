import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/home/viewmodels/home_viewmodel.dart';
import 'home_page_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider is created first
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: const HomePageContent(),
    );
  }
}
