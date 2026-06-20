import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuntium/config/routes.dart';
import 'package:nuntium/core/resources/app_assets.dart';
import 'package:nuntium/core/extensions/theme_extension.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'package:nuntium/core/widgets/primary_button.dart';
import 'package:easy_localization/easy_localization.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 170.h),
          Image.asset(
            AppAssets.illustration,
            fit: BoxFit.fitWidth,
            width: double.infinity,
          ),
          SizedBox(height: 60.h),
          Text(
            context.tr(AppStrings.nuntium),
            style: context.headline1.copyWith(fontSize: 34.sp),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: 260.w,
            child: Text(
              context.tr(AppStrings.welcomeBody),
              textAlign: TextAlign.center,
              style: context.body1,
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 20.w, left: 20.w, bottom: 35.h),
            child: PrimaryButton(
              text: context.tr(AppStrings.getStarted),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.loginView,
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
