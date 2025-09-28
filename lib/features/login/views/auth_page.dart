import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/login_viewmodel.dart';
import '../viewmodels/register_viewmodel.dart';
import 'login_screen.dart';
import 'register_screen.dart';

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
                            transitionBuilder: (child, animation) {
                              final rotate = Tween(
                                begin: pi,
                                end: 0.0,
                              ).animate(animation);
                              return AnimatedBuilder(
                                animation: rotate,
                                child: child,
                                builder: (context, child) {
                                  final isUnder =
                                      (ValueKey(vm.isLoginMode) != child?.key);
                                  var tilt =
                                      ((animation.value - 0.5).abs() - 0.5) *
                                      0.003;
                                  tilt *= isUnder ? -1.0 : 1.0;

                                  final value = isUnder
                                      ? min(rotate.value, pi / 2)
                                      : rotate.value;

                                  return Transform(
                                    transform: Matrix4.rotationY(value)
                                      ..setEntry(3, 0, tilt),
                                    alignment: Alignment.center,
                                    child: child,
                                  );
                                },
                              );
                            },
                            child: vm.isLoginMode
                                ? ChangeNotifierProvider(
                                    create: (_) => LoginViewModel(),
                                    child: LoginScreen(
                                      key: const ValueKey(true),
                                      onToggleToRegister: vm.toggleMode,
                                    ),
                                  )
                                : ChangeNotifierProvider(
                                    create: (_) => RegisterViewModel(),
                                    child: RegisterScreen(
                                      key: const ValueKey(false),
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
