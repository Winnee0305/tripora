import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/login_button.dart';
import '../../../core/widgets/app_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTextField(label: "Email", onChanged: vm.setEmail),
            const SizedBox(height: 12),
            AppTextField(
              label: "Password",
              obscureText: true,
              onChanged: vm.setPassword,
            ),
            const SizedBox(height: 24),

            if (vm.isLoading)
              const CircularProgressIndicator()
            else
              LoginButton(onPressed: vm.login),

            TextButton(
              onPressed: vm.forgotPassword,
              child: const Text("Forgot Password?"),
            ),
          ],
        ),
      ),
    );
  }
}
