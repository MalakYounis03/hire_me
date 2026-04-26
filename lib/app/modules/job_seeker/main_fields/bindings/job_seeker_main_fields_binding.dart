import 'package:get/get.dart';

import '../controllers/job_seeker_main_fields_controller.dart';

class JobSeekerMainFieldsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobSeekerMainFieldsController>(
      () => JobSeekerMainFieldsController(),
    );
  }
}
