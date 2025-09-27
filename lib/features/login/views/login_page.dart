import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/theme/text_style.dart';
import '../viewmodels/login_viewmodel.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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

          // ----- White curved container
          Align(
            alignment: Alignment.bottomCenter,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final containerHeight = screenHeight * 0.64;
                return Container(
                  height: containerHeight,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(300),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 32,
                  ),
                  // ----- Content
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            containerHeight -
                            64, // keep structure tall on big screens
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            // ----- Title
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Welcome Back.",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Login to your account",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: ManropeFontWeight.light,
                                          letterSpacing: 0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),

                            // ----- Email field
                            AppTextField(
                              label: "Email Address",
                              onChanged: vm.setEmail,
                              icon: Icons.email,
                            ),
                            const SizedBox(height: 24),

                            // ----- Password field
                            AppTextField(
                              label: "Password",
                              obscureText: true,
                              onChanged: vm.setPassword,
                              icon: Icons.lock,
                            ),

                            // ----- Forgot password button
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: vm.forgotPassword,
                                style: TextButton.styleFrom(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        decoration: TextDecoration.underline,
                                        fontWeight: ManropeFontWeight.light,
                                      ),
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                child: const Text("Forgot Password?"),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // ----- Login button
                            if (vm.isLoading)
                              const CircularProgressIndicator()
                            else
                              AppButton(
                                onPressed: vm.login,
                                text: "Login",
                                icon: Icons.login_rounded,
                              ),

                            const SizedBox(height: 14),

                            // ----- Register button
                            RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: ManropeFontWeight.light,
                                      letterSpacing: 0,
                                    ),
                                children: [
                                  const TextSpan(
                                    text: "Don't have an account? ",
                                  ),
                                  TextSpan(
                                    text: "Register Here.",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: ManropeFontWeight.bold,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          letterSpacing: 0,
                                        ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = vm.forgotPassword,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),

                            // ----- Copyright text
                            Text(
                              "Copyright © 2024 Tripora. All rights reserved.",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    fontWeight: ManropeFontWeight.light,
                                    letterSpacing: 0,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
