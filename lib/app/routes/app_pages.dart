import 'package:get/get.dart';

import '../modules/auth/forgot_password/bindings/auth_forgot_password_binding.dart';
import '../modules/auth/forgot_password/views/auth_forgot_password_view.dart';
import '../modules/auth/login/bindings/auth_login_binding.dart';
import '../modules/auth/login/views/auth_login_view.dart';
import '../modules/auth/register/bindings/auth_register_binding.dart';
import '../modules/auth/register/views/auth_register_view.dart';
import '../modules/auth/role_selector/bindings/auth_role_selector_binding.dart';
import '../modules/auth/role_selector/views/auth_role_selector_view.dart';
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
import '../modules/job_seeker/main_fields/bindings/job_seeker_main_fields_binding.dart';
import '../modules/job_seeker/main_fields/views/job_seeker_main_fields_view.dart';
import '../modules/job_seeker/my_applications/bindings/job_seeker_my_applications_binding.dart';
import '../modules/job_seeker/my_applications/views/job_seeker_my_applications_view.dart';
import '../modules/job_seeker/profile/bindings/job_seeker_profile_binding.dart';
import '../modules/job_seeker/profile/views/job_seeker_profile_view.dart';
import '../modules/job_seeker/saved_jobs/bindings/job_seeker_saved_jobs_binding.dart';
import '../modules/job_seeker/saved_jobs/views/job_seeker_saved_jobs_view.dart';
import '../modules/main_wrapper/bindings/main_wrapper_binding.dart';
import '../modules/main_wrapper/views/main_wrapper_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING;

  static final routes = [
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
      name: Routes.AUTH_ROLE_SELECTOR,
      page: () => const AuthRoleSelectorView(),
      binding: AuthRoleSelectorBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.JOB_SEEKER_DASHBOARD,
      page: () => const JobSeekerDashboardView(),
      binding: JobSeekerDashboardBinding(),
    ),
    GetPage(
      name: Routes.JOB_SEEKER_JOB_DETAILS,
      page: () => const JobSeekerJobDetailsView(),
      binding: JobSeekerJobDetailsBinding(),
    ),
    GetPage(
      name: Routes.JOB_SEEKER_APPLY_JOB,
      page: () => const JobSeekerApplyJobView(),
      binding: JobSeekerApplyJobBinding(),
    ),
    GetPage(
      name: Routes.JOB_SEEKER_PROFILE,
      page: () => const JobSeekerProfileView(),
      binding: JobSeekerProfileBinding(),
    ),
    GetPage(
      name: Routes.JOB_SEEKER_MY_APPLICATIONS,
      page: () => const JobSeekerMyApplicationsView(),
      binding: JobSeekerMyApplicationsBinding(),
    ),
    GetPage(
      name: Routes.COMPANY_DASHBOARD,
      page: () => const CompanyDashboardView(),
      binding: CompanyDashboardBinding(),
    ),
    GetPage(
      name: Routes.COMPANY_POST_JOB,
      page: () => const CompanyPostJobView(),
      binding: CompanyPostJobBinding(),
    ),
    GetPage(
      name: Routes.COMPANY_APPLICANTS,
      page: () => const CompanyApplicantsView(),
      binding: CompanyApplicantsBinding(),
    ),
    GetPage(
      name: Routes.JOB_SEEKER_MAIN_FIELDS,
      page: () => const JobSeekerMainFieldsView(),
      binding: JobSeekerMainFieldsBinding(),
    ),

    GetPage(
      name: Routes.JOB_SEEKER_SAVED_JOBS,
      page: () => const JobSeekerSavedJobsView(),
      binding: JobSeekerSavedJobsBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_WRAPPER,
      page: () => const MainWrapperView(),
      binding: MainWrapperBinding(),
    ),
  ];
}
