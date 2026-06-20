import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuntium/config/routes.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'package:nuntium/core/theme/app_colors.dart';
import 'package:nuntium/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:nuntium/features/auth/presentation/cubit/forget_password_state.dart';
import 'package:easy_localization/easy_localization.dart';

void showSuccessDialog(
  BuildContext context, {
  required String email,
  required ForgetPasswordCubit cubit,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return BlocProvider.value(
        value: cubit,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Icon
                Container(
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: AppColors.purplePrimary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mark_email_read_rounded,
                    size: 50.sp,
                    color: AppColors.purplePrimary,
                  ),
                ),
                SizedBox(height: 20.h),

                // 2. Title
                Text(
                  context.tr(AppStrings.checkYourMail),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),

                Text(
                  "${context.tr(AppStrings.emailSentDescription)}\n$email",
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),

                // 3. Back to Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purplePrimary,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.loginView,
                        (route) => false,
                      );
                    },
                    child: Text(
                      context.tr(AppStrings.doneBackToLogin),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                // 4. Resend Button with Timer (BlocBuilder)
                BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                  builder: (context, state) {
                    int seconds = 30;
                    bool isRunning = true;

                    if (state is ForgetPasswordSuccess) {
                      seconds = state.remainingSeconds;
                      isRunning = state.isTimerRunning;
                    }

                    return TextButton(
                      onPressed: isRunning
                          ? null
                          : () {
                              cubit.resendEmail(email);
                            },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 12.sp),
                          children: [
                            TextSpan(
                              text: isRunning
                                  ? "${context.tr(AppStrings.resendLink)} "
                                  : context.tr(AppStrings.resendLink),
                              style: TextStyle(
                                color: isRunning
                                    ? Colors.grey
                                    : AppColors.greyPrimary,
                              ),
                            ),
                            if (isRunning)
                              TextSpan(
                                text: "($seconds s)",
                                style: const TextStyle(
                                  color: AppColors.purplePrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
