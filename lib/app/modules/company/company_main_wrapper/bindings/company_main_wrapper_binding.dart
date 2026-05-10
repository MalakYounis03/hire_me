import 'package:get/get.dart';
import '../../application_list/controllers/application_list_controller.dart';
import '../../company_chat/controllers/company_chat_controller.dart';
import '../../company_profile/controllers/company_profile_controller.dart';
import '../../dashboard/controllers/company_dashboard_controller.dart';
import '../controllers/company_main_wrapper_controller.dart';

class CompanyMainWrapperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompanyMainWrapperController>(
      () => CompanyMainWrapperController(),
    );
    Get.lazyPut<CompanyChatController>(() => CompanyChatController());
    Get.lazyPut<CompanyProfileController>(() => CompanyProfileController());
    Get.lazyPut<CompanyDashboardController>(() => CompanyDashboardController());
    Get.lazyPut<ApplicationListController>(() => ApplicationListController());
  }
}
