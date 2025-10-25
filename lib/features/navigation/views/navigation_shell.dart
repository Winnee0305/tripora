import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_loading_page.dart';
import 'package:tripora/core/viewmodels/user_viewmodel.dart';
import 'package:tripora/features/navigation/viewmodels/navigation_viewmodel.dart';
import 'package:tripora/features/navigation/views/navigation_bar.dart';
import 'package:tripora/features/home/views/home_page.dart';
import 'package:tripora/features/chat/views/chat_page.dart';
import 'package:tripora/features/trip/views/trip_page.dart';
import 'package:tripora/features/search/views/search_page.dart';

class NavigationShell extends StatelessWidget {
  const NavigationShell({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NavigationViewModel>();
    final userVm = context.watch<UserViewModel>();

    final pages = const [HomePage(), SearchPage(), TripPage(), ChatPage()];

    if (userVm.user == null) {
      return const AppLoadingPage();
    } else {
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
}
