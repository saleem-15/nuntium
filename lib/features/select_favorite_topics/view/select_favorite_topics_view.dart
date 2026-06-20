import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuntium/config/routes.dart';
import 'package:nuntium/core/extensions/theme_extension.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'package:nuntium/core/theme/app_colors.dart';
import 'package:nuntium/core/theme/app_fonts.dart';
import 'package:nuntium/core/widgets/primary_button.dart';
import 'package:nuntium/features/select_favorite_topics/cubit/select_favorite_topics_cubit.dart';
import 'package:nuntium/features/select_favorite_topics/cubit/select_favorite_topics_state.dart';
import 'package:easy_localization/easy_localization.dart';

class SelectFavoriteTopics extends StatelessWidget {
  const SelectFavoriteTopics({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SelectFavoriteTopicsCubit>();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 72.h),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                context.tr(AppStrings.selectFavoriteTopicsTitle),
                style: context.headline1,
                textAlign: TextAlign.left,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              context.tr(AppStrings.selectFavoriteTopicsSubTitle),
              style: context.body1,
            ),

            SizedBox(height: 32.h),

            GridView.builder(
              shrinkWrap: true,
              itemCount: cubit.topics.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.w, // مسافة عمودية بين كل عنصر
                crossAxisSpacing: 16.w, // مسافة أفقية بين كل عنصر
                childAspectRatio:
                    2.5, // للتحكم في ارتفاع المربع بالنسبة لعرضه
              ),

              itemBuilder: (context, index) {
                final topic = cubit.topics[index];

                return GestureDetector(
                  onTap: () => cubit.toggleTopic(topic),
                  child: BlocBuilder<SelectFavoriteTopicsCubit, SelectFavoriteTopicsState>(
                    builder: (context, state) {
                      final isSelected = state.selectedTopics.contains(topic);
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.purplePrimary
                              : AppColors.greyLighter,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                            context.tr(topic),
                            style: context.body1.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.greyDarker,
                            fontWeight: AppFonts.semiBold,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            SizedBox(height: 16.h),

            PrimaryButton(
              text: context.tr(AppStrings.next),
              onPressed: () => Navigator.pushReplacementNamed(context, Routes.homeView),
            ),
          ],
        ),
      ),
    );
  }
}
