import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/pages/auth/auth_bindings.dart';
import 'package:naprimer_app_v2/app/pages/auth/auth_page.dart';
import 'package:naprimer_app_v2/app/pages/auth/login/login_bindings.dart';
import 'package:naprimer_app_v2/app/pages/auth/login/login_page.dart';
import 'package:naprimer_app_v2/app/pages/auth/sign_up/sign_up_bindings.dart';
import 'package:naprimer_app_v2/app/pages/auth/sign_up/sign_up_page.dart';
import 'package:naprimer_app_v2/app/pages/create/create_bindings.dart';
import 'package:naprimer_app_v2/app/pages/create/create_controller.dart';
import 'package:naprimer_app_v2/app/pages/create/create_page.dart';
import 'package:naprimer_app_v2/app/pages/create/publish/publish_page.dart';
import 'package:naprimer_app_v2/app/pages/error/error.dart';
import 'package:naprimer_app_v2/app/pages/for_you/for_you_page.dart';
import 'package:naprimer_app_v2/app/pages/home/home_bindings.dart';
import 'package:naprimer_app_v2/app/pages/home/home_page.dart';
import 'package:naprimer_app_v2/app/pages/profile/general/general_profile_bindings.dart';
import 'package:naprimer_app_v2/app/pages/profile/general/general_profile_controller.dart';
import 'package:naprimer_app_v2/app/pages/profile/general/general_profile_page.dart';
import 'package:naprimer_app_v2/app/pages/search/search_page.dart';
import 'package:naprimer_app_v2/app/pages/settings/edit/settings_edit_bindings.dart';
import 'package:naprimer_app_v2/app/pages/settings/edit/settings_edit_controller.dart';
import 'package:naprimer_app_v2/app/pages/settings/edit/settings_edit_page.dart';
import 'package:naprimer_app_v2/app/pages/settings/settings_bindings.dart';
import 'package:naprimer_app_v2/app/pages/settings/settings_page.dart';
import 'package:naprimer_app_v2/app/pages/splash/splash_page.dart';
import 'package:naprimer_app_v2/app/pages/video_details/video_details_page.dart';
import 'package:naprimer_app_v2/app/pages/video_details/video_details_page_bindings.dart';
import 'package:naprimer_app_v2/data/video/video_item.dart';

part 'routes.dart';

class GlobalPages {
  GlobalPages._();

  static const INITIAL = Routes.SPLASH;

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.SPLASH:
        return _buildSplashScreen(settings);
      case Routes.HOME:
        return _buildHomeScreen(settings);
      case Routes.CREATE:
        return _buildCreateScreen(settings);
      case Routes.AUTH:
        return _buildAuthScreen(settings);
      case Routes.SIGN_UP:
        return _buildSignUpScreen(settings);
      case Routes.LOGIN:
        return _buildLoginScreen(settings);
      case Routes.SETTINGS:
        return _buildSettingsScreen(settings);
      case Routes.SETTINGS_EDIT:
        return _buildSettingsEditScreen(settings);
      case Routes.PUBLISH:
        return _buildPublishScreen(settings);
      case Routes.VIDEO_DETAILS_PAGE:
        return _buildVideoDetailsScreen(settings);
      default:
        return _buildSplashScreen(settings);
    }
  }

  static GetPageRoute _buildAuthScreen(RouteSettings settings) {
    return GetPageRoute(
        opaque: false,
        binding: AuthBindings(),
        page: () => AuthPage(),
        settings: settings);
  }

  static GetPageRoute _buildSignUpScreen(RouteSettings settings) {
    return GetPageRoute(
        page: () => SignUpPage(),
        binding: SignUpBindings(),
        settings: settings);
  }

  static GetPageRoute _buildSplashScreen(RouteSettings settings) {
    return GetPageRoute(
      page: () => SplashPage(),
      settings: settings,
    );
  }

  static GetPageRoute _buildHomeScreen(RouteSettings settings) {
    return GetPageRoute(
      binding: HomeBindings(arguments: settings.arguments),
      settings: settings,
      page: () => HomePage(),
    );
  }

  static GetPageRoute _buildCreateScreen(RouteSettings settings) {
    return GetPageRoute(
      binding: CreateBindings(),
      settings: settings,
      page: () => CreatePage(),
    );
  }

  static GetPageRoute _buildLoginScreen(RouteSettings settings) {
    return GetPageRoute(
      binding: LoginBindings(),
      settings: settings,
      page: () => LoginPage(),
    );
  }

  // static GetPageRoute _buildErrorScreen(RouteSettings settings) {
  //   ErrorState errorState = ErrorState.SOMETHING_WENT_WRONG;
  //   if (settings.arguments != null) {
  //     errorState = settings.arguments as ErrorState;
  //   }
  //   return GetPageRoute(
  //       page: () => ErrorPage(errorState: errorState), settings: settings);
  // }

  static GetPageRoute _buildSettingsScreen(RouteSettings settings) {
    return GetPageRoute(
      binding: SettingsBindings(),
      settings: settings,
      page: () => SettingsPage(),
    );
  }

  static GetPageRoute _buildSettingsEditScreen(RouteSettings settings) {
    return GetPageRoute(
      binding: SettingsEditBindings(
          arguments: settings.arguments as SettingsEditArguments),
      settings: settings,
      page: () => SettingsEditPage(),
    );
  }

  static GetPageRoute _buildPublishScreen(RouteSettings settings) {
    return GetPageRoute(
      settings: settings,
      page: () => PublishPage(settings.arguments as CreateController),
    );
  }

  static GetPageRoute _buildVideoDetailsScreen(RouteSettings settings) {
    return GetPageRoute(
      settings: settings,
      binding: VideoDetailsPageBindings(videoItem: settings.arguments as VideoItem),
      page: () => VideoDetailsPage(),
    );
  }
}

