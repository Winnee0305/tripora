import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/auth/viewmodels/register_viewmodel.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/reusable_widgets/app_text_field.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/features/navigation/views/navigation_shell.dart';

class RegisterScreen extends StatelessWidget {
  final VoidCallback onToggleToLogin;

  const RegisterScreen({super.key, required this.onToggleToLogin});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();
    final containerHeight = MediaQuery.of(context).size.height * 0.64;

    return SizedBox(
      height: containerHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 34),

          // ----- Title -----
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Get Onboard.",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  "Create a new account",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: ManropeFontWeight.light,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // ----- Scrollable Fields -----
          SizedBox(
            height: containerHeight * 0.54,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  AppTextField(
                    label: "First Name",
                    onChanged: vm.setFirstName,
                    icon: CupertinoIcons.person_fill,
                    helperText: vm.firstnameMessage,
                    isValid: vm.isFirstNameValid,
                  ),
                  const SizedBox(height: 28),
                  AppTextField(
                    label: "Last Name",
                    onChanged: vm.setLastName,
                    icon: CupertinoIcons.person_2_fill,
                    helperText: vm.lastnameMessage,
                    isValid: vm.isLastNameValid,
                  ),
                  const SizedBox(height: 28),
                  AppTextField(
                    label: "Username",
                    onChanged: vm.setUsername,
                    icon: LucideIcons.atSign,
                    helperText: vm.usernameMessage,
                    isValid: vm.isUsernameValid,
                  ),
                  const SizedBox(height: 28),

                  AppTextField(
                    label: "Email Address",
                    onChanged: vm.setEmail,
                    icon: CupertinoIcons.mail_solid,
                    helperText: vm.emailMessage,
                    isValid: vm.isEmailValid,
                  ),
                  const SizedBox(height: 28),

                  AppTextField(
                    label: "Password",
                    obscureText: true,
                    onChanged: vm.setPassword,
                    icon: CupertinoIcons.lock_fill,
                    helperText: vm.passwordMessage,
                    isValid: vm.isPasswordValid,
                  ),
                  const SizedBox(height: 28),

                  AppTextField(
                    label: "Confirm Password",
                    obscureText: true,
                    onChanged: vm.setConfirmPassword,
                    icon: CupertinoIcons.lock_shield_fill,
                    helperText: vm.confirmPasswordMessage,
                    isValid: vm.isConfirmValid,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ----- Authentication Error Message -----
          if (vm.authError != null) ...[
            Text(
              vm.authError!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 6),

          // ----- Register Button -----
          AppButton.primary(
            onPressed: vm.isLoading
                ? null
                : () async {
                    final success = await vm.submitRegister();
                    if (success) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const NavigationShell(),
                        ),
                        (route) => false, // remove all previous routes
                      );
                    }
                  },
            text: vm.isLoading ? "Verifying..." : "Register",
            icon: vm.isLoading ? null : CupertinoIcons.person_badge_plus_fill,
          ),

          const SizedBox(height: 8),

          // ----- Login link -----
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: ManropeFontWeight.light,
                letterSpacing: 0,
              ),
              children: [
                const TextSpan(text: "Already have an account? "),
                TextSpan(
                  text: "Login Here.",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: ManropeFontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 0,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onToggleToLogin,
                ),
              ],
            ),
          ),

          const Spacer(),

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
