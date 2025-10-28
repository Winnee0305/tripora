import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/repositories/trip_repository.dart';
import 'package:tripora/core/repositories/user_repository.dart';
import 'package:tripora/core/reusable_widgets/app_loading_page.dart';
import 'package:tripora/core/services/auth_service.dart';
import 'package:tripora/core/services/firestore_service.dart';
import 'package:tripora/features/auth/views/auth_page.dart';
import 'package:tripora/features/navigation/views/navigation_shell.dart';
import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';
import 'package:tripora/features/trip/viewmodels/trip_viewmodel.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key});

  // final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    final firestore = context.read<FirestoreService>();

    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authServiceValue, child) {
        return StreamBuilder(
          stream: authServiceValue.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            debugPrint('🔁 Auth state changed: ${snapshot.data}');
            // --- Loading auth state ---
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = const AppLoadingPage();
            }
            // --- User logged in ---
            else if (snapshot.hasData) {
              final user = snapshot.data!;
              final userRepo = UserRepository(firestore, user.uid);
              final tripRepo = TripRepository(firestore, user.uid);

              widget = MultiProvider(
                providers: [
                  ChangeNotifierProvider<UserViewModel>(
                    create: (_) {
                      final vm = UserViewModel(userRepo);
                      vm.loadUser();
                      return vm;
                    },
                  ),
                  ChangeNotifierProvider<TripViewModel>(
                    create: (_) {
                      final vm = TripViewModel(tripRepo);
                      vm.loadTrips();
                      return vm;
                    },
                  ),
                ],
                child: const NavigationShell(),
              );
            } else {
              debugPrint("returning AuthPage");
              // --- No user logged in ---
              widget = const AuthPage();
            }
            return widget;
          },
        );
      },
    );
  }
}
