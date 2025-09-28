import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/login_viewmodel.dart';
import '../viewmodels/register_viewmodel.dart';
import 'widgets/login_screen.dart';
import 'widgets/register_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const double whiteCurveRadius = 240.0;

    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(), // Single shared AuthViewModel
      child: Scaffold(
        body: Stack(
          children: [
            // ----- Background image
            Positioned.fill(
              child: Transform.scale(
                scale: 1.5,
                child: Transform.translate(
                  offset: Offset(screenHeight * 0.06, -screenHeight * 0.22),
                  child: Image.asset(
                    'assets/images/kl_towers.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
            // ----- Bottom container with screens
            Align(
              alignment: Alignment.bottomCenter,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Consumer<AuthViewModel>(
                    builder: (context, vm, _) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        height: screenHeight * 0.7,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: vm.isLoginMode
                              ? const BorderRadius.only(
                                  topRight: Radius.circular(whiteCurveRadius),
                                )
                              : const BorderRadius.only(
                                  topLeft: Radius.circular(whiteCurveRadius),
                                ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 32,
                        ),
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 600),
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeOut,
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: vm.isLoginMode
                                ? ChangeNotifierProvider(
                                    key: const ValueKey(true),
                                    create: (_) => LoginViewModel(),
                                    child: LoginScreen(
                                      onToggleToRegister: vm.toggleMode,
                                    ),
                                  )
                                : ChangeNotifierProvider(
                                    key: const ValueKey(false),
                                    create: (_) => RegisterViewModel(),
                                    child: RegisterScreen(
                                      onToggleToLogin: vm.toggleMode,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
