import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:nuntium/config/routes.dart';
import 'package:nuntium/core/extensions/theme_extension.dart';
import 'package:nuntium/core/resources/app_assets.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'package:nuntium/core/theme/app_fonts.dart';
import 'package:nuntium/core/utils/app_validator.dart';
import 'package:nuntium/core/widgets/custom_rich_text.dart';
import 'package:nuntium/core/widgets/custom_text_field.dart';
import 'package:nuntium/core/widgets/header.dart';
import 'package:nuntium/core/widgets/primary_button.dart';
import 'package:nuntium/core/widgets/scaffold_with_header.dart';
import 'package:nuntium/core/widgets/snack_bars/error_snack_bar.dart';
import 'package:nuntium/features/auth/presentation/cubit/login_cubit.dart';
import 'package:nuntium/features/auth/presentation/cubit/login_state.dart';
import 'package:nuntium/features/auth/presentation/view/widgets/password_icon.dart';
import 'package:nuntium/features/auth/presentation/view/widgets/social_button.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _formKey;

  bool _isPasswordHidden = true;
  bool _isPasswordEmpty = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null && !user.emailVerified) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.emailVerificationView,
              (route) => false,
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.mainView,
              (route) => false,
            );
          }
        } else if (state is LoginError) {
          showErrorSnackBar(context, state.message);
        }
      },
      child: ScaffoldWithHeader(
        header: Header(
          title: context.tr(AppStrings.loginTitle),
          subTtitle: context.tr(AppStrings.loginSubTitle),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
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
                suffixIcon: PasswordIcon(
                  isPasswordEmpty: _isPasswordEmpty,
                  isPasswordHidden: _isPasswordHidden,
                  onPressed: _togglePasswordVisibility,
                ),
                validator: (value) => AppValidator.validatePassword(value, context),
              ),

              SizedBox(height: 16.h),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.forgetPasswordView);
                  },
                  child: Text(
                    context.tr(AppStrings.forgotPassword),
                    style: context.body1.copyWith(fontWeight: AppFonts.medium),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return PrimaryButton(
                    text: context.tr(AppStrings.signIn),
                    isLoading: state is LoginLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<LoginCubit>().signIn(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      }
                    },
                  );
                },
              ),

              SizedBox(height: 48.h),

              Text(
                context.tr(AppStrings.or),
                style: context.body1.copyWith(fontWeight: AppFonts.semiBold),
              ),

              SizedBox(height: 48.h),

              SocialButton(
                text: context.tr(AppStrings.signInwithGoogle),
                icon: AppAssets.google,
                onPressed: () {
                  context.read<LoginCubit>().signInWithGoogle();
                },
              ),

              SizedBox(height: 16.h),

              SocialButton(
                text: context.tr(AppStrings.signInwithFacebook),
                icon: AppAssets.facebook,
                onPressed: () {
                  // Facebook sign-in isn't implemented in the remote datasource/controller code
                },
              ),

              SizedBox(height: 50.h),

              CustomRichText(
                firstText: context.tr(AppStrings.dontHaveAccount),
                secondText: context.tr(AppStrings.signUp),
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.signUpView);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
