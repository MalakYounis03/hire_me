part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const AUTH_SELECT_USER = _Paths.AUTH_SELECT_USER;
  static const AUTH_LOGIN = _Paths.AUTH_LOGIN;
  static const AUTH_REGISTER = _Paths.AUTH_REGISTER;
  static const AUTH_FORGOT_PASSWORD = _Paths.AUTH_FORGOT_PASSWORD;

  static const PROFILE = _Paths.PROFILE;

  static const JOB_SEEKER_DASHBOARD = _Paths.JOB_SEEKER + _Paths.DASHBOARD;
  static const JOB_SEEKER_CONGRATULATIONS =
      _Paths.JOB_SEEKER + _Paths.JOB_SEEKER_CONGRATULATIONS;
  static const JOB_SEEKER_JOB_DETAILS = _Paths.JOB_SEEKER + _Paths.JOB_DETAILS;
  static const JOB_SEEKER_APPLY_JOB = _Paths.JOB_SEEKER + _Paths.APPLY_JOB;
  static const JOB_SEEKER_MY_APPLICATIONS =
      _Paths.JOB_SEEKER + _Paths.MY_APPLICATIONS;

  static const COMPANY_DASHBOARD = _Paths.COMPANY + _Paths.DASHBOARD;
  static const COMPANY_POST_JOB = _Paths.COMPANY + _Paths.POST_JOB;
  static const COMPANY_APPLICANTS = _Paths.COMPANY + _Paths.APPLICANTS;
  static const JOB_SEEKER_MAIN_FIELDS = _Paths.JOB_SEEKER + _Paths.MAIN_FIELDS;
  static const JOB_SEEKER_SAVED_JOBS = _Paths.JOB_SEEKER + _Paths.SAVED_JOBS;
  static const MAIN_WRAPPER = _Paths.MAIN_WRAPPER;

  static const APPLICATION_REVIEW = _Paths.APPLICATION_REVIEW;
  static const APPLICATION_LIST = _Paths.APPLICATION_LIST;
  static const COMPANY_MAIN_WRAPPER = _Paths.COMPANY_MAIN_WRAPPER;
  static const COMPANY_CHAT = _Paths.COMPANY_CHAT;
  static const COMPANY_PROFILE = _Paths.COMPANY_PROFILE;
  static const COMPANY_CHAT_DETAILS = _Paths.COMPANY_CHAT_DETAILS;
}

abstract class _Paths {
  _Paths._();

  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const AUTH_SELECT_USER = '/select-user';
  static const AUTH_LOGIN = '/login';
  static const AUTH_REGISTER = '/register';
  static const AUTH_FORGOT_PASSWORD = '/forgot-password';
  static const JOB_SEEKER = '/job-seeker';

  static const JOB_SEEKER_CONGRATULATIONS = '/congratulations';
  static const COMPANY = '/company';
  static const DASHBOARD = '/dashboard';
  static const JOB_DETAILS = '/job-details';
  static const APPLY_JOB = '/apply-job';
  static const PROFILE = '/profile';
  static const MY_APPLICATIONS = '/my-applications';
  static const POST_JOB = '/post-job';
  static const APPLICANTS = '/applicants';
  static const MAIN_FIELDS = '/main-fields';
  static const SAVED_JOBS = '/saved-jobs';
  static const MAIN_WRAPPER = '/main-wrapper';
  static const APPLICATION_REVIEW = '/application-review';
  static const APPLICATION_LIST = '/application-list';
  static const COMPANY_MAIN_WRAPPER = '/company-main-wrapper';
  static const COMPANY_CHAT = '/company-chat';
  static const COMPANY_PROFILE = '/company-profile';
  static const COMPANY_CHAT_DETAILS = '/company-chat-details';
}
