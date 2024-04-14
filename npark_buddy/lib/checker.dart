class Checker {
  static bool checkPassword(String password) {
    // Password requirements
    // 1. Minimum 12 characters
    // 2. Must contain at least 1 uppercase
    // 3. Must contain at least 1 special character

    // Requirement 1: Minimum 12 characters
    if (password.length < 12) {
      return false;
    }

    // Requirement 2: Must contain at least 1 uppercase
    bool hasUppercase = false;
    for (int i = 0; i < password.length; i++) {
      if (password[i].toUpperCase() == password[i] && password[i].toLowerCase() != password[i]) {
        hasUppercase = true;
        break;
      }
    }
    if (!hasUppercase) {
      return false;
    }

    // Requirement 3: Must contain at least 1 special character
    List<String> specialCharacters = ['!', '@', '#', '\$', '%', '^', '&', '*'];
    bool hasSpecialCharacter = false;
    for (int i = 0; i < password.length; i++) {
      if (specialCharacters.contains(password[i])) {
        hasSpecialCharacter = true;
        break;
      }
    }
    if (!hasSpecialCharacter) {
      return false;
    }

    // If all requirements are met, return true
    return true;
  }

  
//email checker from gpt, might be buggy
  static bool checkEmail(String email) {
    // Regular expression for validating an email address
    // This regex might not cover all edge cases, but it's a basic one
    final RegExp emailRegex = RegExp(
        r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');

    // Check if the email matches the regular expression
    return emailRegex.hasMatch(email);
  }
}
