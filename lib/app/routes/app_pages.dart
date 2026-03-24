import 'package:get/get.dart';

import '../modules/auth/forgot_password/bindings/auth_forgot_password_binding.dart';
import '../modules/auth/forgot_password/views/auth_forgot_password_view.dart';
import '../modules/auth/login/bindings/auth_login_binding.dart';
import '../modules/auth/login/views/auth_login_view.dart';
import '../modules/auth/register/bindings/auth_register_binding.dart';
import '../modules/auth/register/views/auth_register_view.dart';
import '../modules/auth/role_selector/bindings/auth_role_selector_binding.dart';
import '../modules/auth/role_selector/views/auth_role_selector_view.dart';
import '../modules/auth/select_user/bindings/auth_select_user_binding.dart';
import '../modules/auth/select_user/views/auth_select_user_view.dart';
import '../modules/auth/splash/bindings/auth_splash_binding.dart';
import '../modules/auth/splash/views/auth_splash_view.dart';
import '../modules/company/applicants/bindings/company_applicants_binding.dart';
import '../modules/company/applicants/views/company_applicants_view.dart';
import '../modules/company/dashboard/bindings/company_dashboard_binding.dart';
import '../modules/company/dashboard/views/company_dashboard_view.dart';
import '../modules/company/post_job/bindings/company_post_job_binding.dart';
import '../modules/company/post_job/views/company_post_job_view.dart';
import '../modules/job_seeker/apply_job/bindings/job_seeker_apply_job_binding.dart';
import '../modules/job_seeker/apply_job/views/job_seeker_apply_job_view.dart';
import '../modules/job_seeker/dashboard/bindings/job_seeker_dashboard_binding.dart';
import '../modules/job_seeker/dashboard/views/job_seeker_dashboard_view.dart';
import '../modules/job_seeker/job_details/bindings/job_seeker_job_details_binding.dart';
import '../modules/job_seeker/job_details/views/job_seeker_job_details_view.dart';
import '../modules/job_seeker/my_applications/bindings/job_seeker_my_applications_binding.dart';
import '../modules/job_seeker/my_applications/views/job_seeker_my_applications_view.dart';
import '../modules/job_seeker/profile/bindings/job_seeker_profile_binding.dart';
import '../modules/job_seeker/profile/views/job_seeker_profile_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const AuthSplashView(),
      binding: AuthSplashBinding(),
    ),
    GetPage(
      name: Routes.AUTH_SELECT_USER,
      page: () => const AuthSelectUserView(),

      binding: AuthSelectUserBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const AuthLoginView(),
      binding: AuthLoginBinding(),
    ),

    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const AuthForgotPasswordView(),
      binding: AuthForgotPasswordBinding(),
    ),
  ];
}
