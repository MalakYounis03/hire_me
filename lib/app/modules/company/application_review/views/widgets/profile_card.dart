import 'package:flutter/material.dart';
import 'package:hire_me/app/modules/company/application_review/model/application_review_model.dart';
import 'package:hire_me/core/utils/app_color.dart';

class ProfileCard extends StatelessWidget {
  final ApplicationReviewModel applicant;
  const ProfileCard({required this.applicant, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColor.kwhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.greyVeryLight),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: applicant.avatarUrl.isNotEmpty
                ? NetworkImage(applicant.avatarUrl)
                : null,
            backgroundColor: AppColor.offWhite,
            child: applicant.avatarUrl.isEmpty
                ? Text(
                    applicant.name.isNotEmpty
                        ? applicant.name[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColor.kblue,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 10),
          Text(
            applicant.name,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColor.kblack,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            applicant.jobTitle,
            style: TextStyle(fontSize: 13, color: AppColor.greydark),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: AppColor.greyLight,
              ),
              const SizedBox(width: 2),
              Text(
                applicant.location,
                style: TextStyle(fontSize: 13, color: AppColor.greyLight),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
