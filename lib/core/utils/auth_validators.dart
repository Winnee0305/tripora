class AuthValidators {
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
}