class ForYouPages {
  ForYouPages._();

  static const INITIAL = Routes.FOR_YOU;
  static late int navigatorKeyId;

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.FOR_YOU:
        return _buildForYouScreen(settings);
      case Routes.GENERAL_PROFILE:
        return _buildGeneralProfileScreen(settings);
      case Routes.VIDEO_DETAILS_PAGE:
        return _buildVideoDetailsScreen(settings);
      default:
        return _buildErrorScreen(settings);
    }
  }

  static GetPageRoute _buildForYouScreen(RouteSettings settings) {
    return GetPageRoute(page: () => ForYouPage(), settings: settings);
  }

  static GetPageRoute _buildErrorScreen(RouteSettings settings) {
    return GetPageRoute(page: () => ErrorPage(), settings: settings);
  }

  static GetPageRoute _buildGeneralProfileScreen(RouteSettings settings) {
    return GetPageRoute(
      binding: GeneralProfileBindings(
          arguments: settings.arguments as GeneralProfileArguments),
      settings: settings,
      page: () => GeneralProfilePage(),
    );
  }

  static GetPageRoute _buildVideoDetailsScreen(RouteSettings settings) {
    return GetPageRoute(
      settings: settings,
      binding: VideoDetailsPageBindings(videoItem: settings.arguments as VideoItem),
      page: () => VideoDetailsPage(),
    );
  }
}

class SearchPages {
  SearchPages._();

  static const INITIAL = Routes.SEARCH;
  static late int navigatorKeyId;

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.SEARCH:
        return _buildSearchScreen(settings);
      case Routes.GENERAL_PROFILE:
        return _buildGeneralProfileScreen(settings);
        case Routes.VIDEO_DETAILS_PAGE:
        return _buildVideoDetailsScreen(settings);
      default:
        return _buildErrorScreen(settings);
    }
  }

  static GetPageRoute _buildSearchScreen(RouteSettings settings) {
    return GetPageRoute(page: () => SearchPage(), settings: settings);
  }

  static GetPageRoute _buildErrorScreen(RouteSettings settings) {
    ErrorState errorState = ErrorState.SOMETHING_WENT_WRONG;
    if (settings.arguments != null) {
      errorState = settings.arguments as ErrorState;
    }
    return GetPageRoute(
        page: () => ErrorPage(errorState: errorState), settings: settings);
  }

  static GetPageRoute _buildGeneralProfileScreen(RouteSettings settings) {
    return GetPageRoute(
      binding: GeneralProfileBindings(
          arguments: settings.arguments as GeneralProfileArguments),
      settings: settings,
      page: () => GeneralProfilePage(),
    );
  }

  static GetPageRoute _buildVideoDetailsScreen(RouteSettings settings) {
    return GetPageRoute(
      settings: settings,
      binding: VideoDetailsPageBindings(videoItem: settings.arguments as VideoItem),
      page: () => VideoDetailsPage(),
    );
  }
}
