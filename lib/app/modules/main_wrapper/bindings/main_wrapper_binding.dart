// lib/app/modules/main_wrapper/bindings/main_wrapper_binding.dart
import 'package:get/get.dart';
import 'package:hire_me/app/modules/job_seeker/chat/controllers/chat_controller.dart';
import '../../job_seeker/dashboard/controllers/job_seeker_dashboard_controller.dart';
import '../controllers/main_wrapper_controller.dart';

class MainWrapperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainWrapperController>(() => MainWrapperController());
    // إضافة هذا السطر لحل مشكلة الخطأ الأحمر في الصورة الأخيرة
    Get.lazyPut<JobSeekerDashboardController>(
      () => JobSeekerDashboardController(),
    );
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
