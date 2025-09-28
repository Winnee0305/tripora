import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/home/viewmodels/home_viewmodel.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'home_tabs.dart';
import 'package:tripora/core/widgets/app_navigation_bar.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              HomeHeader(),
              // Search
              HomeSearchBar(),

              // Tabs
              HomeTabs(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppNavigationBar(
        currentIndex: vm.currentIndex,
        onTap: (index) {
          vm.updateIndex(index);
        },
      ),
    );
  }
}
