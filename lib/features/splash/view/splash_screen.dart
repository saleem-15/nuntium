import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nuntium/config/routes.dart';
import 'package:nuntium/core/resources/app_assets.dart';
import 'package:nuntium/core/theme/app_colors.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        switch (state) {
          case SplashInitial():
            break; // Do nothing for initial state

          case SplashNavigateToOnboarding():
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.onBoardingView,
              (route) => false,
            );

          case SplashNavigateToMain():
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.mainView,
              (route) => false,
            );
            
          case SplashNavigateToSignUp():
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.signUpView,
              (route) => false,
            );

          case SplashNavigateToVerification():
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.emailVerificationView,
              (route) => false,
            );
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: AppColors.purplePrimary,
          body: Center(child: SvgPicture.asset(AppAssets.logo)),
        ),
      ),
    );
  }
}
