import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuntium/core/services/language_service.dart';
import 'package:nuntium/features/language/model/language.dart';
import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final LanguageService _languageService;

  final List<Language> languages = LanguageService.supportedLanguages.entries
      .map((e) => Language(langCode: e.key, name: e.value))
      .toList();

  LanguageCubit(this._languageService)
      : super(LanguageInitial(_languageService.currentLocale));

  Future<void> changeLanguage(String langCode) async {
    await _languageService.saveLanguage(langCode);
    emit(LanguageChanged(Locale(langCode)));
  }
}
