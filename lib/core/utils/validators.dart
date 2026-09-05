/// Email regex pattern matching standard email format.
final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$');

/// Validates an email address format.
/// Returns null if valid, error message if invalid.
String? validateEmail(
  String? value, {
  required String emptyError,
  required String invalidError,
}) {
  if (value == null || value.trim().isEmpty) return emptyError;
  if (!emailRegex.hasMatch(value.trim())) return invalidError;
  return null;
}

/// Validates a password: present and at least six characters.
/// Returns null if valid, error message if invalid.
String? validatePassword(
  String? value, {
  required String emptyError,
  required String shortError,
}) {
  if (value == null || value.isEmpty) return emptyError;
  if (value.length < 6) return shortError;
  return null;
}
