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
import 'package:nuntium/core/widgets/scaffold_with_header.dart';
import 'package:nuntium/core/widgets/snack_bars/error_snack_bar.dart';
import 'package:nuntium/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:nuntium/features/auth/presentation/cubit/sign_up_state.dart';
import 'package:nuntium/features/auth/presentation/view/widgets/password_icon.dart';
import 'package:easy_localization/easy_localization.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  late final TextEditingController _userNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _repeatPasswordController;
  late final GlobalKey<FormState> _formKey;

  bool _isPasswordHidden = true;
  bool _isPasswordEmpty = true;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    _formKey = GlobalKey<FormState>();

    _passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    final isEmpty = _passwordController.text.isEmpty;
    if (_isPasswordEmpty != isEmpty) {
      setState(() {
        _isPasswordEmpty = isEmpty;
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void _onSignUpPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<SignUpCubit>().signUp(
        email: _emailController.text,
        password: _passwordController.text,
        name: _userNameController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.emailVerificationView,
            (route) => false,
          );
        } else if (state is SignUpError) {
          showErrorSnackBar(context, state.message);
        }
      },
      child: ScaffoldWithHeader(
        header: Header(
          title: context.tr(AppStrings.signUpTitle),
          subTtitle: context.tr(AppStrings.signUpSubTitle),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 32.h),

              //User Name Field
              CustomTextField(
                controller: _userNameController,
                hintText: context.tr(AppStrings.userName),
                prefixIcon: AppIcons.user,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: (value) => AppValidator.validateName(value, context),
              ),

              SizedBox(height: 16.h),

              //Email Field
              CustomTextField(
                controller: _emailController,
                hintText: context.tr(AppStrings.emailAdress),
                prefixIcon: AppIcons.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) => AppValidator.validateEmail(value, context),
              ),

              SizedBox(height: 16.h),

              //Password Field
              CustomTextField(
                controller: _passwordController,
                hintText: context.tr(AppStrings.password),
                prefixIcon: AppIcons.lock,
                isPassword: _isPasswordHidden,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                textInputAction: TextInputAction.next,
                suffixIcon: PasswordIcon(
                  isPasswordEmpty: _isPasswordEmpty,
                  isPasswordHidden: _isPasswordHidden,
                  onPressed: _togglePasswordVisibility,
                ),
                validator: (value) => AppValidator.validatePassword(value, context),
              ),

              SizedBox(height: 16.h),

              //Repeat Password Field
              CustomTextField(
                controller: _repeatPasswordController,
                hintText: context.tr(AppStrings.repeatPassword),
                prefixIcon: AppIcons.lock,
                isPassword: true,
                textInputAction: TextInputAction.done,
                validator: (value) => AppValidator.validateMatchPassword(
                  value, _passwordController.text.trim(), context,
                ),
              ),

              SizedBox(height: 24.h),

              BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
                  return PrimaryButton(
                    text: context.tr(AppStrings.signUp),
                    isLoading: state is SignUpLoading,
                    onPressed: _onSignUpPressed,
                  );
                },
              ),

              SizedBox(height: 150.h),

              CustomRichText(
                firstText: context.tr(AppStrings.haveAnAccount),
                secondText: context.tr(AppStrings.signIn),
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.loginView);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
