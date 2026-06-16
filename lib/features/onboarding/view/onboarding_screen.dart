import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuntium/config/routes.dart';
import 'package:nuntium/core/resources/app_assets.dart';
import 'package:nuntium/core/extensions/theme_extension.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'package:nuntium/core/theme/app_colors.dart';
import 'package:nuntium/core/widgets/primary_button.dart';
import 'package:nuntium/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:nuntium/features/onboarding/cubit/onboarding_state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late final CarouselSliderController _carouselSliderController;

  @override
  void initState() {
    super.initState();
    _carouselSliderController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();

    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingNavigateToWelcome) {
          Navigator.pushReplacementNamed(context, Routes.welcomeView);
        }
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 120.h),
            CarouselSlider(
              carouselController: _carouselSliderController,
              options: CarouselOptions(
                height: 336.h,
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                autoPlay: true,
                reverse: false,
                autoPlayInterval: const Duration(seconds: 4),
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) {
                  cubit.onPageChanged(index);
                },
              ),
              items: [
                Image.asset(AppAssets.onboarding),
                Image.asset(AppAssets.onboarding),
                Image.asset(AppAssets.onboarding),
              ],
            ),
            SizedBox(height: 40.h),
            BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                return AnimatedSmoothIndicator(
                  count: cubit.titles.length,
                  activeIndex: state.index,
                  effect: ExpandingDotsEffect(
                    dotColor: AppColors.greyLighter,
                    activeDotColor: AppColors.purplePrimary,
                    dotHeight: 8.sp,
                    dotWidth: 8.sp,
                  ),
                );
              },
            ),
            SizedBox(height: 34.h),
            BlocBuilder<OnboardingCubit, OnboardingState>(
              buildWhen: (previous, current) => previous.index != current.index,
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    key: ValueKey<String>(cubit.titles[state.index]),
                    cubit.titles[state.index],
                    textAlign: TextAlign.center,
                    style: context.headline1,
                  ),
                );
              },
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: 280.w,
              child: BlocBuilder<OnboardingCubit, OnboardingState>(
                buildWhen: (previous, current) =>
                    previous.index != current.index,
                builder: (context, state) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      key: ValueKey<String>(cubit.subTitles[state.index]),
                      cubit.subTitles[state.index],
                      textAlign: TextAlign.center,
                      style: context.body1,
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 20.w, left: 20.w, bottom: 35.h),
              child: PrimaryButton(
                text: AppStrings.next,
                onPressed: () {
                  final currentIndex = cubit.state.index;
                  if (currentIndex < cubit.titles.length - 1) {
                    _carouselSliderController.nextPage();
                  } else {
                    cubit.navigateToWelcome();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
