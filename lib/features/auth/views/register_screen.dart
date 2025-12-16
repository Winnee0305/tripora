import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/auth/viewmodels/register_viewmodel.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/reusable_widgets/app_text_field.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/reusable_widgets/app_calendar_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/features/navigation/views/navigation_shell.dart';

class RegisterScreen extends StatelessWidget {
  final VoidCallback onToggleToLogin;

  const RegisterScreen({super.key, required this.onToggleToLogin});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
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
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ===== ONLY THIS PART SCROLLS =====
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(vertical: 4),
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
                  const SizedBox(height: 28),

                  // Gender
                  AppTextField(
                    label: "Gender",
                    text: vm.gender.isEmpty ? "" : _getGenderLabel(vm.gender),
                    readOnly: true,
                    chooseButton: true,
                    icon: CupertinoIcons.person_fill,
                    helperText: vm.genderMessage,
                    isValid: vm.isGenderValid,
                    onTap: () async {
                      final selected = await showModalBottomSheet<String>(
                        context: context,
                        builder: (_) => ListView(
                          padding: const EdgeInsets.all(20),
                          children: [
                            ListTile(
                              title: const Text('Male'),
                              onTap: () => Navigator.pop(context, 'male'),
                            ),
                            ListTile(
                              title: const Text('Female'),
                              onTap: () => Navigator.pop(context, 'female'),
                            ),
                            ListTile(
                              title: const Text('Other'),
                              onTap: () => Navigator.pop(context, 'other'),
                            ),
                          ],
                        ),
                      );
                      if (selected != null) vm.setGender(selected);
                    },
                  ),
                  const SizedBox(height: 28),

                  // DOB
                  AppTextField(
                    label: "Date of Birth",
                    text: vm.dateOfBirth == null
                        ? ""
                        : '${vm.dateOfBirth!.day}/${vm.dateOfBirth!.month}/${vm.dateOfBirth!.year}',
                    readOnly: true,
                    chooseButton: true,
                    icon: CupertinoIcons.calendar,
                    helperText: vm.dateOfBirthMessage,
                    isValid: vm.isDateOfBirthValid,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => AppCalendarPicker(
                          initialDate: vm.dateOfBirth ?? DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          title: "Select Date of Birth",
                          onDateSelected: vm.setDateOfBirth,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 28),

                  // Nationality
                  AppTextField(
                    label: "Nationality",
                    text: vm.nationality.isEmpty
                        ? ""
                        : _getNationalityLabel(vm.nationality),
                    readOnly: true,
                    chooseButton: true,
                    icon: CupertinoIcons.globe,
                    helperText: vm.nationalityMessage,
                    isValid: vm.isNationalityValid,
                    onTap: () async {
                      final selected = await showModalBottomSheet<String>(
                        context: context,
                        builder: (_) => ListView(
                          padding: const EdgeInsets.all(20),
                          children: [
                            ListTile(title: const Text('Malaysia'), onTap: () => Navigator.pop(context, 'MY')),
                            ListTile(title: const Text('Singapore'), onTap: () => Navigator.pop(context, 'SG')),
                            ListTile(title: const Text('Indonesia'), onTap: () => Navigator.pop(context, 'ID')),
                            ListTile(title: const Text('Thailand'), onTap: () => Navigator.pop(context, 'TH')),
                            ListTile(title: const Text('Philippines'), onTap: () => Navigator.pop(context, 'PH')),
                            ListTile(title: const Text('Vietnam'), onTap: () => Navigator.pop(context, 'VN')),
                            ListTile(title: const Text('Cambodia'), onTap: () => Navigator.pop(context, 'KH')),
                            ListTile(title: const Text('Laos'), onTap: () => Navigator.pop(context, 'LA')),
                            ListTile(title: const Text('Myanmar'), onTap: () => Navigator.pop(context, 'MM')),
                            ListTile(title: const Text('Brunei'), onTap: () => Navigator.pop(context, 'BN')),
                            ListTile(title: const Text('United States'), onTap: () => Navigator.pop(context, 'US')),
                            ListTile(title: const Text('United Kingdom'), onTap: () => Navigator.pop(context, 'GB')),
                            ListTile(title: const Text('Canada'), onTap: () => Navigator.pop(context, 'CA')),
                            ListTile(title: const Text('Australia'), onTap: () => Navigator.pop(context, 'AU')),
                            ListTile(title: const Text('China'), onTap: () => Navigator.pop(context, 'CN')),
                            ListTile(title: const Text('Japan'), onTap: () => Navigator.pop(context, 'JP')),
                            ListTile(title: const Text('India'), onTap: () => Navigator.pop(context, 'IN')),
                            ListTile(title: const Text('Germany'), onTap: () => Navigator.pop(context, 'DE')),
                            ListTile(title: const Text('France'), onTap: () => Navigator.pop(context, 'FR')),
                            ListTile(title: const Text('Other'), onTap: () => Navigator.pop(context, 'XX')),
                          ],
                        ),
                      );
                      if (selected != null) vm.setNationality(selected);
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ----- Error -----
          if (vm.authError != null)
            Text(
              vm.authError!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),

          const SizedBox(height: 8),

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
                        (_) => false,
                      );
                    }
                  },
            text: vm.isLoading ? "Verifying..." : "Register",
            icon: vm.isLoading ? null : CupertinoIcons.person_badge_plus_fill,
          ),

          const SizedBox(height: 8),

          // ----- Login Link -----
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: ManropeFontWeight.light,
              ),
              children: [
                const TextSpan(text: "Already have an account? "),
                TextSpan(
                  text: "Login Here.",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: ManropeFontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onToggleToLogin,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
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

  String _getGenderLabel(String genderValue) {
    const genders = {'male': 'Male', 'female': 'Female', 'other': 'Other'};
    return genders[genderValue] ?? '';
  }

  String _getNationalityLabel(String countryCode) {
    const countries = {
      'MY': 'Malaysia',
      'SG': 'Singapore',
      'ID': 'Indonesia',
      'TH': 'Thailand',
      'PH': 'Philippines',
      'VN': 'Vietnam',
      'KH': 'Cambodia',
      'LA': 'Laos',
      'MM': 'Myanmar',
      'BN': 'Brunei',
      'US': 'United States',
      'GB': 'United Kingdom',
      'CA': 'Canada',
      'AU': 'Australia',
      'CN': 'China',
      'JP': 'Japan',
      'IN': 'India',
      'DE': 'Germany',
      'FR': 'France',
      'XX': 'Other',
    };
    return countries[countryCode] ?? '';
  }
}
