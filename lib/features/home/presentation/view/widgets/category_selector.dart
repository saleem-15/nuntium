import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuntium/core/theme/app_colors.dart';
import 'package:nuntium/core/theme/app_fonts.dart';

import '../../../../categories/domain/entities/category_entity.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';
import '../../bloc/home_state.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      // Only rebuild the list if categories change (which is rare, but good for performance)
      buildWhen: (previous, current) => previous.categories != current.categories,
      builder: (context, state) {
        if (state.categories.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 34.h,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            itemBuilder: (_, index) {
              final category = state.categories[index];
              final isLastItem = index == state.categories.length - 1;
              return Padding(
                padding: EdgeInsetsDirectional.only(end: isLastItem ? 0 : 16.w),
                child: _CategoryItem(category: category),
              );
            },
          ),
        );
      },
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category});
  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      // Fast selective rebuild: only trigger if THIS specific item needs to highlight/unhighlight
      buildWhen: (previous, current) =>
          previous.selectedCategory?.id == category.id ||
          current.selectedCategory?.id == category.id,
      builder: (context, state) {
        final isSelected = state.selectedCategory?.id == category.id;
        return GestureDetector(
          onTap: () {
            context.read<HomeBloc>().add(HomeCategoryChanged(category: category));
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.purplePrimary : AppColors.greyLighter,
              borderRadius: BorderRadius.circular(20.r),
            ),
            alignment: Alignment.center,
            child: Text(
              tr(category.name),
              style: TextStyle(
                fontSize: 12.sp,
                color: isSelected ? AppColors.white : AppColors.greyPrimary,
                fontWeight: AppFonts.semiBold,
              ),
            ),
          ),
        );
      },
    );
  }
}
