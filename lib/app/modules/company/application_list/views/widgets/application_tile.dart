import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/core/utils/app_color.dart';
import 'package:hire_me/app/modules/company/application_list/model/application_list_model.dart';
import 'package:hire_me/app/modules/company/application_list/views/widgets/application_avatar.dart';
import 'package:hire_me/app/modules/company/application_list/views/widgets/application_info.dart';
import 'package:hire_me/app/modules/company/application_review/views/application_review_view.dart';

class ApplicantTile extends StatelessWidget {
  final ApplicationListModel applicant;
  const ApplicantTile({required this.applicant, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColor.kwhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.greyVeryLight),
      ),
      child: InkWell(
        onTap: () {
          Get.to(() => ApplicationReviewView());
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              ApplicantAvatar(name: applicant.name, url: applicant.avatarUrl),
              const SizedBox(width: 12),
              Expanded(
                child: ApplicantInfo(
                  name: applicant.name,
                  jobTitle: applicant.jobTitle,
                  location: applicant.location,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    applicant.appliedAt,
                    style: TextStyle(fontSize: 11, color: AppColor.greyLight),
                  ),
                  const SizedBox(height: 16),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColor.greyLight,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
