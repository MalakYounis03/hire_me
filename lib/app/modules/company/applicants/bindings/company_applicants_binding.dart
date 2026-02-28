import 'package:get/get.dart';

import '../controllers/company_applicants_controller.dart';

class CompanyApplicantsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompanyApplicantsController>(
      () => CompanyApplicantsController(),
    );
  }
}
