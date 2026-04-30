import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hire_me/app/core/utils/app_color.dart';
import '../model/application_review_model.dart';

class ApplicationReviewController extends GetxController {
  late Rx<ApplicationReviewModel> applicant;

  @override
  void onInit() {
    super.onInit();
    _initializeApplicant();
  }

  void _initializeApplicant() {
    if (Get.arguments != null && Get.arguments is ApplicationReviewModel) {
      applicant = (Get.arguments as ApplicationReviewModel).obs;
    } else {
      applicant = ApplicationReviewModel(
        id: '0',
        name: 'Unknown',
        jobTitle: 'Unknown',
        location: 'Unknown',
        email: 'Unknown',
        skills: 'Unknown',
        experience: 'Unknown',
        education: 'Unknown',
        cvUrl: '',
        appliedAt: '',
      ).obs;
    }
  }

  void acceptApplicant() {
    Get.snackbar(
      'Success',
      '${applicant.value.name} has been accepted!',
      backgroundColor: AppColor.ksuccess,
      colorText: AppColor.kwhite,
      duration: const Duration(seconds: 2),
    );
  }

  void rejectApplicant() {
    Get.snackbar(
      'Rejected',
      '${applicant.value.name} has been rejected.',
      backgroundColor: AppColor.kdanger,
      colorText: AppColor.kwhite,
      duration: const Duration(seconds: 2),
    );
  }
}
