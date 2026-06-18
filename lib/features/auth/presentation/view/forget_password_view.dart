import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuntium/config/routes.dart';
import 'package:nuntium/core/resources/app_assets.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'package:nuntium/core/utils/app_validator.dart';
import 'package:nuntium/core/widgets/custom_rich_text.dart';
import 'package:nuntium/core/widgets/custom_text_field.dart';
import 'package:nuntium/core/widgets/header.dart';
import 'package:nuntium/core/widgets/primary_button.dart';
import 'package:nuntium/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:nuntium/features/auth/presentation/cubit/forget_password_state.dart';
import 'widgets/email_link_is_sent_dialog.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onNextPressed(BuildContext context) {
    final email = _emailController.text.trim();
    final validateEmail = AppValidator.validateEmail(email);

    if (validateEmail != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validateEmail),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    context.read<ForgetPasswordCubit>().sendPasswordResetEmail(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        } else if (state is ForgetPasswordSuccess) {
          // If the timer is at 30, it means it's the initial success emit,
          // so we show the success dialog. We only show the dialog once.
          if (state.remainingSeconds == 30) {
            showSuccessDialog(
              context,
              email: state.email,
              cubit: context.read<ForgetPasswordCubit>(),
            );
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is ForgetPasswordLoading;

        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h, right: 20.w, left: 20.w),
              child: Column(
                children: [
                  Header(
                    title: AppStrings.forgetPasswordTitle,
                    subTtitle: AppStrings.forgetPasswordSubTitle,
                  ),
                  //Email Field
                  CustomTextField(
                    controller: _emailController,
                    hintText: AppStrings.emailAdress,
                    prefixIcon: AppIcons.email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),

                  SizedBox(height: 16.h),

                  PrimaryButton(
                    text: AppStrings.next,
                    isLoading: isLoading,
                    onPressed: () => _onNextPressed(context),
                  ),

                  const Spacer(),

                  CustomRichText(
                    firstText: AppStrings.remmeberPassword,
                    secondText: AppStrings.tryAgain,
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.loginView,
                        (route) => false,
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
}
