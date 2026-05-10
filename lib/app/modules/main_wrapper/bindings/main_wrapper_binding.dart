// lib/app/modules/main_wrapper/bindings/main_wrapper_binding.dart
import 'package:get/get.dart';
import 'package:hire_me/app/modules/job_seeker/chat/controllers/chat_controller.dart';
import 'package:hire_me/app/modules/profile/controllers/profile_controller.dart';
import '../../job_seeker/dashboard/controllers/job_seeker_dashboard_controller.dart';
import '../controllers/main_wrapper_controller.dart';

class MainWrapperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainWrapperController>(() => MainWrapperController());
    Get.lazyPut<JobSeekerDashboardController>(
      () => JobSeekerDashboardController(),
    );
    Get.put<ChatController>(ChatController());
    Get.put<ProfileController>(ProfileController());
  }
}
