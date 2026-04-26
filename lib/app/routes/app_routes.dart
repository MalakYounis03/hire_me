part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const AUTH_LOGIN = _Paths.AUTH + _Paths.LOGIN;
  static const AUTH_REGISTER = _Paths.AUTH + _Paths.REGISTER;
  static const AUTH_FORGOT_PASSWORD = _Paths.AUTH + _Paths.FORGOT_PASSWORD;
  static const AUTH_ROLE_SELECTOR = _Paths.AUTH + _Paths.ROLE_SELECTOR;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const JOB_SEEKER_DASHBOARD = _Paths.JOB_SEEKER + _Paths.DASHBOARD;
  static const JOB_SEEKER_JOB_DETAILS = _Paths.JOB_SEEKER + _Paths.JOB_DETAILS;
  static const JOB_SEEKER_APPLY_JOB = _Paths.JOB_SEEKER + _Paths.APPLY_JOB;
  static const JOB_SEEKER_PROFILE = _Paths.JOB_SEEKER + _Paths.PROFILE;
  static const JOB_SEEKER_MY_APPLICATIONS =
      _Paths.JOB_SEEKER + _Paths.MY_APPLICATIONS;
  static const COMPANY_DASHBOARD = _Paths.COMPANY + _Paths.DASHBOARD;
  static const COMPANY_POST_JOB = _Paths.COMPANY + _Paths.POST_JOB;
  static const COMPANY_APPLICANTS = _Paths.COMPANY + _Paths.APPLICANTS;
  static const JOB_SEEKER_MAIN_FIELDS = _Paths.JOB_SEEKER + _Paths.MAIN_FIELDS;
  static const JOB_SEEKER_SAVED_JOBS = _Paths.JOB_SEEKER + _Paths.SAVED_JOBS;
  static const MAIN_WRAPPER = _Paths.MAIN_WRAPPER;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const AUTH = '/auth';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const ROLE_SELECTOR = '/role-selector';
  static const ONBOARDING = '/onboarding';
  static const JOB_SEEKER = '/job-seeker';
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
}
