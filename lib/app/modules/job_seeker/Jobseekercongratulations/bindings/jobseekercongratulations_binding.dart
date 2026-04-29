import 'package:get/get.dart';

import '../controllers/jobseekercongratulations_controller.dart';

class JobseekercongratulationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobseekercongratulationsController>(
      () => JobseekercongratulationsController(),
    );
  }
}
