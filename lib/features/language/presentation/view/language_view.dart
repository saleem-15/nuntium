import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'package:nuntium/core/localization/language_config.dart';
import 'package:nuntium/core/widgets/app_back_button.dart';
import 'package:nuntium/features/language/presentation/view/language_list_tile.dart';

class LanguageView extends StatelessWidget {
  const LanguageView({super.key});

  final languages = LanguageConfig.languages;

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr(AppStrings.language)),
        leading: const AppBackButton(),
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 20.w, left: 20.w),
        child: Column(
          children: [
            SizedBox(height: 32.h),
            ListView.builder(
              shrinkWrap: true,
              itemCount: languages.length,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemBuilder: (context, index) {
                final language = languages[index];
                final isCurrentLocale =
                    currentLocale.languageCode == language.langCode;
                return LanguageListTile(
                  language: language,
                  isCurrentLocale: isCurrentLocale,
                  onPressed: () => context.setLocale(Locale(language.langCode)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
