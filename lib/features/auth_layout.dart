import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/repositories/user_repository.dart';
import 'package:tripora/core/reusable_widgets/app_loading_page.dart';
import 'package:tripora/core/services/auth_service.dart';
import 'package:tripora/core/services/firestore_service.dart';
import 'package:tripora/features/auth/views/auth_page.dart';
import 'package:tripora/features/chat/viewmodels/chat_viewmodel.dart';
import 'package:tripora/features/home/viewmodels/home_viewmodel.dart';
import 'package:tripora/features/navigation/viewmodels/navigation_viewmodel.dart';
import 'package:tripora/features/navigation/views/navigation_shell.dart';
import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';

// class AuthLayout extends StatelessWidget {
//   const AuthLayout({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authService = context.watch<AuthService>();
//     final firestore = context.read<FirestoreService>();

//     return StreamBuilder<User?>(
//       stream: authService.authStateChanges,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           debugPrint('[AuthLayout] Waiting for auth state...');
//           return const AppLoadingPage();
//         }

//         if (snapshot.hasData) {
//           final user = snapshot.data!;
//           debugPrint('[AuthLayout] Logged in as: ${user.uid} (${user.email})');

//           final userRepo = UserRepository(firestore, user.uid);
//           debugPrint(
//             '[AuthLayout] Created UserRepository for uid: ${userRepo.uid}',
//           );

//           final userViewModel = UserViewModel(userRepo);
//           debugPrint(
//             '[AuthLayout] UserViewModel initialized. Loading user data...',
//           );
//           userViewModel.loadUser();

//           return MultiProvider(
//             providers: [
//               ChangeNotifierProvider.value(value: userViewModel),

//               ChangeNotifierProvider(create: (_) => NavigationViewModel()),
//               ChangeNotifierProvider(create: (_) => HomeViewModel()),
//               ChangeNotifierProvider(create: (_) => ChatViewModel()),
//             ],
//             child: const NavigationShell(),
//           );
//         }

//         debugPrint('[AuthLayout] No user logged in. Showing AuthPage.');
//         return const AuthPage();
//       },
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tripora/core/repositories/user_repository.dart';
// import 'package:tripora/core/reusable_widgets/app_loading_page.dart';
// import 'package:tripora/core/services/auth_service.dart';
// import 'package:tripora/core/services/firestore_service.dart';
// import 'package:tripora/features/auth/views/auth_page.dart';
// import 'package:tripora/features/navigation/views/navigation_shell.dart';
// import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, this.pageIfNotConnected});

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    final firestore = context.read<FirestoreService>();

    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            // --- Loading auth state ---
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoadingPage();
            }

            // --- User logged in ---
            if (snapshot.hasData) {
              final user = snapshot.data!;
              final userRepo = UserRepository(firestore, user.uid);

              return ChangeNotifierProvider<UserViewModel>(
                create: (_) {
                  final vm = UserViewModel(userRepo);
                  vm.loadUser(); // async, runs in background
                  return vm;
                },
                // ⬇️ Consumer handles the loading state
                child: Consumer<UserViewModel>(
                  builder: (context, vm, _) {
                    if (vm.isLoading || vm.user == null) {
                      return const AppLoadingPage();
                    }
                    return const NavigationShell();
                  },
                ),
              );
            }

            // --- No user logged in ---
            return pageIfNotConnected ?? const AuthPage();
          },
        );
      },
    );
  }
}
