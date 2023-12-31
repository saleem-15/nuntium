import 'package:flutter/material.dart';
import 'package:nuntium/core/resorces/manager_colors.dart';
import 'package:nuntium/core/resorces/manager_fonts.dart';
import 'package:nuntium/core/resorces/manager_sizes.dart';

Padding rectButton({
  required void Function() onPressed,
  required String text,
  EdgeInsets? margin,
  bool isHasMargin = false,
}) {
  return Padding(
    padding: margin ?? EdgeInsets.zero,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ManagerColors.purplePrimary,
        minimumSize: Size(double.infinity, ManagerHeight.h56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(ManagerRadius.r12),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: ManagerFontSize.s16,
            color: ManagerColors.white,
            fontWeight: ManagerFontWeight.semi_bold,
            fontFamily: ManagerFontFamily.fontFamily),
      ),
    ),
  );
}
