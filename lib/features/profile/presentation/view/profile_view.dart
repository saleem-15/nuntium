import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuntium/config/dependency_injection.dart';
import 'package:nuntium/config/routes.dart';
import 'package:nuntium/core/extensions/theme_extension.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'package:nuntium/core/theme/app_colors.dart';
import 'package:nuntium/core/widgets/snack_bars/error_snack_bar.dart';
import 'package:nuntium/features/profile/domain/entities/user_entity.dart';
import 'package:nuntium/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:nuntium/features/profile/presentation/cubit/profile_state.dart';
import 'package:nuntium/features/profile/presentation/view/widgets/settings_list_tile.dart';
import 'package:nuntium/features/profile/presentation/view/widgets/sign_out_dialog.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  ImageProvider<Object>? _getImage(UserEntity? user) {
    if (user != null && user.photoUrl != null) {
      return NetworkImage(user.photoUrl!);
    }
    return null;
  }

  void _onSignOutPressed(BuildContext context) {
    showSignoutDialog(
      context,
      onSignOutPressed: () {
        context.read<ProfileCubit>().signOut();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSignOutSuccess) {
          resetSession().then((_) {
            if (context.mounted) {
              // Use the root Navigator to avoid nested navigator issues.
              // Persistent bottom navigation bar has it's own navigator.
              // And it has its own stack of screens.
              // So we need to use the root Navigator to navigate to the login view.
              // You can use the Persistent botton view navigator to navigate
              // to push a view in the persistent botton view stack.
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamedAndRemoveUntil(Routes.loginView, (route) => false);
            }
          });
        } else if (state is ProfileSignOutError) {
          showErrorSnackBar(context, state.message);
        }
      },
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(right: 20.w, left: 20.w, top: 28.h),
            child: Column(
              children: [
                BlocBuilder<ProfileCubit, ProfileState>(
                  buildWhen: (previous, current) =>
                      current is ProfileLoaded || current is ProfileInitial,
                  builder: (context, state) {
                    final user = state is ProfileLoaded ? state.user : null;
                    return _profileHeader(context, user);
                  },
                ),

                SizedBox(height: 32.h),

                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SettingsListTile(
                        title: AppStrings.notifications,
                        trailing: Transform.scale(
                          scale: 0.8,
                          child: BlocBuilder<ProfileCubit, ProfileState>(
                            buildWhen: (previous, current) =>
                                current is ProfileLoaded,
                            builder: (context, state) {
                              final isNotificationsOn = state is ProfileLoaded
                                  ? state.isNotificationsOn
                                  : true;
                              return Switch(
                                activeTrackColor: AppColors.purplePrimary,
                                value: isNotificationsOn,
                                onChanged: (val) {
                                  context
                                      .read<ProfileCubit>()
                                      .toggleNotifications(val);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      SettingsListTile(
                        title: AppStrings.language,
                        onPressed: () {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed(Routes.languageView);
                        },
                      ),
                      SettingsListTile(
                        title: AppStrings.changePassword,
                        onPressed: () {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed(Routes.changePasswordView);
                        },
                      ),
                      SettingsListTile(
                        title: AppStrings.privacy,
                        onPressed: () {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed(Routes.privacyAndPolicyView);
                        },
                      ),
                      SettingsListTile(
                        title: AppStrings.termsAndConditions,
                        onPressed: () {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed(Routes.termsAndConditionsView);
                        },
                      ),
                      SettingsListTile(
                        title: AppStrings.signOut,
                        trailing: Icon(
                          Icons.logout,
                          color: AppColors.greyDarker,
                          size: 24.sp,
                        ),
                        onPressed: () => _onSignOutPressed(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileHeader(BuildContext context, UserEntity? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.profile, style: context.headline1),
        SizedBox(height: 32.h, width: double.infinity),
        if (user != null)
          Row(
            children: [
              CircleAvatar(radius: 36.r, foregroundImage: _getImage(user)),
              SizedBox(width: 24.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (user.displayName != null)
                    Text(
                      user.displayName!,
                      style: context.body2.copyWith(
                        color: AppColors.blackPrimary,
                      ),
                    ),
                  Text(
                    user.email,
                    style: context.body1.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.greyPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
