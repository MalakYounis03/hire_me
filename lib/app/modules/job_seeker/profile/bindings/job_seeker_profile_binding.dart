import 'package:get/get.dart';

import '../controllers/job_seeker_profile_controller.dart';

class JobSeekerProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobSeekerProfileController>(
      () => JobSeekerProfileController(),
    );
  }
}
