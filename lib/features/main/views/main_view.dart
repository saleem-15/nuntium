import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuntium/config/dependency_injection.dart';
import 'package:nuntium/core/resources/app_assets.dart';
import 'package:nuntium/core/theme/app_colors.dart';
import 'package:nuntium/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:nuntium/features/bookmarks/presentation/view/bookmarks_view.dart';
import 'package:nuntium/features/categories/presentation/controller/categories_controller.dart';
import 'package:nuntium/features/categories/presentation/views/categories_view.dart';
import 'package:nuntium/features/home/presentation/view/home_page.dart';
import 'package:nuntium/features/main/cubit/main_cubit.dart';
import 'package:nuntium/features/main/cubit/main_state.dart';
import 'package:nuntium/features/profile/presentation/view/profile_view.dart';
import 'package:nuntium/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../../home/presentation/bloc/home_bloc.dart';
import '../../home/presentation/bloc/home_event.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final PersistentTabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialIndex = context.read<MainCubit>().state.tabIndex;
    _tabController = PersistentTabController(initialIndex: initialIndex);

    // Fetch initial tab data if necessary
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTabDataIfNeeded(initialIndex);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _fetchTabDataIfNeeded(int index) {
    switch (index) {
      case 1: // Categories
        if (Get.isRegistered<CategoriesController>()) {
          Get.find<CategoriesController>().fetchCategoriesIfNeeded();
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainCubit, MainState>(
      listener: (context, state) {
        // Sync visual tab only if it differs from the cubit's state index.
        // This avoids recursive loops when user taps on tabs manually.
        if (_tabController.index != state.tabIndex) {
          _tabController.jumpToTab(state.tabIndex);
        }
        _fetchTabDataIfNeeded(state.tabIndex);
      },
      child: PersistentTabView(
        controller: _tabController,
        tabs: _tabs(),

        // Using navBarBuilder to customize the decoration of Style 10
        navBarBuilder: (navBarConfig) => Style10BottomNavBar(
          navBarConfig: navBarConfig,
          height: 60.h,
          itemAnimationProperties: const ItemAnimation(
            duration: Duration(milliseconds: 400),
          ),
          navBarDecoration: NavBarDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -1),
                color: AppColors.greyLight.withValues(alpha: 0.32),
                blurRadius: 0,
                spreadRadius: 0,
              ),
            ],
          ),
        ),

        onTabChanged: (index) {
          context.read<MainCubit>().changeTab(index);
        },
      ),
    );
  }

  List<PersistentTabConfig> _tabs() {
    return [
      /// Home Tab Configuration
      PersistentTabConfig(
        screen: BlocProvider(
          create: (_) => getIt<HomeBloc>()..add(HomeStarted()),
          child: const HomeView(),
        ),
        item: ItemConfig(
          icon: SvgPicture.asset(
            AppIcons.home,
            colorFilter: const ColorFilter.mode(
              AppColors.purplePrimary,
              BlendMode.srcIn,
            ),
          ),
          inactiveIcon: SvgPicture.asset(
            AppIcons.home,
            colorFilter: const ColorFilter.mode(
              AppColors.greyPrimary,
              BlendMode.srcIn,
            ),
          ),
          activeForegroundColor: AppColors.purplePrimary,
          inactiveForegroundColor: AppColors.greyPrimary,
        ),
      ),

      /// Categories Tab Configuration
      PersistentTabConfig(
        screen: const CategoriesView(),
        item: ItemConfig(
          icon: SvgPicture.asset(
            AppIcons.category,
            colorFilter: const ColorFilter.mode(
              AppColors.purplePrimary,
              BlendMode.srcIn,
            ),
          ),
          inactiveIcon: SvgPicture.asset(
            AppIcons.category,
            colorFilter: const ColorFilter.mode(
              AppColors.greyPrimary,
              BlendMode.srcIn,
            ),
          ),
          activeForegroundColor: AppColors.purplePrimary,
          inactiveForegroundColor: AppColors.greyPrimary,
        ),
      ),

      // Bookmarks Tab Configuration
      PersistentTabConfig(
        screen: BlocProvider.value(
          value: getIt<BookmarksCubit>(),
          child: const BookmarksView(),
        ),
        item: ItemConfig(
          icon: SvgPicture.asset(
            AppIcons.bookmark,
            colorFilter: const ColorFilter.mode(
              AppColors.purplePrimary,
              BlendMode.srcIn,
            ),
          ),
          inactiveIcon: SvgPicture.asset(
            AppIcons.bookmark,
            colorFilter: const ColorFilter.mode(
              AppColors.greyPrimary,
              BlendMode.srcIn,
            ),
          ),
          activeForegroundColor: AppColors.purplePrimary,
          inactiveForegroundColor: AppColors.greyPrimary,
        ),
      ),

      /// Profile Tab Configuration
      PersistentTabConfig(
        screen: BlocProvider(
          create: (_) => getIt<ProfileCubit>()..getUserData(),
          child: const ProfileView(),
        ),
        item: ItemConfig(
          icon: SvgPicture.asset(
            AppIcons.user,
            colorFilter: const ColorFilter.mode(
              AppColors.purplePrimary,
              BlendMode.srcIn,
            ),
          ),
          inactiveIcon: SvgPicture.asset(
            AppIcons.user,
            colorFilter: const ColorFilter.mode(
              AppColors.greyPrimary,
              BlendMode.srcIn,
            ),
          ),
          activeForegroundColor: AppColors.purplePrimary,
          inactiveForegroundColor: AppColors.greyPrimary,
        ),
      ),
    ];
  }
}
