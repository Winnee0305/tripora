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
                  SizedBox(height: 4),
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

                  // Gender Selection
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
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) {
                          const genders = [
                            {'label': 'Male', 'value': 'male'},
                            {'label': 'Female', 'value': 'female'},
                            {'label': 'Other', 'value': 'other'},
                          ];
                          return ListView(
                            padding: const EdgeInsets.all(20),
                            shrinkWrap: true,
                            children: genders.map((gender) {
                              return ListTile(
                                title: Text(gender['label']!),
                                onTap: () {
                                  Navigator.pop(context, gender['value']);
                                },
                              );
                            }).toList(),
                          );
                        },
                      );
                      if (selected != null) {
                        vm.setGender(selected);
                      }
                    },
                  ),
                  const SizedBox(height: 28),

                  // Date of Birth Selection
                  AppTextField(
                    label: "Date of Birth",
                    text: vm.dateOfBirth != null
                        ? '${vm.dateOfBirth!.day}/${vm.dateOfBirth!.month}/${vm.dateOfBirth!.year}'
                        : "",
                    readOnly: true,
                    chooseButton: true,
                    icon: CupertinoIcons.calendar,
                    helperText: vm.dateOfBirthMessage,
                    isValid: vm.isDateOfBirthValid,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        builder: (context) => AppCalendarPicker(
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

                  // Nationality Selection
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
                      const countries = [
                        {'label': 'Malaysia', 'value': 'MY'},
                        {'label': 'Singapore', 'value': 'SG'},
                        {'label': 'Indonesia', 'value': 'ID'},
                        {'label': 'Thailand', 'value': 'TH'},
                        {'label': 'Philippines', 'value': 'PH'},
                        {'label': 'Vietnam', 'value': 'VN'},
                        {'label': 'Cambodia', 'value': 'KH'},
                        {'label': 'Laos', 'value': 'LA'},
                        {'label': 'Myanmar', 'value': 'MM'},
                        {'label': 'Brunei', 'value': 'BN'},
                        {'label': 'United States', 'value': 'US'},
                        {'label': 'United Kingdom', 'value': 'GB'},
                        {'label': 'Canada', 'value': 'CA'},
                        {'label': 'Australia', 'value': 'AU'},
                        {'label': 'China', 'value': 'CN'},
                        {'label': 'Japan', 'value': 'JP'},
                        {'label': 'India', 'value': 'IN'},
                        {'label': 'Germany', 'value': 'DE'},
                        {'label': 'France', 'value': 'FR'},
                        {'label': 'Other', 'value': 'XX'},
                      ];
                      final selected = await showModalBottomSheet<String>(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) {
                          return ListView(
                            padding: const EdgeInsets.all(20),
                            shrinkWrap: true,
                            children: countries.map((country) {
                              return ListTile(
                                title: Text(country['label']!),
                                onTap: () {
                                  Navigator.pop(context, country['value']);
                                },
                              );
                            }).toList(),
                          );
                        },
                      );
                      if (selected != null) {
                        vm.setNationality(selected);
                      }
                    },
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
