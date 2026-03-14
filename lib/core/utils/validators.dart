/// Email regex pattern matching standard email format.
final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');

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
