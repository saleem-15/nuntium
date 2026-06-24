import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:nuntium/core/constants/constanst.dart';
import 'package:nuntium/core/models/language.dart';

class LanguageConfig {
  const LanguageConfig._();

  static const List<Language> languages = [
    Language(langCode: Constants.englishKey, name: Constants.english),
    Language(langCode: Constants.arabicKey, name: Constants.arabic),
  ];

  static List<Locale> get supportedLocales =>
      languages.map((e) => Locale(e.langCode)).toList();

  static Locale get fallBackLocale => Locale(Constants.englishKey);

  // Text direction based on the current language
  static TextDirection getTextDirection(BuildContext context) {
    return context.locale.languageCode == Constants.arabicKey
        ? TextDirection.rtl
        : TextDirection.ltr;
  }
}
