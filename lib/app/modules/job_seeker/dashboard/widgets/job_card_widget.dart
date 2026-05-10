import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/core/utils/app_color.dart';
import 'package:hire_me/app/core/utils/app_text_style.dart';
import 'package:hire_me/app/data/models/job_model.dart';
import 'package:hire_me/app/routes/app_pages.dart';

class JobCardWidget extends StatelessWidget {
  final JobModel job;
  final bool isSaved;
  final VoidCallback onSaveTap;

  const JobCardWidget({
    super.key,
    required this.job,
    required this.isSaved,
    required this.onSaveTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.JOB_SEEKER_JOB_DETAILS, arguments: job);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 9),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColor.kwhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColor.Eblack.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _logoBox(),

                const SizedBox(width: 12),

                Expanded(child: _jobMainInfo()),

                IconButton(
                  onPressed: onSaveTap,
                  icon: Icon(
                    isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: AppColor.kblue,
                    size: 27,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Divider(
                color: AppColor.kblue.withOpacity(0.32),
                thickness: 1,
              ),
            ),

            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: AppColor.kblue,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    job.location.isNotEmpty ? job.location : 'Not specified',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColor.greydark, fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              job.salary.isNotEmpty ? job.salary : 'Salary not specified',
              style: TextStyle(
                color: AppColor.kblue,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                _badge(_formatJobType(job.jobType), isPrimary: false),
                const SizedBox(width: 8),
                _badge(job.workMode, isPrimary: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoBox() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColor.Ewhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: job.logoUrl.isNotEmpty
            ? Image.network(
                job.logoUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.business_rounded,
                    color: AppColor.kblue,
                    size: 28,
                  );
                },
              )
            : Icon(Icons.business_rounded, color: AppColor.kblue, size: 28),
      ),
    );
  }

  Widget _jobMainInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          job.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: CustomTextstyle.Poppinssemibold.copyWith(
            fontSize: 16,
            color: AppColor.Eblack,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          job.companyName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: AppColor.greydark, fontSize: 13),
        ),
      ],
    );
  }

  Widget _badge(String text, {required bool isPrimary}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
        color: isPrimary ? AppColor.kblue : AppColor.kwhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.kblue),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isPrimary ? AppColor.kwhite : AppColor.kblue,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatJobType(String value) {
    if (value == 'FullTime') return 'Full time';
    if (value == 'PartTime') return 'Part time';
    return value;
  }
}
