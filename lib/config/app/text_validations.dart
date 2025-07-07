import 'package:paz1dv/config/gen/app_localizations.dart';

class TextValidations {
  // Email validation
  static String? validateEmail(String? value, AppLocalizations localizations) {
    if (value == null || value.trim().isEmpty) {
      return localizations.errorEmailRequired;
    }

    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return localizations.errorInvalidEmail;
    }

    return null;
  }

  // Subject validation (optional but if provided, should have minimum length)
  static String? validateSubject(
    String? value,
    AppLocalizations localizations,
  ) {
    if (value == null || value.isEmpty)
      return localizations.errorSubjectTooShort;

    if (value.trim().isNotEmpty && value.trim().length < 5) {
      return localizations.errorSubjectTooShort;
    }
    return null;
  }

  // Message validation
  static String? validateMessage(
    String? value,
    AppLocalizations localizations,
  ) {
    if (value == null || value.trim().isEmpty) {
      return localizations.errorMessageRequired;
    }

    if (value.trim().length < 10) {
      return localizations.errorMessageTooShort;
    }

    if (value.trim().length > 1000) {
      return localizations.errorMessageTooLong;
    }

    return null;
  }

  // Helper method to check if all validations pass
  static bool areAllFieldsValid({
    required String email,
    String? subject,
    required String message,
    required AppLocalizations localizations,
  }) {
    return validateEmail(email, localizations) == null &&
        validateSubject(subject, localizations) == null &&
        validateMessage(message, localizations) == null;
  }
}
