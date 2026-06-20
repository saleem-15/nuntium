import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

sealed class LanguageState extends Equatable {
  final Locale locale;

  const LanguageState(this.locale);

  @override
  List<Object?> get props => [locale];
}

class LanguageInitial extends LanguageState {
  const LanguageInitial(super.locale);
}

class LanguageChanged extends LanguageState {
  const LanguageChanged(super.locale);
}
