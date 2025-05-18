class Validators {
  Validators._(); // Private constructor

  static String? notEmpty(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  static String? minLength(
    String? value,
    int minLength, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    if (value.trim().length < minLength) {
      return '$fieldName must be at least $minLength characters long.';
    }
    return null;
  }

  static String? maxLength(
    String? value,
    int maxLength, {
    String fieldName = 'This field',
  }) {
    if (value != null && value.trim().length > maxLength) {
      return '$fieldName cannot exceed $maxLength characters.';
    }
    return null;
  }

  static String? email(String? value, {String fieldName = 'Email'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    final emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Please enter a valid $fieldName address.';
    }
    return null;
  }

  static String? password(String? value, {String fieldName = 'Password'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }
    if (value.length < 6) {
      return '$fieldName must be at least 6 characters long.';
    }
    // We can add more password complexity rules here if needed:
    // if (!value.contains(RegExp(r'[A-Z]'))) {
    //   return '$fieldName must contain an uppercase letter.';
    // }
    // if (!value.contains(RegExp(r'[0-9]'))) {
    //   return '$fieldName must contain a number.';
    // }
    // if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    //   return '$fieldName must contain a special character.';
    // }
    return null;
  }

  static String? confirmPassword(
    String? password,
    String? confirmPassword, {
    String fieldName = 'Passwords',
  }) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password.';
    }
    if (password != confirmPassword) {
      return '$fieldName do not match.';
    }
    return null;
  }

  static String? phoneNumber(
    String? value, {
    String fieldName = 'Phone number',
    int minDigits = 10,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    final cleaned = value.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    ); // Remove non-digits
    if (cleaned.length < minDigits) {
      return 'Please enter a valid $fieldName.';
    }
    // Add more specific phone number regex if needed for a particular format/country
    return null;
  }

  static String? isNumber(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    if (double.tryParse(value.trim()) == null) {
      return '$fieldName must be a valid number.';
    }
    return null;
  }

  static String? isPositiveNumber(
    String? value, {
    String fieldName = 'This field',
    bool allowZero = false,
  }) {
    final notNumber = isNumber(value, fieldName: fieldName);
    if (notNumber != null) return notNumber;

    final number = double.parse(value!); // Already checked by isNumber
    if (allowZero ? number < 0 : number <= 0) {
      return '$fieldName must be a positive number${allowZero ? "" : " greater than zero"}.';
    }
    return null;
  }

  // Helper to combine multiple validators
  // Usage: validator: (value) => Validators.compose([
  //   (v) => Validators.notEmpty(v, fieldName: 'Your Field'),
  //   (v) => Validators.minLength(v, 5, fieldName: 'Your Field'),
  // ])(value),
  static String? Function(T?) compose<T>(
    List<String? Function(T?)> validators,
  ) {
    return (T? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }
}
