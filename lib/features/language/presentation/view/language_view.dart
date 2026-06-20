import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nuntium/config/dependency_injection.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'package:nuntium/core/widgets/app_back_button.dart';
import 'package:nuntium/features/language/presentation/cubit/language_cubit.dart';
import 'package:nuntium/features/language/presentation/cubit/language_state.dart';
import 'package:nuntium/features/language/presentation/view/language_list_tile.dart';

class LanguageView extends StatelessWidget {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LanguageCubit>(
      create: (context) => getIt<LanguageCubit>(),
      child: BlocListener<LanguageCubit, LanguageState>(
        listener: (context, state) {
          if (state is LanguageChanged) {
            context.setLocale(state.locale);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.language),
            leading: const AppBackButton(),
          ),
          body: Padding(
            padding: EdgeInsets.only(right: 20.w, left: 20.w),
            child: Column(
              children: [
                SizedBox(height: 32.h),
                BlocBuilder<LanguageCubit, LanguageState>(
                  builder: (context, state) {
                    final cubit = context.read<LanguageCubit>();
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: cubit.languages.length,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemBuilder: (context, index) {
                        final language = cubit.languages[index];
                        final isCurrentLocale =
                            state.locale.languageCode == language.langCode;
                        return LanguageListTile(
                          language: language,
                          isCurrentLocale: isCurrentLocale,
                          onPressed: () =>
                              cubit.changeLanguage(language.langCode),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
