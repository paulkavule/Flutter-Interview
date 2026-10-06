/// Pure form validators. Each returns an error message, or `null` when valid,
/// matching the [FormFieldValidator] contract.
abstract final class Validators {
  static final _name = RegExp(r"^[\p{L}][\p{L} '\-]*$", unicode: true);
  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
  static final _passwordRules = [
    RegExp('[A-Z]'),
    RegExp('[a-z]'),
    RegExp(r'\d'),
    RegExp(r'[^A-Za-z0-9]'),
  ];

  static String? name(String? value, {String field = 'Name'}) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return '$field is required';
    if (v.length < 2) return '$field is too short';
    if (!_name.hasMatch(v)) return '$field contains invalid characters';
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email is required';
    if (!_email.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  /// Requires 8+ characters mixing upper, lower, digit and symbol.
  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Use at least 8 characters';
    if (!_passwordRules.every(v.contains)) {
      return 'Mix upper & lower case, a number and a symbol';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != original) return 'Passwords do not match';
    return null;
  }

  static String? company(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Company name is required';
    if (v.length < 2) return 'Company name is too short';
    return null;
  }
}
