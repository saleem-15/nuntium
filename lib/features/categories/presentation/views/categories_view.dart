import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuntium/core/extensions/theme_extension.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'package:nuntium/core/theme/app_colors.dart';
import 'package:nuntium/core/theme/app_fonts.dart';
import 'package:nuntium/core/widgets/header.dart';
import 'package:nuntium/features/categories/domain/entities/category_entity.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/categories_state.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Header(
                title: AppStrings.categoriesPageTitle,
                subTtitle: AppStrings.categoriesPageSubTitle,
              ),
              BlocBuilder<CategoriesCubit, CategoriesState>(
                builder: (context, state) {
                  return switch (state) {
                    CategoriesInitial() || CategoriesLoading() => const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.purplePrimary,
                        ),
                      ),
                    CategoriesError(message: final msg) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              msg,
                              style: context.body1.copyWith(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<CategoriesCubit>()
                                  .fetchCategories(),
                              child: Text(AppStrings.retry),
                            ),
                          ],
                        ),
                      ),
                    CategoriesLoaded(categories: final categories) =>
                      categories.isEmpty
                          ? Center(
                              child: Text(
                                'No categories found',
                                style: context.body1,
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: categories.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16.w,
                                crossAxisSpacing: 16.w,
                                childAspectRatio: 2.5,
                              ),
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                return categoryItem(category, context);
                              },
                            ),
                  };
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryItem(CategoryEntity category, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle category selection or details page navigation if needed in the future
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: AppColors.greyLighter,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          tr(category.name),
          style: context.body1.copyWith(
            color: AppColors.greyDarker,
            fontWeight: AppFonts.semiBold,
          ),
        ),
      ),
    );
  }
}
