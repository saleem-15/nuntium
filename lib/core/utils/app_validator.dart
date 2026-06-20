import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import '../resources/app_strings.dart';

class AppValidator {
  AppValidator._();

  static String? validateEmail(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.tr(AppStrings.requiredField);
    }
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegex.hasMatch(value)) {
      return context.tr(AppStrings.invalidEmail);
    }
    return null;
  }

  static String? validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.tr(AppStrings.requiredField);
    }
    if (value.length < 6) {
      return context.tr(AppStrings.tooShort);
    }
    return null;
  }

  static String? validateMatchPassword(String? value, String password, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.tr(AppStrings.requiredField);
    }
    if (value != password) {
      return context.tr(AppStrings.passwordsDontMatch);
    }
    return null;
  }

  static String? validateName(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.tr(AppStrings.requiredField);
    }

    //Allows characters from all languages & spaces
    final nameRegExp = RegExp(r'^[\p{L}\s]+$', unicode: true);

    if (value.length < 3) {
      return context.tr(AppStrings.tooShort);
    } else if (value.length > 15) {
      return context.tr(AppStrings.usernameLengthError);
    } else if (!nameRegExp.hasMatch(value)) {
      return context.tr(AppStrings.usernameLettersError);
    }

    return null;
  }
}
