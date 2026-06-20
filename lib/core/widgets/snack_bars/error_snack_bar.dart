import 'package:flutter/material.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '${context.tr(AppStrings.error)}: $message',
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
