import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nuntium/config/routes.dart';
import 'package:nuntium/core/models/article.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'package:nuntium/core/theme/app_colors.dart';
import 'package:nuntium/core/widgets/header.dart';
import 'package:nuntium/features/home/presentation/bloc/home_bloc.dart';
import 'package:nuntium/features/home/presentation/view/widgets/article_card.dart';
import 'package:nuntium/features/home/presentation/view/widgets/articles_loading_error.dart';
import 'package:nuntium/features/home/presentation/view/widgets/articles_loading_indicator.dart';
import 'package:nuntium/features/home/presentation/view/widgets/category_selector.dart';
import 'package:nuntium/features/home/presentation/view/widgets/home_search_bar.dart';

import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _showScrollUpButton = false;
  late final ScrollController _scrollController;
  late final TextEditingController _searchFieldController;

  bool _isLoadingStatus(BuildContext context) {
    return context.read<HomeBloc>().state.status == HomeStatus.loading;
  }

  bool _isLoadingNextPageStatus(BuildContext context) {
    return context.read<HomeBloc>().state.status == HomeStatus.loadingNextPage;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _searchFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchFieldController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  void _onScroll() {
    // FAB visibility — pure UI, lives here not in BLoC
    final shouldShow = _scrollController.offset > 400;
    if (shouldShow != _showScrollUpButton) {
      setState(() {
        _showScrollUpButton = shouldShow;
      });
    }

    // Pagination trigger — dispatch event when 5 items left
    if (_isLoadingStatus(context) || _isLoadingNextPageStatus(context)) {
      return;
    }
    final itemHeight = 216.h;
    const triggerMargin = 5; //number of items left to trigger the event
    final maxScroll = _scrollController.position.maxScrollExtent;
    final triggerPosition = maxScroll - itemHeight * triggerMargin;

    if (_scrollController.offset >= triggerPosition) {
      context.read<HomeBloc>().add(HomeNextPageRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _showScrollUpButton ? 1.0 : 0.0,
              child: Visibility(
                visible: _showScrollUpButton,
                child: FloatingActionButton(
                  onPressed: _scrollToTop,
                  backgroundColor: AppColors.purplePrimary,
                  mini: true,
                  child: const Icon(Icons.arrow_upward, color: Colors.white),
                ),
              ),
            ),

            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Page Header
                SliverToBoxAdapter(
                  child: Header(
                    horizentalPadding: 20.w,
                    title: AppStrings.homePageTitle,
                    subTtitle: AppStrings.homePageSubTitle,
                  ),
                ),

                // Search
                SliverToBoxAdapter(
                  child: HomeSearchBar(
                    searchFieldController: _searchFieldController,
                    onSearchPressed: () => context.read<HomeBloc>().add(
                      HomeSearchSubmitted(query: _searchFieldController.text),
                    ),
                  ),
                ),

                SliverPadding(padding: EdgeInsets.only(top: 24.h)),

                // News Categories
                const SliverToBoxAdapter(child: CategorySelector()),

                SliverPadding(padding: EdgeInsets.only(top: 24.h)),

                _buildContent(state),

                // //Recent News
                // SliverToBoxAdapter(
                //   child: Padding(
                //     padding: EdgeInsets.only(top: 24.h),
                //     child: SizedBox(
                //       height: 256.h,
                //       child: ListView.builder(
                //         scrollDirection: Axis.horizontal,
                //         padding: EdgeInsets.only(left: 20.w),
                //         itemCount: controller.recentNews.length,
                //         itemBuilder: (_, index) {
                //           final news = controller.recentNews[index];

                //           return RecentNewsCard(
                //             news: news,
                //             onTap: () => controller.onNewsCardPressed(news),
                //             onBookmarkTap: () =>
                //                 controller.onNewsCardBookmarkPressed(news),
                //           );
                //         },
                //       ),
                //     ),
                //   ),
                // ),

                // SliverPadding(padding: EdgeInsets.only(top: 48.h)),

                // _buildRecommendedSectionHeader(context),

                // //Recommended for you
                // SliverList(
                //   delegate: SliverChildBuilderDelegate((_, index) {
                //     final news = controller.recommendedNews[index];
                //     return RecommendedNewsCard(
                //       news: news,
                //       margin: EdgeInsets.only(right: 20.w, left: 20.w, bottom: 16.h),
                //       onTap: controller.onNewsCardPressed,
                //     );
                //   }, childCount: controller.recommendedNews.length),
                // ),

                // إضافة مسافة في الأسفل لضمان عدم اختفاء الكروت خلف الـ BottomNavBar
                SliverToBoxAdapter(child: SizedBox(height: 80.h)),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget _buildRecommendedSectionHeader(BuildContext context) {
  //   return SliverToBoxAdapter(
  //     child: Padding(
  //       padding: EdgeInsets.only(right: 20.w, left: 20.w, bottom: 24.h),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             AppStrings.recommendedForYou,
  //             style: context.headline1.copyWith(fontSize: 20.sp),
  //           ),
  //           Text(
  //             AppStrings.seeAll,
  //             style: context.body1.copyWith(
  //               fontSize: 14.sp,
  //               color: AppColors.greyPrimary,
  //               fontWeight: AppFonts.medium,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _buildContent(HomeState state) {
    final status = state.status;

    // First Page Loading
    if (status == HomeStatus.loading && state.articles.isEmpty) {
      return SliverFillRemaining(child: const ArticlesLoadingIndicator());
    }

    // First Page Error
    if (status == HomeStatus.error && state.articles.isEmpty) {
      return SliverFillRemaining(
        child: PageLoadingError(
          errorMessage: state.errorMessage ?? AppStrings.errorLoadingNews,
          onRefreshPressed: () {
            context.read<HomeBloc>().add(HomeRefreshRequested());
          },
        ),
      );
    }

    // Empty result
    if (status == HomeStatus.loaded && state.articles.isEmpty) {
      return SliverFillRemaining(
        child: Center(child: Text(AppStrings.noArticlesFound)),
      );
    }

    return SliverList.builder(
      itemCount: state.articles.length + 1, // +1 for spinner slot

      itemBuilder: (context, index) {
        // Last slot — show spinner or nothing
        if (index == state.articles.length) {
          return state.status == HomeStatus.loadingNextPage
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                )
              : const SizedBox.shrink();
        }

        final article = state.articles[index];

        return Padding(
          padding: EdgeInsets.only(bottom: 24.h),
          child: Center(
            key: ValueKey(article.id), // مهم للأداء
            child:
                //  Text('index $index'),
                ArticleCard(
                  article: article,
                  onPressed: () => _onArticlePressed(article),
                  onBookmarkPressed: () => context.read<HomeBloc>().add(
                    HomeBookmarkToggled(article: article),
                  ),
                ),
          ),
        );
      },
    );

    // return PagedSliverList<int, Article>(
    //   // لاحظ: نمرر state و fetchNextPage بدلاً من controller
    //   state: state,
    //   fetchNextPage: fetchNextPage,

    //   builderDelegate: PagedChildBuilderDelegate<Article>(
    //     animateTransitions: true,

    //     // بناء العنصر
    //     itemBuilder: (context, article, index) => Padding(
    //       padding: EdgeInsets.only(bottom: 24.h),
    //       child: Center(
    //         key: ValueKey(article.id), // مهم للأداء
    //         child: ArticleCard(
    //           article: article,
    //           onPressed: () => _onArticlePressed(article),
    //           onBookmarkPressed: () => context.read<HomeBloc>().add(
    //             HomeBookmarkToggled(article: article),
    //           ),
    //         ),
    //       ),
    //     ),

    //     // حالة عدم وجود بيانات
    //     noItemsFoundIndicatorBuilder: (_) =>
    //         Center(child: Text(AppStrings.noArticlesFound)),

    //     // حالة الخطأ في الصفحة الأولى
    //     firstPageErrorIndicatorBuilder: (_) => PageLoadingError(
    //       onRefreshPressed: controller.onRefreshPressed,
    //     ),

    //     // مؤشر التحميل الأولي
    //     firstPageProgressIndicatorBuilder: (_) =>
    //         const ArticlesLoadingIndicator(),

    //     // مؤشر تحميل صفحة جديدة
    //     newPageProgressIndicatorBuilder: (_) => const Padding(
    //       padding: EdgeInsets.all(16.0),
    //       child: Center(child: CircularProgressIndicator.adaptive()),
    //     ),
    //   ),
    // );

    // if (status == HomeStatus.loaded) {

    //   ListView.
    //   return Padding(
    //     padding: EdgeInsets.only(bottom: 24.h),
    //     child: Center(
    //       key: ValueKey(article.id), // مهم للأداء
    //       child: ArticleCard(
    //         article: article,
    //         onPressed: () => _onArticlePressed(article),
    //         onBookmarkPressed: () => context
    //             .read<HomeBloc>()
    //             .add(HomeBookmarkToggled(article: article)),
    //       ),
    //     ),
    //   );
    // }
  }

  void _onArticlePressed(Article article) {
    Get.toNamed(Routes.articleView, arguments: article);
  }
}
