import 'package:flutter/material.dart';
import 'package:hire_me/app/modules/company/application_review/model/application_review_model.dart';
import 'package:hire_me/app/modules/company/application_review/views/widgets/divider_widget.dart';
import 'package:hire_me/app/modules/company/application_review/views/widgets/info_row.dart';
import 'package:hire_me/core/utils/app_color.dart';

class InfoCard extends StatelessWidget {
  final ApplicationReviewModel applicant;
  const InfoCard({required this.applicant, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.kwhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.greyVeryLight),
      ),
      child: Column(
        children: [
          InfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: applicant.email,
            trailing: Icon(
              Icons.mail_outline_rounded,
              size: 18,
              color: AppColor.kblue,
            ),
          ),
          DividerWidget(),
          InfoRow(
            icon: Icons.psychology_outlined,
            label: 'Skills',
            value: applicant.skills,
            trailing: Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColor.greyLight,
            ),
          ),
          DividerWidget(),
          InfoRow(
            icon: Icons.work_history_outlined,
            label: 'Experience',
            value: applicant.experience,
          ),
          DividerWidget(),
          InfoRow(
            icon: Icons.school_outlined,
            label: 'Education',
            value: applicant.education,
          ),
          DividerWidget(),
          InfoRow(
            icon: Icons.insert_drive_file_outlined,
            label: 'Resume',
            value: '',
            trailing: GestureDetector(
              onTap: () {
                // فتح الـ CV
              },
              child: Row(
                children: [
                  Text(
                    'View CV',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColor.kblue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.open_in_new_rounded,
                    size: 14,
                    color: AppColor.kblue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
