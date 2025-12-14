class AuthValidators {
  // ---- First Name ----
  static String? validateFirstName(String? firstName) {
    if (firstName == null || firstName.trim().isEmpty) {
      return 'First name cannot be empty';
    }
    if (firstName.trim().length < 2) {
      return 'First name must be at least 2 characters';
    }
    if (!RegExp(r"^[A-Za-zÀ-ÿ' -]+$").hasMatch(firstName.trim())) {
      return 'First name contains invalid characters';
    }
    return null; // ✅ valid
  }

  static bool isFirstNameValid(String firstName) =>
      validateFirstName(firstName) == null;

  // ---- Last Name ----
  static String? validateLastName(String? lastName) {
    if (lastName == null || lastName.trim().isEmpty) {
      return 'Last name cannot be empty';
    }
    if (lastName.trim().length < 2) {
      return 'Last name must be at least 2 characters';
    }
    if (!RegExp(r"^[A-Za-zÀ-ÿ' -]+$").hasMatch(lastName.trim())) {
      return 'Last name contains invalid characters';
    }
    return null; // ✅ valid
  }

  static bool isLastNameValid(String lastName) =>
      validateLastName(lastName) == null;

  // ---- Username ----
  static String? validateUsername(String? username) {
    if (username == null || username.trim().isEmpty) {
      return 'Username cannot be empty';
    }
    if (username.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null; // ✅ valid
  }

  static bool isUsernameValid(String username) =>
      validateUsername(username) == null;

  // ---- Email ----
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email cannot be empty';
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(email.trim())) {
      return 'Invalid email format';
    }
    return null;
  }

  static bool isEmailValid(String email) => validateEmail(email) == null;

  // ---- Password ----
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password cannot be empty';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static bool isPasswordValid(String password) =>
      validatePassword(password) == null;

  // ---- Confirm Password ----
  static String? validateConfirmPassword(String? password, String? confirm) {
    if (confirm == null || confirm.isEmpty) {
      return 'Please confirm your password';
    }
    if (confirm != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static bool isConfirmPasswordValid(String password, String confirm) =>
      validateConfirmPassword(password, confirm) == null;

  // ---- Gender ----
  static String? validateGender(String? gender) {
    if (gender == null || gender.trim().isEmpty) {
      return 'Please select a gender';
    }
    if (!['male', 'female', 'other'].contains(gender.toLowerCase())) {
      return 'Invalid gender selection';
    }
    return null;
  }

  static bool isGenderValid(String gender) => validateGender(gender) == null;

  // ---- Date of Birth ----
  static String? validateDateOfBirth(DateTime? dateOfBirth) {
    if (dateOfBirth == null) {
      return 'Please select your date of birth';
    }

    final now = DateTime.now();
    final age = now.year - dateOfBirth.year;

    if (age < 13) {
      return 'You must be at least 13 years old';
    }
    if (age > 120) {
      return 'Please enter a valid date of birth';
    }
    if (dateOfBirth.isAfter(now)) {
      return 'Date of birth cannot be in the future';
    }

    return null;
  }

  static bool isDateOfBirthValid(DateTime? dateOfBirth) =>
      validateDateOfBirth(dateOfBirth) == null;

  // ---- Nationality ----
  static String? validateNationality(String? nationality) {
    if (nationality == null || nationality.trim().isEmpty) {
      return 'Please select your nationality';
    }
    if (nationality.trim().length != 2) {
      return 'Invalid nationality code';
    }
    return null;
  }

  static bool isNationalityValid(String nationality) =>
      validateNationality(nationality) == null;
}
