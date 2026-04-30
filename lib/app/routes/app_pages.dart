import 'package:get/get.dart';

import '../modules/auth/forgot_password/bindings/auth_forgot_password_binding.dart';
import '../modules/auth/forgot_password/views/auth_forgot_password_view.dart';
import '../modules/auth/login/bindings/auth_login_binding.dart';
import '../modules/auth/login/views/auth_login_view.dart';
import '../modules/auth/onboarding/bindings/onboarding_binding.dart';
import '../modules/auth/onboarding/views/onboarding_view.dart';
import '../modules/auth/register/bindings/auth_register_binding.dart';
import '../modules/auth/register/views/auth_register_view.dart';
import '../modules/auth/select_user/bindings/auth_select_user_binding.dart';
import '../modules/auth/select_user/views/auth_select_user_view.dart';
import '../modules/auth/splash/bindings/auth_splash_binding.dart';
import '../modules/auth/splash/views/auth_splash_view.dart';
import '../middleware/role_guard_middleware.dart';
import '../services/storage_service.dart';
import '../modules/company/application_list/bindings/application_list_binding.dart';
import '../modules/company/application_list/views/application_list_view.dart';
import '../modules/company/application_review/bindings/application_review_binding.dart';
import '../modules/company/application_review/views/application_review_view.dart';
import '../modules/company/company_chat/bindings/company_chat_binding.dart';
import '../modules/company/company_chat/views/company_chat_view.dart';
import '../modules/company/company_main_wrapper/bindings/company_main_wrapper_binding.dart';
import '../modules/company/company_main_wrapper/views/company_main_wrapper_view.dart';
import '../modules/company/dashboard/bindings/company_dashboard_binding.dart';
import '../modules/company/dashboard/views/company_dashboard_view.dart';
import '../modules/company/post_job/bindings/company_post_job_binding.dart';
import '../modules/company/post_job/views/company_post_job_view.dart';
import '../modules/company/company_profile/bindings/company_profile_binding.dart';
import '../modules/company/company_profile/views/company_profile_view.dart';
import '../modules/job_seeker/apply_job/bindings/job_seeker_apply_job_binding.dart';
import '../modules/job_seeker/apply_job/views/job_seeker_apply_job_view.dart';
import '../modules/job_seeker/dashboard/bindings/job_seeker_dashboard_binding.dart';
import '../modules/job_seeker/dashboard/views/job_seeker_dashboard_view.dart';
import '../modules/job_seeker/job_details/bindings/job_seeker_job_details_binding.dart';
import '../modules/job_seeker/job_details/views/job_seeker_job_details_view.dart';
import '../modules/job_seeker/main_fields/bindings/job_seeker_main_fields_binding.dart';
import '../modules/job_seeker/main_fields/views/job_seeker_main_fields_view.dart';
import '../modules/job_seeker/my_applications/bindings/job_seeker_my_applications_binding.dart';
import '../modules/job_seeker/my_applications/views/job_seeker_my_applications_view.dart';
import '../modules/job_seeker/saved_jobs/bindings/job_seeker_saved_jobs_binding.dart';
import '../modules/job_seeker/saved_jobs/views/job_seeker_saved_jobs_view.dart';
import '../modules/main_wrapper/bindings/main_wrapper_binding.dart';
import '../modules/main_wrapper/views/main_wrapper_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const AuthSplashView(),
      binding: AuthSplashBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.AUTH_SELECT_USER,
      page: () => const AuthSelectUserView(),
      binding: AuthSelectUserBinding(),
    ),
    GetPage(
      name: Routes.AUTH_LOGIN,
      page: () => const AuthLoginView(),
      binding: AuthLoginBinding(),
    ),
    GetPage(
      name: Routes.AUTH_REGISTER,
      page: () => const AuthRegisterView(),
      binding: AuthRegisterBinding(),
    ),
    GetPage(
      name: Routes.AUTH_FORGOT_PASSWORD,
      page: () => const AuthForgotPasswordView(),
      binding: AuthForgotPasswordBinding(),
    ),
    GetPage(
      name: Routes.JOB_SEEKER_DASHBOARD,
      page: () => const JobSeekerDashboardView(),
      binding: JobSeekerDashboardBinding(),
      middlewares: [
        RoleGuardMiddleware(requiredRole: AppUserRole.job_seeker.value),
      ],
    ),
    GetPage(
      name: Routes.JOB_SEEKER_CONGRATULATIONS,
      page: () => const JobSeekerApplyJobView(),
      binding: JobSeekerApplyJobBinding(),
      middlewares: [
        RoleGuardMiddleware(requiredRole: AppUserRole.job_seeker.value),
      ],
    ),
    GetPage(
      name: Routes.JOB_SEEKER_JOB_DETAILS,
      page: () => const JobSeekerJobDetailsView(),
      binding: JobSeekerJobDetailsBinding(),
      middlewares: [
        RoleGuardMiddleware(requiredRole: AppUserRole.job_seeker.value),
      ],
    ),
    GetPage(
      name: Routes.JOB_SEEKER_APPLY_JOB,
      page: () => const JobSeekerApplyJobView(),
      binding: JobSeekerApplyJobBinding(),
      middlewares: [
        RoleGuardMiddleware(requiredRole: AppUserRole.job_seeker.value),
      ],
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      middlewares: [
        RoleGuardMiddleware(requiredRole: AppUserRole.job_seeker.value),
      ],
    ),
    GetPage(
      name: Routes.JOB_SEEKER_MY_APPLICATIONS,
      page: () => const JobSeekerMyApplicationsView(),
      binding: JobSeekerMyApplicationsBinding(),
      middlewares: [
        RoleGuardMiddleware(requiredRole: AppUserRole.job_seeker.value),
      ],
    ),
    GetPage(
      name: Routes.COMPANY_DASHBOARD,
      page: () => const CompanyDashboardView(),
      binding: CompanyDashboardBinding(),
      middlewares: [
        RoleGuardMiddleware(requiredRole: AppUserRole.company.value),
      ],
    ),
    GetPage(
      name: Routes.COMPANY_POST_JOB,
      page: () => const CompanyPostJobView(),
      binding: CompanyPostJobBinding(),
      middlewares: [
        RoleGuardMiddleware(requiredRole: AppUserRole.company.value),
      ],
    ),
    GetPage(
      name: Routes.JOB_SEEKER_MAIN_FIELDS,
      page: () => const JobSeekerMainFieldsView(),
      binding: JobSeekerMainFieldsBinding(),
      middlewares: [
        RoleGuardMiddleware(requiredRole: AppUserRole.job_seeker.value),
      ],
    ),
    GetPage(
      name: Routes.JOB_SEEKER_SAVED_JOBS,
      page: () => const JobSeekerSavedJobsView(),
      binding: JobSeekerSavedJobsBinding(),
      middlewares: [
        RoleGuardMiddleware(requiredRole: AppUserRole.job_seeker.value),
      ],
    ),
    GetPage(
      name: _Paths.MAIN_WRAPPER,
      page: () => const MainWrapperView(),
      binding: MainWrapperBinding(),
      middlewares: [
        RoleGuardMiddleware(requiredRole: AppUserRole.job_seeker.value),
      ],
    ),
    GetPage(
      name: _Paths.APPLICATION_REVIEW,
      page: () => const ApplicationReviewView(),
      binding: ApplicationReviewBinding(),
      middlewares: [
        RoleGuardMiddleware(requiredRole: AppUserRole.company.value),
      ],
    ),
    GetPage(
      name: _Paths.APPLICATION_LIST,
      page: () => const ApplicationListView(),
      binding: ApplicationListBinding(),
      middlewares: [
        RoleGuardMiddleware(requiredRole: AppUserRole.company.value),
      ],
    ),
    GetPage(
      name: _Paths.COMPANY_MAIN_WRAPPER,
      page: () => const CompanyMainWrapperView(),
      binding: CompanyMainWrapperBinding(),
      middlewares: [
        RoleGuardMiddleware(requiredRole: AppUserRole.company.value),
      ],
    ),
    GetPage(
      name: _Paths.COMPANY_CHAT,
      page: () => const CompanyChatView(),
      binding: CompanyChatBinding(),
      middlewares: [
        RoleGuardMiddleware(requiredRole: AppUserRole.company.value),
      ],
    ),
    GetPage(
      name: _Paths.COMPANY_PROFILE,
      page: () => const CompanyProfileView(),
      binding: CompanyProfileBinding(),
      middlewares: [
        RoleGuardMiddleware(requiredRole: AppUserRole.company.value),
      ],
    ),
  ];
}
