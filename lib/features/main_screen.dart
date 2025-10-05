import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/navigation/viewmodels/navigation_viewmodel.dart';
import 'package:tripora/core/widgets/app_navigation_bar.dart';
import 'package:tripora/features/home/views/home_page.dart';
import 'package:tripora/features/chat/views/chat_page.dart';
import 'package:tripora/features/trip/views/trip_page.dart';
import 'package:tripora/features/profile/views/profile_page.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NavigationViewModel>();

    final pages = const [HomePage(), ChatPage(), TripPage(), ProfilePage()];

    return Scaffold(
      extendBody: true,
      body: pages[vm.currentIndex],
      bottomNavigationBar: AppNavigationBar(
        currentIndex: vm.currentIndex,
        onTap: vm.onTabSelected,
      ),
    );
  }
}
