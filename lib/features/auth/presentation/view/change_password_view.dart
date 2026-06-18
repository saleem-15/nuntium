import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuntium/core/resources/app_assets.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'package:nuntium/core/utils/app_validator.dart';
import 'package:nuntium/core/widgets/app_back_button.dart';
import 'package:nuntium/core/widgets/custom_text_field.dart';
import 'package:nuntium/core/widgets/primary_button.dart';
import 'package:nuntium/features/auth/presentation/cubit/change_password_cubit.dart';
import 'package:nuntium/features/auth/presentation/cubit/change_password_state.dart';
import 'widgets/password_icon.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _repeatPasswordController;

  late final FocusNode _currentPasswordFocus;
  late final FocusNode _newPasswordFocus;
  late final FocusNode _repeatPasswordFocus;

  bool _isCurrentHidden = true;
  bool _isNewHidden = true;

  bool _isCurrentPasswordEmpty = true;
  bool _isNewPasswordEmpty = true;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _repeatPasswordController = TextEditingController();

    _currentPasswordFocus = FocusNode();
    _newPasswordFocus = FocusNode();
    _repeatPasswordFocus = FocusNode();

    _currentPasswordController.addListener(() {
      final isEmpty = _currentPasswordController.text.isEmpty;
      if (_isCurrentPasswordEmpty != isEmpty) {
        setState(() {
          _isCurrentPasswordEmpty = isEmpty;
        });
      }
    });

    _newPasswordController.addListener(() {
      final isEmpty = _newPasswordController.text.isEmpty;
      if (_isNewPasswordEmpty != isEmpty) {
        setState(() {
          _isNewPasswordEmpty = isEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();

    _currentPasswordFocus.dispose();
    _newPasswordFocus.dispose();
    _repeatPasswordFocus.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<ChangePasswordCubit>().updatePassword(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        } else if (state is ChangePasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Password updated successfully"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final isLoading = state is ChangePasswordLoading;

        return Scaffold(
          appBar: AppBar(
            leading: const AppBackButton(),
            title: Text(AppStrings.changePassword),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // 1. Current Password Field
                  CustomTextField(
                    controller: _currentPasswordController,
                    focusNode: _currentPasswordFocus,
                    hintText: AppStrings.currentPassword,
                    prefixIcon: AppIcons.lock,
                    isPassword: _isCurrentHidden,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_newPasswordFocus);
                    },
                    suffixIcon: PasswordIcon(
                      isPasswordEmpty: _isCurrentPasswordEmpty,
                      isPasswordHidden: _isCurrentHidden,
                      onPressed: () {
                        setState(() {
                          _isCurrentHidden = !_isCurrentHidden;
                        });
                      },
                    ),
                    validator: AppValidator.validatePassword,
                  ),

                  SizedBox(height: 16.h),

                  // 2. New Password Field
                  CustomTextField(
                    controller: _newPasswordController,
                    focusNode: _newPasswordFocus,
                    hintText: AppStrings.newPassword,
                    prefixIcon: AppIcons.lock,
                    isPassword: _isNewHidden,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_repeatPasswordFocus);
                    },
                    suffixIcon: PasswordIcon(
                      isPasswordEmpty: _isNewPasswordEmpty,
                      isPasswordHidden: _isNewHidden,
                      onPressed: () {
                        setState(() {
                          _isNewHidden = !_isNewHidden;
                        });
                      },
                    ),
                    validator: AppValidator.validatePassword,
                  ),

                  SizedBox(height: 16.h),

                  // 3. Repeat New Password Field
                  CustomTextField(
                    controller: _repeatPasswordController,
                    focusNode: _repeatPasswordFocus,
                    hintText: AppStrings.repeateNewPassword,
                    prefixIcon: AppIcons.lock,
                    isPassword: true,
                    validator: (value) => AppValidator.validateMatchPassword(
                      value,
                      _newPasswordController.text.trim(),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _onSubmit(context),
                  ),

                  SizedBox(height: 16.h),

                  PrimaryButton(
                    text: AppStrings.changePassword,
                    isLoading: isLoading,
                    onPressed: () => _onSubmit(context),
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
