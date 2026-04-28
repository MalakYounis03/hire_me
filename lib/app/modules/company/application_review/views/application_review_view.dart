import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hire_me/app/modules/company/application_review/controllers/application_review_controller.dart';
import 'package:hire_me/app/modules/company/application_review/model/application_review_model.dart';
import 'package:hire_me/app/modules/company/application_review/views/widgets/divider_widget.dart';
import 'package:hire_me/app/modules/company/application_review/views/widgets/info_card.dart';
import 'package:hire_me/app/modules/company/application_review/views/widgets/profile_card.dart';
import 'package:hire_me/app/modules/company/application_review/views/widgets/review_app_bar.dart';
import 'package:hire_me/core/utils/app_color.dart';

class ApplicationReviewView extends GetView<ApplicationReviewController> {
  const ApplicationReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final applicant = Get.arguments as ApplicationReviewModel;

    return Scaffold(
      backgroundColor: AppColor.ewhite,
      appBar: ReviewAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ProfileCard(applicant: applicant),
                  const SizedBox(height: 12),
                  InfoCard(applicant: applicant),
                ],
              ),
            ),
          ),
          ActionButtons(applicant: applicant),
        ],
      ),
    );
  }
}
