import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '/core/extensions/theme_extension.dart';
import '/core/resources/app_assets.dart';
import '/core/resources/app_strings.dart';
import '/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeSearchBar extends StatefulWidget {
  final Function(String)? onChanged;
  final void Function() onSearchPressed;
  final TextEditingController searchFieldController;

  const HomeSearchBar({
    super.key,
    this.onChanged,
    required this.onSearchPressed,
    required this.searchFieldController,
  });

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 56.h,
        decoration: BoxDecoration(
          color: AppColors.greyLighter,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            // تحديث اللون بناءً على الحالة في الكنترولر
            color: _isFocused ? AppColors.purplePrimary : Colors.transparent,
            width: 1.5.sp,
          ),
        ),
        child: TextField(
          onEditingComplete: () {
            widget.onSearchPressed.call();
            _focusNode.unfocus();
          },
          focusNode: _focusNode,
          controller: widget.searchFieldController,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: context.tr(AppStrings.search),
            hintStyle: context.body1.copyWith(color: AppColors.greyPrimary),
            prefixIcon: IconButton(
              padding: EdgeInsets.all(14.w),
              onPressed: () {
                widget.onSearchPressed.call();
                _focusNode.unfocus();
              },
              icon: SvgPicture.asset(
                AppIcons.search,
                colorFilter: ColorFilter.mode(
                  _isFocused ? AppColors.purplePrimary : AppColors.greyPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.all(14.w),
              child: SvgPicture.asset(AppIcons.microphone),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12.h),
          ),
        ),
      ),
    );
  }
}
