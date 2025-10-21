import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/auth/viewmodels/login_viewmodel.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/reusable_widgets/app_text_field.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/features/home/views/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/features/navigation/views/navigation_shell.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback onToggleToRegister;

  const LoginScreen({super.key, required this.onToggleToRegister});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>(); // observe VM
    final containerHeight = MediaQuery.of(context).size.height * 0.64;

    return SizedBox(
      height: containerHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 34),
          // ----- Title
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back.",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  "Login to your account",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: ManropeFontWeight.light,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // ----- Scrollable text fields + forgot password
          SizedBox(
            height: containerHeight * 0.54, // fixed height for scrollable area
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    label: "Email Address",
                    icon: CupertinoIcons.mail_solid,
                    onChanged: vm.setEmail,
                    helperText: vm.emailMessage,
                    isValid: vm.isEmailValid,
                  ),
                  const SizedBox(height: 28),

                  AppTextField(
                    label: "Password",
                    icon: CupertinoIcons.lock_fill,
                    obscureText: true,
                    onChanged: vm.setPassword,
                    helperText: vm.passwordMessage,
                    isValid: vm.isPasswordValid,
                  ),

                  const SizedBox(height: 12),
                  // Forgot password stays here, inside scroll
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: vm.forgotPassword,
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.titleLarge
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
                ],
              ),
            ),
          ),

          // ----- Authentication Error Message -----
          if (vm.authError != null) ...[
            Text(
              vm.generalErrorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 6),

          // ----- Login button
          // AppButton.primary(
          //   onPressed: vm.isLoading
          //       ? null
          //       : () async {
          //           final success = await vm.submitLogin();
          //           if (success) {
          //             Navigator.of(context).pushAndRemoveUntil(
          //               MaterialPageRoute(
          //                 builder: (_) => const NavigationShell(),
          //               ),
          //               (route) => false, // remove all previous routes
          //             );
          //           }
          //         },
          //   text: vm.isLoading ? "Verifying..." : "Login",
          //   icon: vm.isLoading ? null : CupertinoIcons.arrow_right_circle_fill,
          // ),
          AppButton.primary(
            onPressed: vm.isLoading
                ? null
                : () async {
                    final success = await vm.submitLogin();
                    if (success) {
                      // ✅ Don’t navigate manually
                      // AuthLayout will automatically detect and rebuild the correct UI
                      debugPrint(
                        '[LoginScreen] Login successful — waiting for AuthLayout to rebuild...',
                      );
                    }
                  },
            text: vm.isLoading ? "Verifying..." : "Login",
            icon: vm.isLoading ? null : CupertinoIcons.arrow_right_circle_fill,
          ),

          const SizedBox(height: 8),

          // ----- Register link
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: ManropeFontWeight.light,
                letterSpacing: 0,
              ),
              children: [
                const TextSpan(text: "Don't have an account? "),
                TextSpan(
                  text: "Register Here.",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: ManropeFontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 0,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = onToggleToRegister,
                ),
              ],
            ),
          ),

          const Spacer(),

          // ----- Footer
          Text(
            "Copyright © 2024 Tripora. All rights reserved.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: ManropeFontWeight.light,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
