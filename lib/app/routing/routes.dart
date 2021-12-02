part of 'pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const HOME = _Paths.HOME;
  static const CREATE = _Paths.CREATE;
  static const ERROR = _Paths.ERROR;
  static const PROFILE = _Paths.PROFILE;
  static const AUTH = _Paths.AUTH;
  static const SIGN_UP = _Paths.SIGN_UP;
  static const LOGIN = _Paths.LOGIN;
  static const SETTINGS = _Paths.SETTINGS;
  static const SETTINGS_EDIT = _Paths.SETTINGS_EDIT;
  static const PUBLISH = _Paths.PUBLISH;
  static const GENERAL_PROFILE = _Paths.GENERAL_PROFILE;
  static const FOR_YOU = _Paths.FOR_YOU;
  static const SEARCH = _Paths.SEARCH;
  static const VIDEO_DETAILS_PAGE = _Paths.VIDEO_DETAILS_PAGE;
}

abstract class _Paths {
  static const SPLASH = '/splash';
  static const HOME = '/home';
  static const CREATE = '/create';
  static const ERROR = '/error';
  static const PROFILE = '/profile';
  static const AUTH = '/auth';
  static const SIGN_UP = '/sign_up';
  static const LOGIN = '/login';
  static const SETTINGS = '/settings';
  static const SETTINGS_EDIT = '/settings_edit';
  static const PUBLISH = '/publish';
  static const GENERAL_PROFILE = '/general_profile';
  static const FOR_YOU = '/for_you';
  static const SEARCH = '/search';
  static const VIDEO_DETAILS_PAGE = '/video_details_page';
}
