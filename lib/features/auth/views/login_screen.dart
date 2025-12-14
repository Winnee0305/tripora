import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/auth/viewmodels/login_viewmodel.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/reusable_widgets/app_text_field.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback onToggleToRegister;

  const LoginScreen({super.key, required this.onToggleToRegister});

  void _showForgotPasswordDialog(BuildContext context, LoginViewModel vm) {
    String resetEmail = '';
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Reset Password',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              AppTextField(
                label: 'Email Address',
                icon: CupertinoIcons.mail_solid,
                onChanged: (value) => resetEmail = value.trim(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading
                  ? null
                  : () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() => isLoading = true);

                      final result = await vm.sendPasswordResetEmail(
                        resetEmail,
                      );

                      setState(() => isLoading = false);

                      if (dialogContext.mounted) {
                        Navigator.of(dialogContext).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result['message']),
                            backgroundColor: result['success']
                                ? Colors.green
                                : Colors.red,
                            duration: const Duration(seconds: 4),
                          ),
                        );
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Send Reset Link'),
            ),
          ],
        ),
      ),
    );
  }

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
                      onPressed: () => _showForgotPasswordDialog(context, vm),
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
            "Copyright © 2025 Tripora. All rights reserved.",
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
