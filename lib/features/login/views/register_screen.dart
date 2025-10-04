import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/login/viewmodels/register_viewmodel.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/widgets/app_text_field.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';

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

          // ----- Title (fixed)
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

          // ----- Scrollable fields
          SizedBox(
            height: containerHeight * 0.54,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  AppTextField(
                    label: "Username",
                    onChanged: vm.setUsername,
                    icon: CupertinoIcons.person_fill,
                  ),
                  const SizedBox(height: 28),
                  AppTextField(
                    label: "Email Address",
                    onChanged: vm.setEmail,
                    icon: CupertinoIcons.mail_solid,
                  ),
                  const SizedBox(height: 28),
                  AppTextField(
                    label: "Password",
                    obscureText: true,
                    onChanged: vm.setPassword,
                    icon: CupertinoIcons.lock_fill,
                  ),
                  const SizedBox(height: 28),
                  AppTextField(
                    label: "Confirm Password",
                    obscureText: true,
                    onChanged: vm.setConfirmPassword,
                    icon: CupertinoIcons.lock_shield_fill,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ----- Register button (fixed)
          AppButton.primary(
            onPressed: vm.isLoading
                ? null
                : () {
                    vm.register();
                  },
            text: "Register",
            icon: CupertinoIcons.person_badge_plus_fill,
          ),
          const SizedBox(height: 8),

          // ----- Login link (fixed)
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

          // ----- Footer (fixed)
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
