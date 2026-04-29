part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const AUTH_SELECT_USER = _Paths.AUTH_SELECT_USER;
  static const AUTH_LOGIN = _Paths.AUTH_LOGIN;
  static const AUTH_REGISTER = _Paths.AUTH_REGISTER;
  static const AUTH_FORGOT_PASSWORD = _Paths.AUTH_FORGOT_PASSWORD;
  static const AUTH_OTP = _Paths.AUTH_OTP;

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
  static const JOBSEEKER = _Paths.JOBSEEKER;
  static const JOBSEEKERCONGRATULATIONS = _Paths.JOBSEEKERCONGRATULATIONS;
}

abstract class _Paths {
  _Paths._();

  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const AUTH_SELECT_USER = '/select-user';
  static const AUTH_LOGIN = '/login';
  static const AUTH_REGISTER = '/register';
  static const AUTH_FORGOT_PASSWORD = '/forgot-password';
  static const AUTH_OTP = '/otp';
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
  static const JOBSEEKER = '/jobseeker';
  static const JOBSEEKERCONGRATULATIONS = '/jobseekercongratulations';
}
