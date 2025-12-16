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
    final vm = context.watch<LoginViewModel>();

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        0,
        34,
        0,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ----- Title
          Text(
            "Welcome Back.",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            "Login to your account",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: ManropeFontWeight.light,
            ),
          ),

          const SizedBox(height: 30),

          // ----- Email
          AppTextField(
            label: "Email Address",
            icon: CupertinoIcons.mail_solid,
            onChanged: vm.setEmail,
            helperText: vm.emailMessage,
            isValid: vm.isEmailValid,
          ),

          const SizedBox(height: 28),

          // ----- Password
          AppTextField(
            label: "Password",
            icon: CupertinoIcons.lock_fill,
            obscureText: true,
            onChanged: vm.setPassword,
            helperText: vm.passwordMessage,
            isValid: vm.isPasswordValid,
          ),

          const SizedBox(height: 12),

          // ----- Forgot password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _showForgotPasswordDialog(context, vm),
              child: const Text("Forgot Password?"),
            ),
          ),

          const SizedBox(height: 16),

          // ----- Auth error
          if (vm.authError != null)
            Text(
              vm.generalErrorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),

          const SizedBox(height: 16),

          // ----- Login button
          AppButton.primary(
            onPressed: vm.isLoading
                ? null
                : () async {
                    await vm.submitLogin();
                  },
            text: vm.isLoading ? "Verifying..." : "Login",
            icon: vm.isLoading ? null : CupertinoIcons.arrow_right_circle_fill,
          ),

          const SizedBox(height: 16),

          // ----- Register link
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: ManropeFontWeight.light,
              ),
              children: [
                const TextSpan(text: "Don't have an account? "),
                TextSpan(
                  text: "Register Here.",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: ManropeFontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = onToggleToRegister,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ----- Footer
          Text(
            "Copyright © 2025 Tripora. All rights reserved.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: ManropeFontWeight.light,
            ),
          ),
        ],
      ),
    );
  }
}
