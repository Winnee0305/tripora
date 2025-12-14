import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/models/user_data.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header.dart';
import 'package:tripora/core/reusable_widgets/app_text_field.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/reusable_widgets/app_calendar_picker.dart';
import 'package:tripora/core/reusable_widgets/app_loading_network_image.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/utils/auth_validators.dart';
import 'package:tripora/features/settings/viewmodels/settings_viewmodel.dart';
import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AccountPage extends StatefulWidget {
  final UserData user;
  final SettingsViewModel settingsViewModel;
  final UserViewModel userViewModel;

  const AccountPage({
    super.key,
    required this.user,
    required this.settingsViewModel,
    required this.userViewModel,
  });

  @override
  State<AccountPage> createState() =>
      _AccountPageState(user, settingsViewModel, userViewModel);
}

class _AccountPageState extends State<AccountPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  late String _selectedGender;
  late DateTime? _selectedDateOfBirth;
  late String _selectedNationality;

  bool _isEditing = false;
  bool _isSaving = false;
  late UserData _user;
  late SettingsViewModel _settingsVm;
  late UserViewModel _userVm;
  String? _validationError;

  _AccountPageState(
    UserData user,
    SettingsViewModel settingsVm,
    UserViewModel userVm,
  ) : _user = user,
      _settingsVm = settingsVm,
      _userVm = userVm;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController(text: _user.firstname);
    _lastNameController = TextEditingController(text: _user.lastname);
    _usernameController = TextEditingController(text: _user.username);
    _emailController = TextEditingController(text: _user.email);

    // Try to load from database if available
    _selectedGender = _user.gender ?? '';
    _selectedDateOfBirth = _user.dateOfBirth;
    _selectedNationality = _user.nationality ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);
    _validationError = null;

    try {
      // Validate fields
      final firstname = _firstNameController.text.trim();
      final lastname = _lastNameController.text.trim();
      final username = _usernameController.text.trim();

      final firstNameError = AuthValidators.validateFirstName(firstname);
      if (firstNameError != null) {
        setState(() {
          _validationError = firstNameError;
          _isSaving = false;
        });
        return;
      }

      final lastNameError = AuthValidators.validateLastName(lastname);
      if (lastNameError != null) {
        setState(() {
          _validationError = lastNameError;
          _isSaving = false;
        });
        return;
      }

      final usernameError = AuthValidators.validateUsername(username);
      if (usernameError != null) {
        setState(() {
          _validationError = usernameError;
          _isSaving = false;
        });
        return;
      }

      final genderError = AuthValidators.validateGender(_selectedGender);
      if (genderError != null) {
        setState(() {
          _validationError = genderError;
          _isSaving = false;
        });
        return;
      }

      final dateOfBirthError = AuthValidators.validateDateOfBirth(
        _selectedDateOfBirth,
      );
      if (dateOfBirthError != null) {
        setState(() {
          _validationError = dateOfBirthError;
          _isSaving = false;
        });
        return;
      }

      final nationalityError = AuthValidators.validateNationality(
        _selectedNationality,
      );
      if (nationalityError != null) {
        setState(() {
          _validationError = nationalityError;
          _isSaving = false;
        });
        return;
      }

      // All validations passed, save to database
      await _settingsVm.updateUserProfile(
        firstname: firstname,
        lastname: lastname,
        username: username,
        gender: _selectedGender,
        dateOfBirth: _selectedDateOfBirth,
        nationality: _selectedNationality,
      );

      // Reload user data
      await _userVm.loadUser(context);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        setState(() {
          _isEditing = false;
          _validationError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _cancelEdits() {
    _firstNameController.text = _user.firstname;
    _lastNameController.text = _user.lastname;
    _usernameController.text = _user.username;
    _emailController.text = _user.email;
    _selectedGender = _user.gender ?? '';
    _selectedDateOfBirth = _user.dateOfBirth;
    _selectedNationality = _user.nationality ?? '';

    setState(() => _isEditing = false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Sticky header
            AppStickyHeader(title: 'Account', showRightButton: false),
            const SizedBox(height: 22),

            // Content (scrollable)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: Column(
                  children: [
                    // First Name
                    AppTextField(
                      controller: _firstNameController,
                      label: "First Name",
                      icon: CupertinoIcons.person_fill,
                      readOnly: false,
                    ),
                    const SizedBox(height: 22),

                    // Last Name
                    AppTextField(
                      controller: _lastNameController,
                      label: "Last Name",
                      icon: CupertinoIcons.person_2_fill,
                      readOnly: false,
                    ),
                    const SizedBox(height: 22),

                    // Username
                    Opacity(
                      opacity: 0.6,
                      child: AppTextField(
                        controller: _usernameController,
                        label: "Username",
                        icon: LucideIcons.atSign,
                        readOnly: true,
                        helperText: "Username cannot be changed",
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Email (Read-only)
                    Opacity(
                      opacity: 0.6,
                      child: AppTextField(
                        controller: _emailController,
                        label: "Email Address",
                        icon: CupertinoIcons.mail_solid,
                        readOnly: true,
                        helperText: "Email cannot be changed",
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Gender Selection
                    AppTextField(
                      label: "Gender",
                      text: _selectedGender.isEmpty
                          ? ""
                          : _getGenderLabel(_selectedGender),
                      readOnly: true,
                      chooseButton: true,
                      icon: CupertinoIcons.person_fill,
                      onTap: () async {
                        const genders = [
                          {'label': 'Male', 'value': 'male'},
                          {'label': 'Female', 'value': 'female'},
                          {'label': 'Other', 'value': 'other'},
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
                          setState(() => _selectedGender = selected);
                        }
                      },
                    ),
                    const SizedBox(height: 22),

                    // Date of Birth
                    AppTextField(
                      label: "Date of Birth",
                      text: _selectedDateOfBirth != null
                          ? '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}'
                          : "",
                      readOnly: true,
                      chooseButton: true,
                      icon: CupertinoIcons.calendar,
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
                            initialDate:
                                _selectedDateOfBirth ??
                                DateTime.now().subtract(
                                  const Duration(days: 365 * 20),
                                ),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            title: "Select Date of Birth",
                            onDateSelected: (date) {
                              setState(() => _selectedDateOfBirth = date);
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 22),

                    // Nationality
                    AppTextField(
                      label: "Nationality",
                      text: _selectedNationality.isEmpty
                          ? ""
                          : _getNationalityLabel(_selectedNationality),
                      readOnly: true,
                      chooseButton: true,
                      icon: CupertinoIcons.globe,
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
                          setState(() => _selectedNationality = selected);
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Error message if validation failed
            if (_validationError != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    border: Border.all(color: Colors.red.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _validationError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            // Save button at the bottom
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 26.0,
              ),
              child: AppButton.primary(
                onPressed: _isSaving ? null : _saveChanges,
                text: _isSaving ? "Saving..." : "Save Changes",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
