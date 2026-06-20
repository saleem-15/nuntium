import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuntium/features/splash/cubit/splash_cubit.dart';
import 'package:nuntium/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:nuntium/core/entities/article.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'package:nuntium/features/article_details/presentation/view/article_view.dart';
import 'package:nuntium/features/article_details/presentation/cubit/article_cubit.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/toggle_bookmark_use_case.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/watch_bookmarks_changes_use_case.dart';
import 'package:nuntium/features/auth/presentation/view/change_password_view.dart';
import 'package:nuntium/features/auth/presentation/view/forget_password_view.dart';
import 'package:nuntium/features/auth/presentation/cubit/login_cubit.dart';
import 'package:nuntium/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:nuntium/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:nuntium/features/auth/presentation/cubit/change_password_cubit.dart';
import 'package:nuntium/features/auth/presentation/view/email_verification_view.dart';
import 'package:nuntium/features/auth/presentation/cubit/email_verification_cubit.dart';
import 'package:nuntium/features/auth/presentation/view/login_view.dart';
import 'package:nuntium/features/auth/presentation/view/sign_up_view.dart';
import 'package:nuntium/features/bookmarks/presentation/view/bookmarks_view.dart';
import 'package:nuntium/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:nuntium/features/home/presentation/view/home_page.dart';
import 'package:nuntium/features/language/presentation/view/language_view.dart';
import 'package:nuntium/features/main/cubit/main_cubit.dart';
import 'package:nuntium/features/main/views/main_view.dart';
import 'package:nuntium/features/onboarding/view/onboarding_screen.dart';
import 'package:nuntium/features/onboarding/view/welcome_screen.dart';
import 'package:nuntium/features/profile/presentation/view/profile_view.dart';
import 'package:nuntium/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:nuntium/features/select_favorite_topics/view/select_favorite_topics_view.dart';
import 'package:nuntium/features/terms_and_conditions/presentation/view/app_content_view.dart';

import '../features/article_details/presentation/view/original_article_webview.dart';
import '../features/splash/view/splash_screen.dart';
import 'dependency_injection.dart';

class Routes {
  Routes._();

  //  --- Welcoming ---
  static const String splashView = '/splash_view';
  static const String onBoardingView = '/on_boarding_view';
  static const String welcomeView = '/welcome_view';
  static const String selectFavoriteTopicsView = '/select_favorite_topics_view';

  //  --- Auth ---
  static const String loginView = '/login_view';
  static const String signUpView = '/sign_up_view';
  static const String forgetPasswordView = '/forget_password_view';
  static const String emailVerificationView = '/email_verification_view';
  static const String createNewPasswordView = '/create_new_password_view';
  static const String verificationCodeView = '/verification_code_view';

  //  --- Main Views ---
  static const String mainView = '/main_view';
  static const String homeView = '/home_page_view';
  static const String profileView = '/profile_view';
  static const String bookmarksView = '/bookmarks_view';
  static const String articleView = '/article_view';
  static const String originalArticleView = '/original_article_view';

  // --- Profile related ---
  static const String languageView = '/language_view';
  static const String changePasswordView = '/change_password_view';
  static const String termsAndConditionsView = '/terms_and_conditions_view';
  static const String privacyAndPolicyView = '/privacy_and_policy_view';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      //************************** Welcoming Views **************************
      case Routes.splashView:
        initSplash();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<SplashCubit>()..init(),
            child: const SplashView(),
          ),
        );

      case Routes.onBoardingView:
        initOnboarding();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<OnboardingCubit>(),
            child: const OnboardingView(),
          ),
        );

      case Routes.welcomeView:
        return MaterialPageRoute(builder: (_) => const WelcomeView());

      case Routes.selectFavoriteTopicsView:
        initSelectFavoriteTopics();
        return MaterialPageRoute(builder: (_) => const SelectFavoriteTopics());

      //************************** Auth Views **************************
      case Routes.loginView:
        initLogin();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<LoginCubit>(),
            child: const LoginView(),
          ),
        );

      case Routes.forgetPasswordView:
        initForgetPassword();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ForgetPasswordCubit>(),
            child: const ForgetPasswordView(),
          ),
        );

      case Routes.emailVerificationView:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                getIt<EmailVerificationCubit>()..startVerificationCheck(),
            child: const EmailVerificationView(),
          ),
        );
      case Routes.signUpView:
        initSignUp();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<SignUpCubit>(),
            child: const SignUpView(),
          ),
        );

      //************************** Main Views **************************
      case Routes.mainView:
        // initSession() pushes a new GetIt scope for all user-specific deps.
        // It guards internally against being called twice (hasScope check).
        initSession();
        return MaterialPageRoute(
          builder: (_) => BlocProvider<MainCubit>(
            create: (_) => getIt<MainCubit>(),
            child: const MainView(),
          ),
        );

      case Routes.homeView:
        // HomeView is part of the main shell — its deps are already initialized
        // by initSession() when mainView was entered. No extra init needed.
        return MaterialPageRoute(builder: (_) => const HomeView());

      case Routes.articleView:
        if (settings.arguments is Article) {
          final article = settings.arguments as Article;
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => ArticleCubit(
                initialArticle: article,
                toggleBookmarkUseCase: getIt<ToggleBookmarkUseCase>(),
                watchBookmarksUseCase: getIt<WatchBookmarksChangesUseCase>(),
              ),
              child: const ArticleView(),
            ),
          );
        }
        return unDefinedRoute(settings.name);

      case Routes.originalArticleView:
        // 1. Pick the arguments that was sent via Get.toNamed
        if (settings.arguments is String) {
          final articleUrl = settings.arguments as String;

          // 2. Inject the arguments in dependency injection method
          initOriginalArticle(articleUrl);
        }
        return MaterialPageRoute(
          builder: (_) => const OriginalArticleWebView(),
        );

      case Routes.bookmarksView:
        // BookmarksView deps are session-scoped — already live from initSession().
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<BookmarksCubit>(),
            child: const BookmarksView(),
          ),
        );

      //************************** Profile Views **************************
      case Routes.profileView:
        // ProfileView deps are session-scoped — already live from initSession().
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ProfileCubit>()..getUserData(),
            child: const ProfileView(),
          ),
        );
      case Routes.languageView:
        initLanguage();
        return MaterialPageRoute(builder: (_) => const LanguageView());

      case Routes.changePasswordView:
        initChangePassword();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ChangePasswordCubit>(),
            child: const ChangePasswordView(),
          ),
        );

      case Routes.privacyAndPolicyView:
        initContentController();
        return MaterialPageRoute(
          builder: (_) => AppContentView(
            title: AppStrings.privacyPolicyTitle,
            content: AppStrings.privacyPolicyContent,
          ),
        );

      case Routes.termsAndConditionsView:
        initContentController();
        return MaterialPageRoute(
          builder: (_) => AppContentView(
            title: AppStrings.termsAndConditions,
            content: AppStrings.termsAndConditionsBody,
          ),
        );

      default:
        return unDefinedRoute(settings.name);
    }
  }

  static Route<dynamic> unDefinedRoute(String? routeName) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text('Page Not Found')),
        body: Center(child: Text('$routeName Does Not Exist')),
      ),
    );
  }
}
