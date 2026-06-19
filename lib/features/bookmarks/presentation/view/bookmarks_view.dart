import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nuntium/core/resources/app_assets.dart';
import 'package:nuntium/core/extensions/theme_extension.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'package:nuntium/core/theme/app_colors.dart';
import 'package:nuntium/core/theme/app_fonts.dart';
import 'package:nuntium/core/widgets/header.dart';
import 'package:nuntium/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:nuntium/features/bookmarks/presentation/cubit/bookmarks_state.dart';
import 'package:nuntium/features/home/presentation/view/widgets/recommended_news_card.dart';
import 'package:nuntium/config/routes.dart';

class BookmarksView extends StatelessWidget {
  const BookmarksView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Header(
                title: AppStrings.bookmarksPageTitle,
                subTtitle: AppStrings.bookmarksPageSubTitle,
              ),
              Expanded(
                child: BlocBuilder<BookmarksCubit, BookmarksState>(
                  builder: (context, state) {
                    return switch (state) {
                      BookmarksInitial() || BookmarksLoading() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      BookmarksError(:final message) => Center(
                        child: Text(message),
                      ),
                      BookmarksLoaded(:final articles) =>
                        articles.isEmpty
                            ? _buildEmpty(context)
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: articles.length,
                                itemBuilder: (context, index) {
                                  final article = articles[index];
                                  return Dismissible(
                                    // Unique key is required for Dismissible
                                    key: ValueKey(article.id),

                                    // Allow swiping from Start to End (Right side in LTR, Left in RTL)
                                    direction: DismissDirection.startToEnd,

                                    // The UI shown behind the item when swiping
                                    background: Container(
                                      margin: EdgeInsets.only(
                                        bottom: 16.h,
                                      ), // Match card margin
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                      ),
                                      // Align icon to the swipe side
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppIcons.delete,
                                            colorFilter: ColorFilter.mode(
                                              AppColors.white,
                                              BlendMode.srcIn,
                                            ),
                                            width: 24.sp,
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            AppStrings.delete,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Actual Logic when swipe is completed
                                    onDismissed: (direction) {
                                      context
                                          .read<BookmarksCubit>()
                                          .removeBookmark(article);
                                    },

                                    // The Article Card
                                    child: RecommendedArticleCard(
                                      article: article,
                                      margin: EdgeInsets.only(bottom: 16.h),
                                      onTap: (tappedArticle) {
                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).pushNamed(
                                          Routes.articleView,
                                          arguments: tappedArticle,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 1),
        Container(
          width: 72.w,
          height: 72.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffEEF0FB),
          ),
          child: Center(
            child: SvgPicture.asset(
              AppIcons.book, // Using the bookmark icon
              width: 24.w,
              height: 24.w,
              colorFilter: const ColorFilter.mode(
                AppColors.purplePrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        SizedBox(height: 24.h),
        SizedBox(
          width: 300.w,
          child: Text(
            AppStrings.noSavedArticles,
            textAlign: TextAlign.center,
            style: context.body2.copyWith(
              color: AppColors.blackPrimary,
              fontWeight: AppFonts.medium,
            ),
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
